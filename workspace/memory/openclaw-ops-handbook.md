# OpenClaw 部署操作手册 - 知识库
> 来源：飞书文档 https://ocn5cd0hqqqr.feishu.cn/docx/FsqBdFfaLoBpBjxLEzhcLTUwnCT
> 同步时间：2026-03-29

## 环境概述

### 主人部署环境摘要
| 项目 | 配置 |
|------|------|
| 操作系统 | Debian GNU/Linux 12 (Bookworm) |
| Node.js | v24.14.0 |
| npm | 11.9.0 |
| pnpm | ✓ 已安装 |
| OpenClaw | 2026.3.24 (stable) |
| Gateway 端口 | 13692 |
| Gateway 绑定 | lan (可从局域网访问) |

### 已启用渠道
| 渠道 | 状态 | 备注 |
|------|------|------|
| Feishu (飞书) | ✅ OK | App ID: cli_a94d788c1d38dbb4 |
| DingTalk (钉钉) | ✅ OK | Client ID: ding5no1ockgnkymzhgl |

### 已安装插件
| 插件 | 版本 | 状态 |
|------|------|------|
| @largezhou/ddingtalk | 2.0.1 | ✅ 已启用 |
| @larksuite/openclaw-lark | 2026.3.26 | ✅ 已启用 |

---

## 核心运维命令

### Gateway 管理
```bash
# 启动/停止/重启
openclaw gateway start
openclaw gateway stop
openclaw gateway restart

# 状态查看
openclaw status
openclaw status --all

# 实时日志
openclaw logs --follow

# 诊断
openclaw doctor
openclaw doctor --deep
```

### 插件管理
```bash
openclaw plugin install ddingtalk
openclaw plugin install openclaw-lark
openclaw plugin update
openclaw plugin update ddingtalk
```

### 配置管理
```bash
# 备份配置
cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.bak

# 验证配置语法
cat ~/.openclaw/openclaw.json | python3 -m json.tool
```

### 端口检查
```bash
lsof -i :13692
netstat -tlnp | grep 13692
```

---

## 常见故障排查

### Q1: Gateway 无法启动？
```bash
# 1. 检查端口占用
lsof -i :13692

# 2. 检查配置文件语法
cat ~/.openclaw/openclaw.json | python3 -m json.tool

# 3. 查看错误日志
openclaw logs 2>&1 | tail -50
```

### Q2: 渠道连接失败？
**飞书检查：**
```bash
curl -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
  -H "Content-Type: application/json" \
  -d '{"app_id": "cli_xxx", "app_secret": "xxx"}'
```

**钉钉检查：**
```bash
curl -X POST "https://api.dingtalk.com/v1.0/oauth2/accessToken" \
  -H "Content-Type: application/json" \
  -d '{"appKey": "xxx", "appSecret": "xxx"}'
```

### Q3: 模型调用失败？
检查 API Key 是否有效，尝试手动调用 API 测试。

### Q4: 完全重置？
```bash
# 1. 停止服务
openclaw gateway stop

# 2. 备份数据
mv ~/.openclaw ~/.openclaw.backup

# 3. 重新初始化
openclaw onboard
```

---

## 安全配置要点

- `gateway.bind`: 生产环境应改为 `loopback`（如无需远程访问）
- `dangerouslyDisableDeviceAuth`: 生产环境应关闭
- Token 定期轮换：每 90 天更换一次
- allowedOrigins: 仅允许必要 IP
- 使用 HTTPS: 通过 Nginx/Caddy 反向代理

---

## openclaw.json 关键配置结构

```json
{
  "meta": {
    "lastTouchedVersion": "2026.3.24",
    "lastTouchedAt": "2026-03-29T00:00:00.000Z"
  },
  "channels": {
    "feishu": {
      "enabled": true,
      "appId": "YOUR_FEISHU_APP_ID",
      "appSecret": "YOUR_FEISHU_APP_SECRET"
    },
    "ddingtalk": {
      "enabled": true,
      "clientId": "YOUR_DINGTALK_CLIENT_ID",
      "clientSecret": "YOUR_DINGTALK_CLIENT_SECRET"
    }
  },
  "gateway": {
    "port": 13692,
    "bind": "lan",
    "auth": {
      "mode": "token",
      "token": "YOUR_STRONG_TOKEN"
    }
  },
  "plugins": {
    "allow": ["ddingtalk", "openclaw-lark"],
    "entries": {
      "ddingtalk": {"enabled": true},
      "openclaw-lark": {"enabled": true}
    }
  }
}
```

---

## 定时任务 (Cron) 配置

### 当前定时任务
- **早安问候**: ID `82bba9d8-2f60-476e-924b-8195c7148b10`，每天 7:00 (Asia/Shanghai)
- **詹姆斯·哈登 NBA资讯**: ID `20c8443c-4cbf-4ef0-8d4e-a7b313a8302d`，每天 8:00 (Asia/Shanghai)

### 相关命令
```bash
openclaw cron list
openclaw cron edit <id> --cron "0 7 * * *"
openclaw cron edit <id> --timeout-seconds 300
```

---

## 更新日志
| 日期 | 版本 | 变更内容 |
|------|------|----------|
| 2026-03-29 | 1.0.0 | 初始文档创建 |
