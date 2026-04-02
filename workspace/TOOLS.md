# TOOLS.md - 本地工具配置

本文件是 gonfeig 环境的专属配置，skills 共享，本地文件不共享。

---

## 系统环境

| 项目 | 值 |
|------|-----|
| OS | Debian 12（Linux 6.8+） |
| Node | v22+ |
| OpenClaw | 2026.3.x |
| 工作目录 | /root/.openclaw |
| Gateway | 0.0.0.0:13692 |

---

## 通知渠道

| 渠道 | 用途 | 配置 |
|------|------|------|
| 飞书 | 主力通知 | 已配置（primary） |
| 钉钉 | 辅助通知 | 已配置 |
| 微信 | 备用 | 未配置 |
| QQ | 备用 | 未配置 |

---

## Git 配置

| 项目 | 值 |
|------|-----|
| 用户名 | gonfeig |
| Email | gonfeig@openclaw.ai |
| 默认分支 | main |
| 仓库 | github.com/gonfeig/openclaw-memory |
| 凭证 | git credential helper（~/.git-credentials） |

---

## IMA 笔记配置

| 项目 | 值 |
|------|-----|
| Client ID | ~/.config/ima/client_id |
| API Key | ~/.config/ima/api_key |
| Skill 路径 | workspace/skills/ima/ |
| 模块 | notes（笔记）、knowledge-base（知识库） |

---

## 定时任务清单

| 任务 | ID | 触发时间 |
|------|-----|---------|
| 早安问候 | 82bba9d8-2f60-476e-924b-8195c7148b10 | 每天 07:00 北京时间 |
| 詹姆斯·哈登 NBA 资讯 | 20c8443c-4cbf-4ef0-8d4e-a7b313a8302d | 每天 08:00 北京时间 |
| 每日对话回顾 | 4c00cdc1-c146-40bb-b080-9b04f59180de | 每天 21:00 北京时间 |
| Git Sessions Commit | b0bb7220-8c70-4d8d-8be9-6eef18c19cb4 | 每 5 分钟 |
| 每日记忆蒸馏 | 1578ba4d-dd1b-4e2d-aeba-4f6cea565afa | 每天 21:00 北京时间 |
| 每周记忆归档 | c3dc2b66-f873-4541-9b2e-086bef2704cb | 每周日 22:00 北京时间 |
| 每月记忆快照 | f5eb2f71-e081-4782-ba2c-cde9973134f5 | 每月 1 日 23:00 |
| Sessions 自动清理 | （待记录） | 每天 03:00 |
| 季度 Git GC | bda34eac-4ec0-4692-b2d2-be9c56728829 | 每季度 1 日 03:00 |
| 浏览器进程清理 | （待记录） | 每天 06:00 | 清理Chromium残留进程 |
| Gateway 每周重启 | （待记录） | 每周日 04:00 | 彻底释放累积进程 |

---

## 存储空间

| 目录 | 大小 | 说明 |
|------|------|------|
| /root/.openclaw/extensions/ | ~4.1 GB | 插件和 skill 包（不清理） |
| /root/.openclaw/browser-existing-session/ | ~191 MB | 浏览器会话缓存 |
| /root/.openclaw/agents/main/sessions/ | ~13 MB | 原始会话（30 天自动清理） |
| /root/.openclaw/memory-tdai/ | ~6 MB | tdai 向量数据库 |
| /root/.openclaw/workspace/memory/ | <1 MB | 每日日志和蒸馏 |

---

## Skill 管理

| 分类 | 数量 | 说明 |
|------|------|------|
| ready | 77 | 可用 |
| needs setup | 41 | 平台专属，未配置（用不到的不清理） |

---

## 风险操作凭证

| 凭证 | 位置 | 用途 |
|------|------|------|
| GitHub PAT | ~/.git-credentials | Git 推送（已配置 helper） |
| IMA API | ~/.config/ima/ | 腾讯IMA笔记 |

---

_本文件随系统配置变化更新。_
