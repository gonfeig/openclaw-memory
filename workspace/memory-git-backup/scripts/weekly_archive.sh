#!/bin/bash
# weekly_archive.sh - 每周日归档：合并 sessions 分支到 weekly，创建周 tag
# 每周日 22:00 北京时间触发
# 凭证通过 git credential helper 管理

REPO="/root/.openclaw"
YEAR=$(date +%Y)
WEEK=$(date +%Y-W%V)
SUNDAY_DATE=$(date -d sunday +%Y-%m-%d)
WEEKLY_BRANCH="weekly/${WEEK}"

cd "$REPO"
git remote set-url origin https://github.com/gonfeig/openclaw-memory.git 2>/dev/null

# 创建本周 weekly 分支（基于 main）
git checkout main
git branch "$WEEKLY_BRANCH" 2>/dev/null
git checkout "$WEEKLY_BRANCH"

# 合并本周所有 sessions 分支
for SESSION_BRANCH in $(git branch --list 'sessions/2026-*' | grep -E "sessions/${YEAR}-" | sort); do
    git merge --no-edit "$SESSION_BRANCH" 2>/dev/null
done

# 生成周报
WEEKLY_REPORT="${REPO}/workspace/memory/weekly/${WEEK}.md"
mkdir -p "$(dirname $WEEKLY_REPORT)"
cat > "$WEEKLY_REPORT" << EOF
# 【周归档】${WEEK}

## 本周会话
- 汇总时间：${SUNDAY_DATE}

## 合并的 sessions 分支
$(git branch --list 'sessions/2026-*' | grep -E "sessions/${YEAR}-" | sort | sed 's/^/  - /')

## 本周主要活动
$(git log --oneline --since="${YEAR}-01-01" --until="${SUNDAY_DATE}" | head -10 | sed 's/^/  - /')

## Tag
- 周快照：v:${WEEK}

EOF

git add "workspace/memory/weekly/${WEEK}.md"
git commit -m "docs(weekly): ${WEEK} 周归档
- 本周 sessions 已合并
- 周快照 tag: v:${WEEK}" 2>/dev/null

# 创建 tag
git tag -a "v:${WEEK}" -m "Weekly snapshot ${WEEK}" 2>/dev/null

# 推送
git push origin "$WEEKLY_BRANCH" 2>/dev/null
git push origin --tags 2>/dev/null

# 切回 main
git checkout main

echo "Weekly archive ${WEEK} completed"
