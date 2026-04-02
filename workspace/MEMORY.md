# MEMORY.md — 长期记忆

## 用户信息
- **用户名**: gonfeig
- **称呼**: 主人
- **时区**: Asia/Shanghai
- **主要渠道**: 飞书

---

## 技能环境

### 工作区技能（~24个）
位于 `~/.openclaw/workspace/skills/`

**高质量技能（保留）**:
- `agent-browser` — 浏览器自动化
- `automation-workflows` — 自动化工作流
- `self-evolving-skill` — 元认知自学习
- `personal-productivity` — 效率顾问
- `agentic-workflow-automation` — Agent工作流
- `skill-cortex-pub` — 自动化学技能
- `memory-setup-openclaw` — 记忆配置（⭐重要）
- `self-improving-agent` — AI自我改进
- `obsidian` — Obsidian笔记
- `tencent-docs` — 腾讯文档
- `tencent-cos-skill` — 腾讯云存储
- `weather` — 天气查询

**问题技能（已删除）**: `ai-productivity-audit`、`ai-web-automation`、`docker-mcp-toolkit`、`skill-security`

**工具限制**: `browser`、`web_search`、`web_fetch` 已禁用，必须用 `agent-browser` skill

---

## 定时任务

### 每日对话回顾
- **ID**: `4c00cdc1-c146-40bb-b080-9b04f59180de`
- **时间**: 每天 21:00 北京时间
- **内容**: 回顾当天所有对话（直接+群组），写入 `memory/YYYY-MM-DD.md`，同步重要决策到 MEMORY.md
- **渠道**: isolated → 自动写入文件

### 定时任务故障处理规范（2026-04-02确立）
- cron 任务出现 error 时，AI自动进行检查修复，最多重试3次
- 3次仍失败则立即通知用户 gonfeig（飞书）

### 早安问候
- **ID**: `82bba9d8-2f60-476e-924b-8195c7148b10`
- **时间**: 每天 08:00 上海时区
- **风格**: 优雅诗意、夸赞主人、华丽排比、100字内
- **渠道**: 飞书

---

## 系统配置
- **Gateway**: `0.0.0.0:13692`，PID 2301671
- **记忆**: `memorySearch` 已启用（local provider）
- **配置文件**: `~/.openclaw/openclaw.json`

---

## 重要决策记录

### 2026-03-27
- 批量清理 ClawHub 可疑技能（ai-web-automation 等）
- 设置每日早安问候（高大上风格）
- 安装 `memory-setup-openclaw` 并启用本地记忆搜索
- 用户偏好高大上的消息格式

---

## IMA 笔记配置

### 凭证位置
- **配置文件目录**：`~/.config/ima/`
  - `~/.config/ima/client_id` → Client ID
  - `~/.config/ima/api_key` → API Key
- **凭证内容**：
  - Client ID：`b6aa3e9be2915af0a331db8447389ad7`
  - API Key：`k3ScZIidq3W23lF/eWWfbf5RYOHLbQk92q7BMxd4yP3/I6tKNz+/UjD5S+f5TFBXo9Vo2LLNfw==`

### IMA 技能
- 安装路径：`~/.openclaw/workspace/skills/ima/`
- 技能模块：notes（笔记）、knowledge-base（知识库）

### 用户笔记列表（根目录，三份）
| 标题 | doc_id | 修改时间 |
|------|--------|---------|
| Ubuntu 虚拟机 Docker 部署 OpenClaw... | 7443989703715971 | 2026-03-28 |
| 思想汇报 | 7442038542828340 | 2026-03-22 |
| ima笔记使用指南 | 7430096428221435 | 2026-01-14 |

### 备注
- `list_note_folder_by_cursor` 查笔记本分类，根目录笔记需用 `list_note_by_folder_id`
- 技能已验证可用（API 返回 code:0）

## 未完成 / 待跟进
- [ ] Windows 宿主机 + Ubuntu 虚拟机 + Docker + OpenClaw 安装方案（用户提过，未完成）
- [ ] 后续可能需要将内容保存至 IMA 笔记

## 2026-04-02 更新：记忆存储优化计划
- gonfeig 正在评估**记忆目录 Git 版本化 + IMA 双生态**架构方案
- 核心目标：多层存储 + 定时自检视总结 + Git 备份 + IMA 可视化 + 节省空间
- 待确认 6 个设计决策点（Git 远程仓库选择、提交粒度、分支策略、IMA 双向同步范围等）
- 确认后输出完整设计方案并实施

## 2026-03-28 更新
- 詹姆斯·哈登目前效力于：**克利夫兰骑士队**（非快船，信息已过时）
- 今日比赛（3月28日）：骑士 vs 热火，哈登数据：**17分5篮板14助攻**
- 知识库截止日后信息可能存在较大滞后，NBA球员流动频繁，请以用户实时反馈为准
