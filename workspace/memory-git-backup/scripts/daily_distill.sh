#!/bin/bash
# daily_distill.sh - 每日蒸馏 + 主动关联 + 热度调整
# 每天 21:00 北京时间触发
# 凭证通过 git credential helper 管理

REPO="/root/.openclaw"
TODAY=$(date +%Y-%m-%d)
MEMORY_GIT_BACKUP="${REPO}/workspace/memory-git-backup"

cd "$REPO"

# 设置 remote URL
git remote set-url origin https://github.com/gonfeig/openclaw-memory.git 2>/dev/null

# 切换到 main
git checkout main

# ========== 1. 读取当天 sessions ==========
SESSION_DIR="${REPO}/agents/main/sessions"
TODAY_SESSIONS=$(find "$SESSION_DIR" -name "*.jsonl" -newer "$MEMORY_GIT_BACKUP/last_distill.lock" 2>/dev/null | head -10)

if [ -z "$TODAY_SESSIONS" ]; then
    echo "No new sessions since last distill"
    exit 0
fi

SESSION_COUNT=$(echo $TODAY_SESSIONS | wc -w)

# ========== 2. 提取关键信息（简化为关键词检测）==========
# 检测今日对话中的关键主题
KEY_TOPICS=""
[ -n "$(echo $TODAY_SESSIONS | xargs grep -l 'git\|Git\|仓库' 2>/dev/null)" ] && KEY_TOPICS="${KEY_TOPICS}Git "
[ -n "$(echo $TODAY_SESSIONS | xargs grep -l '定时\|cron\|任务' 2>/dev/null)" ] && KEY_TOPICS="${KEY_TOPICS}定时任务 "
[ -n "$(echo $TODAY_SESSIONS | xargs grep -l '记忆\|memory\|MEMORY' 2>/dev/null)" ] && KEY_TOPICS="${KEY_TOPICS}记忆系统 "
[ -n "$(echo $TODAY_SESSIONS | xargs grep -l 'skill\|Skill\|技能' 2>/dev/null)" ] && KEY_TOPICS="${KEY_TOPICS}技能 "
[ -n "$(echo $TODAY_SESSIONS | xargs grep -l 'NBA\|哈登\|骑士' 2>/dev/null)" ] && KEY_TOPICS="${KEY_TOPICS}NBA "
[ -n "$(echo $TODAY_SESSIONS | xargs grep -l 'IMA\|ima\|笔记' 2>/dev/null)" ] && KEY_TOPICS="${KEY_TOPICS}IMA笔记 "
[ -n "$(echo $TODAY_SESSIONS | xargs grep -l '方案\|确认\|确认写入' 2>/dev/null)" ] && KEY_TOPICS="${KEY_TOPICS}方案确认 "

# ========== 3. 生成每日蒸馏文件 ==========
DAILY_FILE="${REPO}/workspace/memory/daily/${TODAY}.md"
cat > "$DAILY_FILE" << EOF
# 【每日复盘】${TODAY}

## 对话统计
- Session 文件数：${SESSION_COUNT}

## 关键主题
$(echo "$KEY_TOPICS" | tr ' ' '\n' | sed 's/^/- /')

## 重要决策
$(git log --oneline --since="${TODAY} 00:00" --until="${TODAY} 23:59" 2>/dev/null | head -5 | sed 's/^/  - /')

## 备注
- 自动蒸馏生成于 $(date '+%Y-%m-%d %H:%M:%S')
EOF

# ========== 4. 更新 MEMORY.md 中的 cron 任务状态（如有）==========
# 检测是否有新的定时任务创建
NEW_CRON=$(grep -l "cron add\|创建.*任务" $TODAY_SESSIONS 2>/dev/null | head -1)
if [ -n "$NEW_CRON" ]; then
    echo "- [${TODAY}] 检测到新增定时任务，请人工确认后更新 MEMORY.md 定时任务清单" >> "$DAILY_FILE"
fi

# ========== 5. 热度调整检测 ==========
# 检查 scene_blocks 是否有超30天未更新的高热度块
SCENE_DIR="${REPO}/memory-tdai/scene_blocks"
for block in "$SCENE_DIR"/*.md; do
    [ -f "$block" ] || continue
    filename=$(basename "$block" .md)

    # 检查是否在 KEY_TOPICS 中（今日提及）
    if echo "$KEY_TOPICS" | grep -q "${filename}"; then
        # 热度 +1（通过 sed 调整 META 中的 heat 值）
        sed -i "s/^heat: \([0-9]*\)$/heat: \1+1/e" "$block" 2>/dev/null || true
    fi

    # 检查最后更新时间（超30天未更新则标记）
    last_updated=$(grep "^updated:" "$block" | head -1 | awk '{print $2}')
    if [ -n "$last_updated" ]; then
        days_since=$(( ($(date +%s) - $(date -d "$last_updated" +%s 2>/dev/null || echo 0) ) / 86400 ))
        if [ "$days_since" -gt 30 ]; then
            echo "- [警告] ${filename} 已 ${days_since} 天未更新，热度可能衰减，请考虑归档" >> "$DAILY_FILE"
        fi
    fi
done

# ========== 6. 提交到 main ==========
git add "workspace/memory/daily/${TODAY}.md"
git commit -m "docs(daily): ${TODAY} 每日蒸馏

- Session 文件: ${SESSION_COUNT} 个
- 关键主题: ${KEY_TOPICS:-无}
- 自动生成于 $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main 2>/dev/null

# ========== 7. 更新最后蒸馏时间 ==========
touch "$MEMORY_GIT_BACKUP/last_distill.lock"

echo "Daily distill completed for ${TODAY}"
echo "Key topics: ${KEY_TOPICS:-无}"
