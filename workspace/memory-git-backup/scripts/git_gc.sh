#!/bin/bash
# git_gc.sh - 每季度空间优化：git gc 压缩历史
# 每季度 1 日执行
# 凭证通过 git credential helper 管理

REPO="/root/.openclaw"

cd "$REPO"
git remote set-url origin https://github.com/gonfeig/openclaw-memory.git 2>/dev/null

echo "Starting git gc..."
git gc --aggressive --prune=6months

echo "Git gc completed"
