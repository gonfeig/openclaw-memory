#!/bin/bash
# monthly_snapshot.sh - 每月快照：创建月度 tag，推送冷归档
# 每月 1 日 23:00 北京时间触发
# 凭证通过 git credential helper 管理

REPO="/root/.openclaw"
YEAR=$(date +%Y)
MONTH=$(date +%m)
MONTHLY_TAG="v-${YEAR}-${MONTH}-monthly"
ARCHIVE_BRANCH="archive/${YEAR}-${MONTH}"

cd "$REPO"
git remote set-url origin https://github.com/gonfeig/openclaw-memory.git 2>/dev/null

git checkout main

# 创建月度归档分支
git branch "$ARCHIVE_BRANCH" main 2>/dev/null
git checkout "$ARCHIVE_BRANCH"

# 推送冷归档分支
git push origin "$ARCHIVE_BRANCH" 2>/dev/null

# 创建月度 tag
git tag -a "$MONTHLY_TAG" -m "Monthly snapshot ${YEAR}-${MONTH}" 2>/dev/null
git push origin "refs/tags/${MONTHLY_TAG}" 2>/dev/null

# 切回 main
git checkout main

echo "Monthly snapshot ${MONTHLY_TAG} completed"
