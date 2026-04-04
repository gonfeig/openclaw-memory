#!/bin/bash
# /root/.openclaw/workspace/scripts/gateway-restart.sh
# Gateway 重启脚本，重启完成后主动通知 gonfeig

GATEWAY_URL="http://localhost:13692"
FEISHU_USER="user:ou_5ababf78dba78d9324d26cd8dbc7a3db"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始重启 Gateway..."
openclaw gateway restart 2>&1

# 等待 gateway 就绪（最多60秒）
for i in $(seq 1 60); do
  sleep 1
  if curl -s "$GATEWAY_URL/health" >/dev/null 2>&1; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Gateway 已就绪"
    break
  fi
done

# 通过 Feishu 通知 gonfeig
curl -s -X POST "$GATEWAY_URL/api/announce" \
  -H "Content-Type: application/json" \
  -d "{\"channel\":\"feishu\",\"to\":\"$FEISHU_USER\",\"message\":\"✅ Gateway 已重启完成（$(date '+%Y-%m-%d %H:%M:%S')），当前运行正常。\"}" \
  >/dev/null 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] 通知已发送"
