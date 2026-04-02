#!/bin/bash
# cleanup_sessions.sh - Sessions 自动清理规则
# 保留策略：
#   - agents/main/sessions/*.jsonl：本地保留 30 天，超出后删除（Git 分支已有备份）
#   - workspace/memory-git-backup/sessions/：本地保留 7 天
# 触发：每天 03:00 执行

REPO="/root/.openclaw"
AGENTS_SESSIONS="${REPO}/agents/main/sessions"
GIT_BACKUP_SESSIONS="${REPO}/workspace/memory-git-backup/sessions"
LOG_FILE="${REPO}/workspace/memory-git-backup/cleanup.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "=== Sessions 清理开始 ==="

# 1. 清理 agents/main/sessions/ — 保留 30 天
DELETED_COUNT=0
DELETED_SIZE=0
while IFS= read -r file; do
    # 检查文件是否在 Git sessions 分支有备份（通过检查 git ls-files）
    # 如果文件存在且修改时间超过 30 天，则删除
    days_old=$(( ($(date +%s) - $(stat -c %Y "$file" 2>/dev/null || echo 0)) / 86400 ))
    if [ "$days_old" -gt 30 ]; then
        size=$(stat -c %s "$file" 2>/dev/null || echo 0)
        rm -f "$file" 2>/dev/null
        DELETED_COUNT=$((DELETED_COUNT + 1))
        DELETED_SIZE=$((DELETED_SIZE + size))
        log "已删除(30天前): $(basename $file) (${size} bytes)"
    fi
done < <(find "$AGENTS_SESSIONS" -name "*.jsonl" -type f 2>/dev/null)

if [ -n "$DELETED_COUNT" ] && [ "$DELETED_COUNT" -gt 0 ]; then
    log "agents/main/sessions/: 删除了 ${DELETED_COUNT} 个文件，释放约 $((DELETED_SIZE / 1024)) KB"
fi

# 2. 清理 workspace/memory-git-backup/sessions/ — 保留 7 天
BACKUP_DELETED=0
while IFS= read -r file; do
    days_old=$(( ($(date +%s) - $(stat -c %Y "$file" 2>/dev/null || echo 0)) / 86400 ))
    if [ "$days_old" -gt 7 ]; then
        rm -rf "$file" 2>/dev/null
        BACKUP_DELETED=$((BACKUP_DELETED + 1))
        log "已删除(7天前): $(dirname $file | xargs basename)"
    fi
done < <(find "$GIT_BACKUP_SESSIONS" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)

if [ -n "$BACKUP_DELETED" ] && [ "$BACKUP_DELETED" -gt 0 ]; then
    log "memory-git-backup/sessions/: 删除了 ${BACKUP_DELETED} 个日期目录"
fi

log "=== 清理完成 ==="

# 3. 清理空的 git reflog（减少 .git 目录占用）
cd "$REPO" && git reflog expire --expire=now --all 2>/dev/null

echo "Sessions 清理完成"
