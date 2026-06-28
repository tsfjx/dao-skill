# Dao Skill 项目级 CLAUDE.md

## 版本自动增长规则

每次提交时，按以下公式计算版本号并更新 CHANGELOG：

```
v{年偏移}.{月份}.{当月序号}
```

| 变量 | 计算方式 | 示例 (2026-06-28) |
|------|---------|-------------------|
| 年偏移 | 当前年份 - 2026 + 1 | 2026 → 1 |
| 月份 | 当前月份 (无前导零) | 6 |
| 当月序号 | 查看 CHANGELOG 中本月已有版本数 + 1，每月重置 | 本月第 3 次提交 → 3 |

完整版本号示例：`v1.6.3`（2026年6月第3次提交）

**执行流程**：
1. 查看 CHANGELOG.md 中当前月份已有的版本数量
2. `当月序号 = 本月已发布版本数 + 1`
3. 组装版本号、更新 CHANGELOG、提交时使用该版本号

## Git 工作流

- 分支：`main`（唯一分支，直接提交）
- 每次改动后自动 `git add` + `git commit` + `git push`
- 提交信息格式：`v{版本号}: {简短描述}`
- CHANGELOG.md 同步更新

## 文件结构

```
dao-skill/
├── CLAUDE.md              # 本项目开发规范（本文件）
├── README.md              # 仓库首页
├── LICENSE                # MIT
├── CHANGELOG.md           # 版本记录
├── install.sh             # 安装脚本
├── .gitignore
├── .claude-plugin/
│   └── marketplace.json   # 插件市场注册
└── skills/
    └── sun/               # 日损·经验蒸馏（源目录）
        ├── SKILL.md       # Skill 主入口（name: dao-sun）
        ├── commands/
        │   ├── dao-evolve.md  # /dao-evolve 命令
        │   └── dao-rules.md   # /dao-rules 命令
        ├── scripts/
        │   └── cluster.sh     # 聚类脚本
        └── .claude-plugin/
            └── plugin.json
```

每个 skill 独立文件夹管理，以道德经哲学概念命名源目录。
安装后路径统一为 `~/.claude/skills/dao-{概念}/`。
