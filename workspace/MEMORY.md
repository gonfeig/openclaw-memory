# MEMORY.md — 长期记忆

## 用户信息
- **用户名**: gonfeig
- **称呼**: 主人
- **时区**: Asia/Shanghai
- **主要渠道**: 飞书（主力）、钉钉

---

## 职业背景
- **职位**: 软件测试开发工程师
- **技术栈**: Python、Java、JavaScript/TypeScript、React、Docker、Git、Linux
- **专长**: 自动化测试、测试平台/工具开发、DevOps CI/CD
- **领域**: AI 辅助编程 · AI+测试自动化 · LLM 应用开发 · 个人项目

## 个人特质
- **追求创新**: 喜欢用自动化工具替代手工工作，偏好新思路、新工具
- **最新热点实时性要求高**: AI 资讯、技术动态要求信息新、准确、不旧闻
- **主动优化**: 不满足于"能用"，追求更好的方案和工具链

---

## 行动规范（2026-04-02 确立）

### 行动授权等级
| 等级 | 操作类型 | 是否需要确认 |
|------|---------|------------|
| L0 直接执行 | 读文件、搜索信息、查日志、整理记忆 | 不需要 |
| L1 先说再做 | 创建/更新文件、执行已确认的计划、技术验证 | 口头告知即可 |
| L2 先确认再做 | 新定时任务、新自动化流程、修改已确认的规范 | 需要明确回复 |
| L3 停下来问 | 删除文件、修改他人内容、跨系统操作、外部推送 | 必须确认才能执行 |
| L4 禁止 | 透露私密信息、执行可能影响业务的操作 | 任何情况下禁止 |

### 风险动作清单（L2/L3 级别，必须确认）
**L2**: 创建定时任务、修改系统配置、Git 提交推送、安装卸载 skill、修改 .gitignore
**L3**: 删除文件、修改他人笔记、外部系统推送、清理磁盘

### 工具调用原则
- 主动调用，有目标性，不乱调、不炫技、不链式调用、不重复调用
- 调用前确认参数和环境，结果直接给用户
- 失败先重试一次，仍失败告知用户并给替代方案

---

## 技能环境

### 可用技能（77个 ready）
位于 `~/.openclaw/workspace/skills/` 和 `~/.openclaw/extensions/`

**核心技能**:
- `agent-browser` — 浏览器自动化（必须用此，禁止直接用 browser）
- `automation-workflows` — 自动化工作流
- `self-evolving-skill` — 元认知自学习
- `personal-productivity` — 效率顾问
- `skill-cortex-pub` — 自动化学技能
- `memory-setup-openclaw` — 记忆配置（⭐重要）
- `self-improving-agent` — AI自我改进
- `obsidian` — Obsidian笔记
- `tencent-docs` — 腾讯文档
- `tencent-cos-skill` — 腾讯云存储
- `weather` — 天气查询
- `github` — GitHub CLI（repo/issue/PR）
- `feishu-doc/wiki/drive` — 飞书三件套
- `wecom-*` — 企业微信全套（待办/会议/日程/文档）
- `ima-skill` — IMA 笔记（notes + knowledge-base）

**needs setup（41个）**: 平台专属，用不到，不清理

---

## 定时任务（完整清单）

### 每日任务
| 任务 | ID | 触发时间 | 说明 |
|------|-----|---------|------|
| 早安问候 | `82bba9d8-...` | 每天 07:00 北京时间 | 优雅诗意风格，飞书推送 |
| 詹姆斯·哈登 NBA 资讯 | `20c8443c-...` | 每天 08:00 北京时间 | ESPN+腾讯体育，骑士队资讯 |
| 每日对话回顾 | `4c00cdc1-...` | 每天 21:00 北京时间 | 蒸馏对话写入 memory/，同步 MEMORY.md |
| Git Sessions Commit | `b0bb7220-...` | 每 5 分钟 | 检测 sessions 变化，自动 commit 到 sessions/日期分支 |
| 每日记忆蒸馏 | `1578ba4d-...` | 每天 21:00 北京时间 | 蒸馏当天对话写入 daily/MEMORY.md，commit main |
| Sessions 自动清理 | （待记录） | 每天 03:00 | 删除 30 天前 agents/sessions，本地保留备份 |

### 每周任务
| 任务 | ID | 触发时间 | 说明 |
|------|-----|---------|------|
| 每周记忆归档 | `c3dc2b66-...` | 每周日 22:00 北京时间 | 合并 sessions 到 weekly 分支，创建周 tag |

### 每月任务
| 任务 | ID | 触发时间 | 说明 |
|------|-----|---------|------|
| 每月记忆快照 | `f5eb2f71-...` | 每月 1 日 23:00 | 创建月度归档分支和 tag |

### 每季度任务
| 任务 | ID | 触发时间 | 说明 |
|------|-----|---------|------|
| 季度 Git GC | `bda34eac-...` | 每季度 1 日 03:00 | `git gc --aggressive --prune=6months` |

### 定时任务故障处理规范
1. error → 自动检查分析（最多 3 次重试）
2. 3 次仍失败 → 立即飞书通知用户

---

## Git Memory 架构（2026-04-02 确立）

### 仓库
- **地址**: https://github.com/gonfeig/openclaw-memory
- **默认分支**: main

### 分支结构
| 分支 | 用途 | 推送频率 |
|------|------|---------|
| main | 蒸馏记忆主干 | 每日 |
| sessions/YYYY-MM-DD | 每日会话备份 | 每5分钟（自动） |
| weekly/YYYY-Www | 周归档 | 每周日 |
| archive/YYYY-MM | 月度归档 | 每月 |

### 脚本位置
`workspace/memory-git-backup/scripts/`
- `commit_sessions.sh` — sessions 自动 commit
- `daily_distill.sh` — 每日蒸馏
- `weekly_archive.sh` — 每周归档
- `monthly_snapshot.sh` — 每月快照
- `cleanup_sessions.sh` — sessions 清理
- `git_gc.sh` — 季度空间优化

### 凭证
GitHub PAT 存储在 `~/.git-credentials`（git credential helper），脚本不硬编码

---

## IMA 笔记配置

### 凭证
- **配置目录**: `~/.config/ima/`
- **client_id**: `b6aa3e9be2915af0a331db8447389ad7`
- **API Key**: `k3ScZIidq3W23lF/eWWfbf5RYOHLbQk92q7BMxd4yP3/I6tKNz+/UjD5S+f5TFBXo9Vo2LLNfw==`

### 笔记列表（根目录）
| 标题 | doc_id | 修改时间 |
|------|--------|---------|
| Ubuntu 虚拟机 Docker 部署 OpenClaw... | 7443989703715971 | 2026-03-28 |
| 思想汇报 | 7442038542828340 | 2026-03-22 |
| ima笔记使用指南 | 7430096428221435 | 2026-01-14 |

### 备注
- 内容不进 Git（独立生态）
- API 已验证可用（返回 code:0）

---

## 系统配置
- **OS**: Debian 12（Linux 6.8+）
- **Node**: v22+
- **OpenClaw**: 2026.3.x
- **Gateway**: `0.0.0.0:13692`，PID 2301671
- **工作目录**: `/root/.openclaw`
- **配置**: `memorySearch` 已启用（local provider）

---

## 重要决策记录

### 2026-04-02（重大更新）
### 2026-04-03（定时任务故障修复）
- 根因：cron 任务 `sessionTarget: "isolated"` 无法访问飞书 announce 通道
- 修复：所有 11 个 cron 任务改为 `sessionTarget: "current"`，复用调用者 channel 上下文
- 添加 `bestEffort: true` 到所有 announce delivery，announce 失败不再标记 error
- 内部任务（Git commit、记忆蒸馏等）改为 `mode: none`，避免刷屏
- 修复早安问候 prompt 清明节天数硬编码（改为 AI 动态计算）
- 发现 gateway 对 `cron run` 有 sessionTarget 回写行为，但 scheduled trigger 不受影响
- 飞书 delivery channel 从 `last` 改为显式 `feishu`


- 确立 Git Memory 架构（GitHub + 本地多层存储 + 定期备份）
- 确立行动授权等级（L0-L4）
- 确立工具调用原则（主动、有目标性、不乱调）
- 优化 USER.md/SOUL.md/AGENTS.md/IDENTITY.md/HEARTBEAT.md/TOOLS.md
- 用户技术栈新增 Java/React/Docker
- 用户偏好新增：追求创新、最新热点实时性要求高

### 2026-03-27
- 批量清理 ClawHub 可疑技能
- 设置每日早安问候
- 安装 memory-setup-openclaw 并启用本地记忆搜索

---

## 未完成 / 待跟进
- [ ] Windows 宿主机 + Ubuntu 虚拟机 + Docker + OpenClaw 安装方案（用户提过，未完成）

---

## NBA 动态（持续关注）
- **詹姆斯·哈登**: 克利夫兰骑士队（2026-03-28 从快船转会）
- 数据源：ESPN（比赛/排名）+ 腾讯体育（新闻）
- 每次推送需验证数据真实性；清明节天数由AI根据{{date}}动态计算，不确定的内容不编造
