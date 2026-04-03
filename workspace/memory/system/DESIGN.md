# 记忆系统设计文档

> 版本：v1.0
> 日期：2026-04-03
> 状态：常态化运行中

---

## 一、设计目标

gonfeig 的数字第二大脑记忆系统，以**工程化架构**为核心原则，追求：
- **确定性**：记忆有来源、可追溯
- **自我进化**：系统能审视并优化自身
- **分层管理**：不同热度/重要度的信息分级存储
- **自动备份**：重要数据不丢失

---

## 二、整体架构

```
┌─────────────────────────────────────────────────────┐
│                    gonfeig 用户                      │
│                  (飞书/钉钉/QQ)                     │
└──────────────────────┬──────────────────────────────┘
                       │ 实时对话
┌───────────────────────▼──────────────────────────────┐
│               OpenClaw Agent (AI)                  │
│  ┌─────────┐  ┌─────────┐  ┌──────────────────┐   │
│  │ SOUL.md │  │USER.md  │  │ IDENTITY.md      │   │  ← 角色定义（L1-L2）
│  └─────────┘  └─────────┘  └──────────────────┘   │
│  ┌─────────┐  ┌─────────┐  ┌──────────────────┐   │
│  │AGENTS.md│  │TOOLS.md │  │ HEARTBEAT.md     │   │  ← 行为规范（L2）
│  └─────────┘  └─────────┘  └──────────────────┘   │
└──────────────────────┬──────────────────────────────┘
                       │
        ┌──────────────┼──────────────────┐
        │              │                  │
        ▼              ▼                  ▼
┌────────────┐  ┌─────────────┐  ┌──────────────────┐
│ tdai 向量库 │  │ Scene Blocks│  │ agents/sessions │  ← 工作记忆
│ (语义搜索)  │  │ (热度追踪)   │  │  (原始对话)      │
└────────────┘  └─────────────┘  └──────────────────┘
        │              │
        ▼              ▼
┌─────────────────────────────────────────────────────┐
│              Git Hub (openclaw-memory)              │
│  main │ sessions/Y-M-D │ weekly/Y-Www │ archive/Y-M│
└─────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────┐
│              IMA 笔记 (独立生态)                     │
│  - 内容不进 Git                                      │
│  - 通过 OpenAPI 管理                                 │
└─────────────────────────────────────────────────────┘
```

---

## 三、六层记忆体系

| 层级 | 文件 | 性质 | 管理方式 |
|------|------|------|---------|
| L1 | SOUL.md | 原则性定义 | 极少量改动 |
| L2 | USER.md | 用户偏好 | 变化时更新 |
| L3 | MEMORY.md | 长期记忆 | 每周复盘 |
| L4 | scene_blocks/ | 场景记忆 | 热度衰减 |
| L5 | memory/daily/ | 每日日志 | 自动蒸馏 |
| L6 | agents/sessions/ | 原始会话 | 30天清理 |

### 3.1 L1–L2：角色定义（workspace 模板文件）

| 文件 | 内容 | 更新频率 |
|------|------|---------|
| SOUL.md | AI 核心定位、沟通风格、边界感 | 极少 |
| USER.md | 用户背景、偏好、决策模式 | 变化时 |
| IDENTITY.md | AI 名称/角色/能力边界 | 低 |
| AGENTS.md | 行动规范、工具调用原则 | 低 |
| TOOLS.md | 系统配置、定时任务清单 | 中 |
| HEARTBEAT.md | 巡检规范、主动建议模式 | 中 |

**存储位置**：`/root/.openclaw/workspace/`

### 3.2 L3：MEMORY.md（长期记忆主干）

**存储位置**：`/root/.openclaw/workspace/MEMORY.md`

包含：
- 用户信息（职业、技术栈、偏好）
- 行动规范（授权等级、风险动作清单）
- 技能环境（77 个可用技能清单）
- 定时任务完整清单（含 ID、触发时间）
- Git Memory 架构（仓库、分支、脚本位置）
- IMA 笔记配置（凭证、笔记列表）
- 重要决策记录（按日期归档）
- 未完成/待跟进事项
- NBA 动态（持续关注）

**更新规则**：
- 重要决策/规范变化 → 立即同步
- 每周复盘时审视是否有过时信息

### 3.3 L4：Scene Blocks（热度追踪场景记忆）

**存储位置**：`/root/.openclaw/memory-tdai/scene_blocks/`

**索引文件**：`/root/.openclaw/memory-tdai/.metadata/scene_index.json`

**格式**：每个 scene block 为独立 Markdown 文件，含 YAML frontmatter：

```yaml
-----META-START-----
created: 2026-03-28T14:21:15.816Z
updated: 2026-04-03T00:47:59.720Z
summary: 场景核心摘要
heat: 21
-----META-END-----

## 标题
正文内容...
```

**热度机制**：
- 热度初始值由 AI 评估设定
- 每日蒸馏时检测关键词，被提及则 +1
- 低于阈值时自动归档（tdai 自动管理）
- 超过 30 天未更新则标记警告

**当前 scene blocks**（截至 2026-04-03）：

| 文件 | 热度 | 最后更新 | 说明 |
|------|------|---------|------|
| OpenClaw部署与运维.md | 30 | 04-03 | Git+IMA混合记忆架构、定时任务 |
| AI交互规范.md | 21 | 04-03 | 消息必回复规范、数据真实性强制要求 |
| NBA-詹姆斯·哈登球迷.md | 18 | 04-03 | 骑士资讯、数据源锁定ESPN+腾讯体育 |
| 用户身份.md | 2 | 04-02 | 基础身份信息 |

### 3.4 L5：每日蒸馏（memory/daily/）

**存储位置**：`/root/.openclaw/workspace/memory/daily/YYYY-MM-DD.md`

**生成方式**：每日 21:00 cron 自动蒸馏

**内容模板**：
```markdown
# 【每日复盘】YYYY-MM-DD

## 对话统计
- Session 文件数：N

## 关键主题
- Git
- 定时任务
- ...

## 重要决策
- git log 提取

## 备注
- 自动蒸馏生成于 HH:MM:SS
```

### 3.5 L6：原始会话（agents/sessions/）

**存储位置**：`/root/.openclaw/agents/main/sessions/`

- 原始 JSONL 格式，含完整对话记录
- **30 天后自动清理**（Sessions自动清理 cron）
- Git 已备份，不影响可追溯性

---

## 四、Git Memory 架构

### 4.1 仓库信息

- **仓库**：`https://github.com/gonfeig/openclaw-memory`
- **默认分支**：`main`
- **凭证**：GitHub PAT + git credential helper

### 4.2 分支结构

| 分支 | 用途 | 推送频率 |
|------|------|---------|
| `main` | 蒸馏记忆主干 | 每日蒸馏 commit |
| `sessions/YYYY-MM-DD` | 每日会话备份 | 每 5 分钟（cron） |
| `weekly/YYYY-Www` | 周归档 | 每周日 |
| `archive/YYYY-MM` | 月度归档 | 每月 |

### 4.3 备份脚本

| 脚本 | 触发时间 | 功能 |
|------|---------|------|
| `commit_sessions.sh` | 每 5 分钟 | 检测 sessions 变化，commit 到 sessions/日期分支 |
| `daily_distill.sh` | 每天 21:00 | 蒸馏当天对话，写入 daily/MEMORY.md，commit main |
| `weekly_archive.sh` | 每周日 22:00 | 合并 sessions 分支，创建周 tag，推送 |
| `monthly_snapshot.sh` | 每月 1 日 23:00 | 创建月度归档分支和 tag |
| `cleanup_sessions.sh` | 每天 03:00 | 删除 30 天前 sessions，本地保留备份 |
| `git_gc.sh` | 每季度 1 日 03:00 | `git gc --aggressive --prune=6months` |

**脚本位置**：`/root/.openclaw/workspace/memory-git-backup/scripts/`

### 4.4 存储空间占用

| 目录 | 大小 | 说明 |
|------|------|------|
| extensions/ | ~4.1 GB | 插件和 skill 包（不清理） |
| browser-existing-session/ | ~191 MB | 浏览器会话缓存 |
| agents/main/sessions/ | ~13 MB | 原始会话（30 天自动清理） |
| memory-tdai/ | ~6 MB | tdai 向量数据库 |
| workspace/memory/ | <1 MB | 每日日志和蒸馏 |

---

## 五、Ontology 知识图谱

### 5.1 设计意图

在对话记忆之上构建**语义知识图谱**，实现：
- 概念节点的显式关联（如 Project → has_component → Task）
- 支持多跳推理查询
- 将对话中的隐式关系提取为结构化知识

### 5.2 Schema 定义

**类型**：
- `Person`：用户基础信息（name, role, tech_stack, timezone, channels）
- `Project`：项目（name, status, goal, owner, repo）
- `Capability`：AI 能力组件（name, components, status）
- `Topic`：持续关注主题（name, status, team, data_source）
- `Task`：待办事项（title, status, priority, due, source）
- `Decision`：重要决策（date, description, outcome, project）

**关系**：
- `has_project` / `has_capability` / `follows`
- `has_component` / `has_task` / `blocks`
- `created_from`

### 5.3 当前状态

⚠️ **待落地**：schema 已定义，但 `graph.jsonl` 尚未填充实体数据。这是下次迭代的待完成项。

---

## 六、定时任务体系

### 6.1 任务清单（11 个）

| 任务 | ID | 触发时间 | 类型 | delivery |
|------|-----|---------|------|---------|
| 早安问候 | 82bba9d8... | 07:00 北京时间 | announce | feishu → user |
| 詹姆斯·哈登 NBA资讯 | 20c8443c... | 08:00 北京时间 | announce | feishu → user |
| 每日对话回顾 | 4c00cdc1... | 21:00 北京时间 | announce | feishu → user |
| Git Sessions Commit | b0bb7220... | 每 5 分钟 | announce | feishu → user |
| 每日记忆蒸馏 | 1578ba4d... | 21:00 北京时间 | announce | feishu → user |
| Sessions自动清理 | fb5dce6f... | 03:00 北京时间 | none | - |
| 浏览器进程清理 | dadab962... | 06:00 北京时间 | none | - |
| Gateway每周重启 | d19aaf3c... | 周日 04:00 北京时间 | none | - |
| 每周记忆归档 | c3dc2b66... | 周日 22:00 北京时间 | none | - |
| 每月记忆快照 | f5eb2f71... | 每月1日 23:00 | none | - |
| 季度Git空间优化 | bda34eac... | 每季度1日 03:00 | none | - |

### 6.2 sessionTarget 配置

所有任务统一使用 `sessionTarget: "current"`（复用调用者 session 的飞书 channel 上下文）。

⚠️ **已知问题**：`openclaw cron run` CLI 会触发 gateway 回写 `isolated`，但 scheduled trigger 不受影响，定时触发正常运行。

### 6.3 故障处理规范

1. error → AI 自动检查分析（最多 3 次重试）
2. 3 次仍失败 → 立即飞书通知用户，说明原因和已尝试的修复措施

---

## 七、IMA 笔记集成

### 7.1 定位

IMA 笔记是**独立于 Git 的用户笔记生态**，用于：
- 用户个人笔记存储（通过 OpenAPI 管理）
- 内容不进 Git（保持独立）
- 通过 IMA OpenAPI 创建/追加/搜索

### 7.2 凭证

- **client_id**：`b6aa3e9be2915af0a331db8447389ad7`
- **API Key**：已配置
- **配置目录**：`~/.config/ima/`

### 7.3 已有笔记

| 标题 | doc_id | 修改时间 |
|------|--------|---------|
| Ubuntu 虚拟机 Docker 部署 OpenClaw... | 7443989703715971 | 2026-03-28 |
| 思想汇报 | 7442038542828340 | 2026-03-22 |
| ima笔记使用指南 | 7430096428221435 | 2026-01-14 |
| IDENTITY.md | 7445646931926731 | 2026-04-03 |

---

## 八、tdai 向量搜索

### 8.1 能力

- **语义搜索**：通过自然语言查询记忆
- **记忆类型**：`persona`（身份偏好）、`episodic`（事件活动）、`instruction`（用户规则）
- **召回**：top 结果 + path + lines

### 8.2 索引结构

- `scene_blocks/` → 场景热度索引
- `conversations/` → 原始对话索引
- `records/` → 结构化记忆索引

### 8.3 存储

- **向量数据库**：`memory-tdai/vectors.db`（约 6 MB）
- **元数据**：`memory-tdai/.metadata/`
  - `recall_checkpoint.json`
  - `scene_index.json`

---

## 九、当前待改进项

### 9.1 高优先级

| 问题 | 说明 | 状态 |
|------|------|------|
| Ontology graph 未填充 | schema 已定义，但 graph.jsonl 为空，推理能力未启用 | 待完成 |
| scene block 热度衰减逻辑 | 当前只有 +1，没有衰减机制，长期高热度块不会自动降低 | 待实现 |

### 9.2 中优先级

| 问题 | 说明 | 状态 |
|------|------|------|
| MEMORY.md 手动更新 | 定时任务故障修复（`sessionTarget` 回写问题）未同步到 MEMORY.md | 待更新 |
| HEARTBEAT.md 状态追踪 | 上次检查时间已过期，需要维护 | 待更新 |

### 9.3 低优先级

| 问题 | 说明 | 状态 |
|------|------|------|
| Windows+Docker+OpenClaw 安装方案 | 用户提过，未完成 | 待跟进 |

---

## 十、关键设计决策记录

### 2026-04-02
- 确立 Git Memory 架构（GitHub + 本地多层存储 + 定期备份）
- 确立行动授权等级（L0–L4）
- 确立工具调用原则（主动、有目标性、不乱调）
- 确立定时任务故障处理规范（3 次重试 + 飞书通知）

### 2026-04-03
- 修复 cron 任务 announce 失败问题（`sessionTarget: isolated` → `current`）
- 添加 `bestEffort: true` 到所有 announce delivery
- 内部任务（Git commit、记忆蒸馏等）改为 `mode: none`
- 修复清明节天数硬编码问题（早安问候 prompt）
- 确立数据源锁定规范（ESPN + 腾讯体育）

---

_本文件为自我检视生成，反映 2026-04-03 时的系统状态。_
