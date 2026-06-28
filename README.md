# Wisdom Skill

> AI 经验蒸馏系统 — 让 AI 不再反复踩同一个坑，越用越懂你。

## 一行安装

```bash
git clone git@github.com:tsfjx/wisdom-skill.git ~/.claude/skills/wisdom && mkdir -p ~/.knowledge/{raw,archived} && grep -q "core-wisdom.md" ~/.claude/CLAUDE.md 2>/dev/null || printf '\n## Wisdom 规则\n遇到错误或做技术选型时，先检索 ~/.claude/rules/core-wisdom.md 中的历史经验和偏好规则。如有匹配，优先遵循。\n' >> ~/.claude/CLAUDE.md
```

这一行做了三件事：克隆 skill → 创建存储目录 → 注入 CLAUDE.md 引用（幂等，重复执行安全）。

## 使用

| 你说的话 | 效果 |
|---------|------|
| "记住这个解法" | AI 自动提取错误+解法+原因，写入 raw/ |
| "以后默认用 vitest" | 记录你的技术偏好 |
| `/evolve` | 扫描所有经验，提炼为通用规则 |
| `/rules` | 查看当前所有黄金规则 |

## 工作流

```
踩坑 → 纠正 → 记下 → 同类坑多了 → 提炼规则 → 写入 ~/.claude/rules/ → AI 自动遵循
```

规则写入 `~/.claude/rules/core-wisdom.md`，Claude Code 每次会话自动注入上下文——无需手动加载。

## 规则示例

```markdown
## 纠错
- npm 依赖冲突 → `npm ci`。Why: lockfile 是真相来源，与 package.json 版本不一致时报错。
- 端口占用 → `lsof -i :{port}` 查进程再 kill。Why: 换端口是逃避，根因是旧进程未释放。

## 偏好
- 测试：vitest（不用 jest）。Why: 原生 ESM，与 Vite 一致。
- 包管理：pnpm（不用 npm）。Why: 更快，磁盘空间省 50%+。
```

## 设计原则

- **上下文预算**：core-wisdom.md ≤30 行（~500 tokens），不挤占上下文窗口
- **收录门槛**：只收跨项目、高频、根本性方法论——不是所有经验都值得永久记住
- **why 不能猜**：采集时从用户纠正话语中提取原因，提取不到就追问

## 许可

MIT © 2026 tsfjx
