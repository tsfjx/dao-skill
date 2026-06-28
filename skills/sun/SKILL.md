---
name: dao-sun
description: 将开发经验蒸馏为 AI 自动遵循的规则。纠错型 + 偏好型双轨采集，规则自动注入上下文，让 AI 越用越懂你。
---

# dao-sun — 日损·经验蒸馏

> 为学日益，为道日损。损之又损，以至于无为。

## 核心理念

> **同一个坑，AI 反复踩。你纠正了，换个项目它又犯。**

dao-sun 做两件事：
1. 把你的纠错和偏好固化为规则
2. 让规则自动注入 AI 上下文，下次不再犯错

```
犯错 → 纠正 → 记下(纠错+原因) → 提炼为规则 → 写入 .claude/rules/ → AI 自动遵循
偏好 → 表达 → 记下(偏好)     → 提炼为规则 → 写入 .claude/rules/ → AI 自动遵循
```

---

## 规则生效机制

dao-sun 生成的规则写入 `~/.claude/rules/core-wisdom.md`。

Claude Code 启动时自动递归加载 `~/.claude/rules/*.md` 中的所有 markdown 文件并注入系统指令——这是 Claude Code 原生支持的机制，无需手动加载，AI 无法忽略。

---

## 四种模式

| 模式 | 触发词 | 做什么 |
|------|--------|--------|
| **采集-纠错** | "记住这个解法"、"记下来" | 从会话提取 错误+解法+原因 → 写入 raw/ |
| **采集-偏好** | "以后默认用"、"记住我的偏好"、"我的习惯是" | 从会话提取 场景+偏好选择 → 写入 raw/ |
| **进化** | `/dao-evolve` | raw/ 中同类经验聚类 → 提炼为通用规则 → 写入 `~/.claude/rules/core-wisdom.md` |
| **查询** | `/dao-rules` | 展示当前所有规则 |

---

## 采集模式

### 采集协议（强制性）

所有采集记录使用统一的 YAML 模板。**以下字段缺一不可，不填不能保存：**

```yaml
type: fix | preference          # 必填，二选一
category: string                # 必填，从下方分类表中选择
error_signature: string         # 必填，机器可匹配的错误模式（一行）
solution: string                # 必填，可执行的命令或步骤（一行）
why: string                     # 必填，一句根因解释
project: string                 # 必填，当前项目名
timestamp: ISO8601              # 自动生成
```

**分类表（category 必须从以下选择一个，不可自造）：**

| 分类 | 适用范围 | 示例 error_signature |
|------|---------|---------------------|
| `dependency` | 包管理、依赖版本冲突 | npm ERESOLVE / cargo resolver / pip conflict |
| `config` | 配置错误、环境变量 | config file not found / env var missing |
| `port` | 端口占用、网络 | EADDRINUSE / connection refused |
| `auth` | 权限、认证、密钥 | 403 forbidden / ssh key denied |
| `build` | 编译、构建 | compilation error / linker error |
| `runtime` | 运行时异常 | TypeError / NullPointer / segmentation fault |
| `testing` | 测试框架、断言 | test timeout / assertion failed |
| `workflow` | 开发流程、方法论 | git rebase conflict / code review preference |
| `tooling` | 工具配置、编辑器 | ESLint rule / formatter config / IDE setting |

### 纠错型采集

用户说"记住这个解法"时执行。**必须在用户纠正 AI 的当下立刻采集**——此时 why 信息最完整。

1. 从会话中提取必填字段，**所有字段必须填写**
2. 展示确认信息，等待用户确认
3. 确认后写入 `~/.knowledge/raw/YYYY-MM-DD-HHMM.md`

确认模板：
```
📝 准备记录到 Raw 库：

type: fix
category: [从分类表选一个]
error_signature: [AI 提取]
solution: [AI 提取]
why: [从你的纠正话语中提取，提取不到则追问]
project: [当前项目名]

确认保存？
```

### 偏好型采集

用户说"以后默认用 X"时执行。同样走强制模板：

```yaml
type: preference
category: [workflow/tooling/testing 等]
error_signature: [描述触发场景]
solution: [你的选择]
why: [为什么选这个]
```

**注意**：如果无法从你的纠正话语中提取 `why`，追问一句"为什么这样更好？"——不要猜。

---

## 进化模式 (/dao-evolve)

### 提炼流程

```
Step 0: 脚本聚类 → bash scripts/cluster.sh ~/.knowledge/raw ~/.claude/rules/core-wisdom.md
                  按 category 字段机械分组（脚本级，非 AI 判断）
                  输出：组统计 + 退化建议

Step 1: 聚类确认 → AI 验证分组合并是否合理
                  同 category 同 error_signature → 合并为一条候选

Step 2: 筛选    → 收录门槛（满足 ≥2 条）：
                  - 跨项目出现过（≥2 个项目）
                  - 命中 ≥3 次
                  - 属于根本性方法论
                  不达标的归档但不进入 core-wisdom

Step 3: 退化淘汰 → 脚本已输出退化建议，AI 确认：
                  - 90 天未命中 → 标记「待淘汰」
                  - 已标记过的「待淘汰」→ 本次正式删除

Step 4: 提炼    → 每条规则 ≤3 行，含 Why、已脱敏
                  附带 meta 注释（category / hit / last / projects）

Step 5: 预算控制 → 全部规则 ≤30 行。超量按 hit 升序淘汰（冷门先出）

Step 6: 写入    → 备份旧版 → 覆盖 core-wisdom.md → 归档 raw/
```

### 规则元数据

每条规则在 core-wisdom.md 中附带元数据（HTML 注释，不占上下文）：

```markdown
<!-- meta: category=dependency | hit=15 | last=2026-06-28 | projects=3 -->
- npm 依赖冲突 → `npm ci`。Why: lockfile 是真相来源。
```

### 收录门槛

只收满足以下至少 2 条的经验：
- 跨项目出现过（≥2 个项目）
- 命中 ≥3 次
- 属于根本性方法论（非特定版本的临时 workaround）

### 退化规则

- 90 天未命中 → 标记「待淘汰」，下次 /dao-evolve 时正式删除
- 总行数超 30 行 → 按 hit_count 升序淘汰（命中最低的先出）

### 提炼约束

| # | 约束 | 含义 |
|---|------|------|
| 1 | **可执行** | 规则包含明确操作步骤，可直接复制使用 |
| 2 | **溯其因** | 一句话说清根因或理由 |
| 3 | **已脱敏** | 不含具体路径、IP、端口、密钥。用 `{root}`、`{port}`、`{api_key}` 替代 |

### 规则格式

```markdown
# Core-Wisdom — 全局规则（≤30行）

<!-- meta: category=dependency | hit=15 | last=2026-06-28 | projects=3 -->
- npm 依赖冲突 → `npm ci`。Why: lockfile 是真相来源，与版本声明不一致时报错。

<!-- meta: category=port | hit=12 | last=2026-06-28 | projects=2 -->
- 端口占用 → `lsof -i :{port}` 查进程再 kill。Why: 旧进程未释放是根因。

<!-- meta: category=testing | hit=8 | last=2026-06-25 | projects=2 -->
- 测试：vitest（不用 jest）。Why: 原生 ESM，与 Vite 一致。
```

---

## 查询模式 (/dao-rules)

直接展示 `~/.claude/rules/core-wisdom.md` 的内容。

---

## 目录结构

```
~/.claude/
├── rules/
│   └── core-wisdom.md              # 规则文件，Claude Code 启动时自动加载
└── skills/
    └── dao-sun/                    # 本 Skill 安装目录
        ├── SKILL.md
        ├── commands/
        │   ├── dao-evolve.md
        │   └── dao-rules.md
        └── scripts/
            └── cluster.sh          # 聚类脚本（机械分组）

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
