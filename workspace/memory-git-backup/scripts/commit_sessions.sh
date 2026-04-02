#!/bin/bash
# commit_sessions.sh - 每次对话结束后自动 commit sessions 到 git
# 由 cron 每5分钟检测触发
# 凭证通过 git credential helper 管理（~/.git-credentials）

REPO="/root/.openclaw"
TODAY=$(date +%Y-%m-%d)
TODAY_SESSIONS_BRANCH="sessions/${TODAY}"
SESSION_DIR="${REPO}/agents/sessions"
MEMORY_GIT_BACKUP="${REPO}/workspace/memory-git-backup"

cd "$REPO"

# 检查是否有新的或修改的 session 文件
NEW_SESSIONS=$(find "$SESSION_DIR" -name "*.jsonl" -newer "$MEMORY_GIT_BACKUP/last_commit_${TODAY}.lock" 2>/dev/null | head -20)

if [ -z "$NEW_SESSIONS" ]; then
    echo "No new sessions to commit"
    exit 0
fi

# 设置 remote URL（凭证由 git credential helper 自动注入）
git remote set-url origin https://github.com/gonfeig/openclaw-memory.git 2>/dev/null

# 确保今天的 sessions 分支存在
if ! git rev-parse --verify "$TODAY_SESSIONS_BRANCH" >/dev/null 2>&1; then
    git branch "$TODAY_SESSIONS_BRANCH" main 2>/dev/null
fi

git checkout "$TODAY_SESSIONS_BRANCH" 2>/dev/null

# 复制 session 文件到备份目录
mkdir -p "$MEMORY_GIT_BACKUP/sessions/${TODAY}"
for f in $NEW_SESSIONS; do
    cp "$f" "$MEMORY_GIT_BACKUP/sessions/${TODAY}/" 2>/dev/null
done

# 添加并 commit
git add "workspace/memory-git-backup/sessions/${TODAY}/"
git commit -m "feat(session): ${TODAY} 对话记录

- sessions: $(echo $NEW_SESSIONS | wc -w) 个文件更新
- commit_time: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null

# 推送
git push -u origin "$TODAY_SESSIONS_BRANCH" 2>/dev/null

# 切回 main
git checkout main 2>/dev/null

# 记录最后检查时间
touch "$MEMORY_GIT_BACKUP/last_commit_${TODAY}.lock"

echo "Sessions committed for ${TODAY}"
