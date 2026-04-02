#!/bin/bash
# daily_distill.sh - 每日蒸馏：读取当天 sessions，生成蒸馏记忆，写入 main 分支
# 每天 21:00 北京时间触发
# 凭证通过 git credential helper 管理

REPO="/root/.openclaw"
TODAY=$(date +%Y-%m-%d)
DAILY_FILE="${REPO}/workspace/memory/daily/${TODAY}.md"
MEMORY_GIT_BACKUP="${REPO}/workspace/memory-git-backup"

cd "$REPO"

# 设置 remote URL
git remote set-url origin https://github.com/gonfeig/openclaw-memory.git 2>/dev/null

# 切换到 main
git checkout main

# 生成每日蒸馏摘要
SESSION_DIR="${REPO}/agents/sessions"
TODAY_SESSIONS=$(find "$SESSION_DIR" -name "*.jsonl" -newer "$MEMORY_GIT_BACKUP/last_distill.lock" 2>/dev/null | head -10)

if [ -z "$TODAY_SESSIONS" ]; then
    echo "No new sessions since last distill"
    exit 0
fi

SESSION_COUNT=$(echo $TODAY_SESSIONS | wc -w)

# 更新每日 memory 文件
cat > "$DAILY_FILE" << EOF
# 【每日复盘】${TODAY}

## 对话统计
- Session 文件数：${SESSION_COUNT}

## 重要事件
$(git log --oneline --since="${TODAY} 00:00" --until="${TODAY} 23:59" 2>/dev/null | head -5 | sed 's/^/  - /')

## 备注
- 自动蒸馏生成于 $(date '+%Y-%m-%d %H:%M:%S')
EOF

# 添加并 commit
git add "workspace/memory/daily/${TODAY}.md"
git commit -m "docs(daily): ${TODAY} 每日蒸馏

- 新增文件: ${SESSION_COUNT} 个 session 文件
- 蒸馏时间: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main 2>/dev/null

# 更新最后蒸馏时间
touch "$MEMORY_GIT_BACKUP/last_distill.lock"

echo "Daily distill completed for ${TODAY}"
