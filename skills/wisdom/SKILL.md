---
name: wisdom
description: 将开发经验蒸馏为 AI 自动遵循的规则。纠错型 + 偏好型双轨采集，规则自动注入上下文，让 AI 越用越懂你。
---

# Wisdom — AI 经验蒸馏

## 核心理念

> **同一个坑，AI 反复踩。你纠正了，换个项目它又犯。**

Wisdom 做两件事：
1. 把你的纠错和偏好固化为规则
2. 让规则自动注入 AI 上下文，下次不再犯错

```
犯错 → 纠正 → 记下(纠错+原因) → 提炼为规则 → 写入 .claude/rules/ → AI 自动遵循
偏好 → 表达 → 记下(偏好)     → 提炼为规则 → 写入 .claude/rules/ → AI 自动遵循
```

---

## 规则生效机制

Wisdom 生成的规则写入 `~/.claude/rules/core-wisdom.md`，Claude Code 会自动将此文件注入每次会话的系统指令——**AI 无法忽略，无需手动加载。**

CLAUDE.md 中已包含指令：

> 遇到错误或做技术选型时，先检索 ~/.claude/rules/core-wisdom.md 中的历史经验和偏好规则。如有匹配，优先遵循。

---

## 四种模式

| 模式 | 触发词 | 做什么 |
|------|--------|--------|
| **采集-纠错** | "记住这个解法"、"记下来" | 从会话提取 错误+解法+原因 → 写入 raw/ |
| **采集-偏好** | "以后默认用"、"记住我的偏好"、"我的习惯是" | 从会话提取 场景+偏好选择 → 写入 raw/ |
| **进化** | `/evolve` | raw/ 中同类经验聚类 → 提炼为通用规则 → 写入 `~/.claude/rules/core-wisdom.md` |
| **查询** | `/rules` | 展示当前所有规则 |

---

## 采集模式

### 纠错型采集

用户说"记住这个解法"时执行。**必须在用户纠正 AI 的当下立刻采集**——此时 why 信息最完整。

1. 从会话中提取：
   - `error_signature`: 错误的通用特征
   - `solution`: 最终有效的解法
   - `why`: **你为什么这么纠正**——从你的纠正话语中提取原因，不要猜
   - `project`: 项目名（可选）

2. 单行确认后写入 `~/.knowledge/raw/YYYY-MM-DD-HHMM.md`：
   ```yaml
   type: "fix"
   error_signature: "npm ERESOLVE 依赖版本冲突"
   solution: "npm ci"
   why: "lockfile 是真相来源，与 package.json 版本声明不一致时 npm 报错。删除 node_modules 治标不治本。"
   project: "nextjs-app"
   ```

### 偏好型采集

用户说"以后默认用 X"时执行。

1. 从会话中提取：
   - `scenario`: 场景描述
   - `preference`: 你选择的方案
   - `alternative`: 被排除的方案（可选）
   - `why`: 为什么选这个

2. 确认后写入 `~/.knowledge/raw/YYYY-MM-DD-HHMM.md`：
   ```yaml
   type: "preference"
   scenario: "写前端单元测试"
   preference: "vitest"
   alternative: "jest"
   why: "vitest 更快，原生支持 ESM，与 Vite 生态一致"
   ```

**注意**：如果无法从你的纠正话语中提取 `why`，追问一句"为什么这样更好？"——不要猜。

---

## 进化模式 (/evolve)

扫描 `~/.knowledge/raw/`，按 `error_signature`/`scenario` 分组。对每类高频经验（≥2 次）提炼一条规则。

### 上下文预算

`core-wisdom.md` 每次会话自动注入 AI 上下文，**必须极端精简。** 每条规则不超过 3 行，全文件不超过 30 行（~500 tokens）。超量时淘汰命中次数最低的规则。

**收录门槛**：只收满足以下至少 2 条的经验：
- 跨项目出现过（≥2 个项目）
- 命中 ≥3 次
- 属于根本性方法论（非特定版本的临时 workaround）

### 提炼约束

| # | 约束 | 含义 |
|---|------|------|
| 1 | **可执行** | 规则包含明确操作步骤，可直接复制使用 |
| 2 | **溯其因** | 一句话说清根因或理由 |
| 3 | **已脱敏** | 不含具体路径、IP、端口、密钥。用 `{root}`、`{port}`、`{api_key}` 替代 |

### 提炼流程

```
Step 1: 聚类 → 按 type 分组，找出 ≥2 次的同类经验
Step 2: 筛选 → 按收录门槛过滤，不达标的归档但不进入 core-wisdom
Step 3: 提炼 → 每条规则 ≤3 行。纠错型: If-Then-Why，偏好型: 场景-默认-Why
Step 4: 验证 → 检查全部文件 ≤30 行。超量则按命中次数升序淘汰
Step 5: 写入 → 备份 → 写入 ~/.claude/rules/core-wisdom.md → 归档 raw/
```

### 规则格式

```markdown
# Core-Wisdom — 全局规则（≤30行）

## 纠错
- npm 依赖冲突 → `npm ci`。Why: lockfile 是真相来源，与 package.json 版本不一致时报错。
- 端口占用 → `lsof -i :{port}` 查进程再 kill。Why: 换端口是逃避，根因是旧进程未释放。

## 偏好
- 测试：vitest（不用 jest）。Why: 原生 ESM，与 Vite 一致。
- 包管理：pnpm（不用 npm）。Why: 更快，磁盘空间省 50%+。
```

---

## 查询模式 (/rules)

直接展示 `~/.claude/rules/core-wisdom.md` 的内容。

---

## 目录结构

```
~/.claude/
├── CLAUDE.md                       # 全局指令（含 Wisdom 规则引用）
├── rules/
│   └── core-wisdom.md              # Wisdom 生成的规则，自动注入 AI 上下文
└── skills/
    └── wisdom/SKILL.md             # 本 Skill

~/.knowledge/
├── raw/                            # 原始经验记录
└── archived/YYYY-MM/               # 已处理的归档
```

---

## 非可妥协规则

1. **why 不能猜** — 采集时从用户纠正话语中提取原因。提取不到就追问，不编造
2. **不保留敏感信息** — 规则中不得出现具体路径、IP、端口、密钥
3. **先备份再覆盖** — 写入 core-wisdom.md 前备份旧版本
4. **不可执行不收录** — 模糊建议不进规则库
