# Dao Skill

> **道生一，一生二，二生三，三生万物。**
>
> —— 《道德经》第42章

以《道德经》哲学指导 Claude Code Skill 开发的框架。每个 Skill 从一个哲学概念出发，在真实项目中验证沉淀。

`dao-sun` 是本框架的**首个**实践 skill。

---

## 名字速查

| 名字 | 指什么 | 出现在哪 |
|------|--------|---------|
| `dao-skill` | 整个仓库 / 插件市场 | marketplace.json |
| `sun` | 仓库内的源目录名 | skills/sun/ |
| `dao-sun` | Skill 注册名 / 安装后目录 | plugin.json、`~/.claude/skills/dao-sun` |

---

## 道法术器

《道德经》讲「道法术器」的层次：

| 层次 | 是什么 | 一句话 |
|------|--------|--------|
| **道** | 哲学本源 | 为什么做——「道生一」「大道至简」 |
| **法** | 方法论 | 怎么做——每个 SKILL.md 是一套完整的实践流程 |
| **术** | 技术手段 | 用什么做——模板、命令、验证规则 |
| **器** | 交付物 | 做出来什么——Raw 数据、规则文件、自动注入 |

---

## Skills

### dao-sun · 日损·经验蒸馏

源自第48章「为道日损，去繁就简」。

**它解决什么问题：** AI 踩过的坑下次又踩，你纠正过的错误换个项目它又犯。

**它怎么做：**

1. **采集** — 对 AI 说「记住这个解法」，自动记录错误特征和解决方案
2. **提炼** — 执行 `/dao-evolve`，同类经验自动聚类，生成 If-Then 规则
3. **生效** — 规则写入 `~/.claude/rules/core-wisdom.md`，Claude Code 启动时自动加载——**原生支持，非黑科技**

**哲学映射：**

```
为学日益  →  积累经验，Raw 库持续增长
为道日损  →  提炼极简规则，去粗取精
以至于无为 →  规则自动生效，无需手动加载
```

---

## 项目结构

```
dao-skill/
├── CLAUDE.md                  # 开发规范
├── README.md                  # 本文件
├── LICENSE                    # MIT
├── CHANGELOG.md               # 版本记录
├── install.sh                 # 安装脚本
├── uninstall.sh               # 卸载脚本
├── .gitignore
├── .claude-plugin/
│   └── marketplace.json       # 插件市场注册
└── skills/                    # Skill 独立目录
    └── sun/                   # 日损（源目录）
        ├── SKILL.md           # Skill 定义（name: dao-sun）
        ├── commands/
        │   ├── dao-evolve.md  # /dao-evolve 命令
        │   └── dao-rules.md   # /dao-rules 命令
        ├── scripts/
        │   └── cluster.sh     # 聚类脚本（机械分组）
        └── .claude-plugin/
            └── plugin.json    # 插件元数据（name: dao-sun）
```

安装后路径：`~/.claude/skills/dao-sun/`（统一使用 `dao-` 前缀）。

---

## 安装

**推荐：直接在 Claude Code 中说**

```
帮我安装 dao-sun skill
```

**或手动执行：**

```
/plugin marketplace add tsfjx/dao-skill
/plugin install dao-sun@dao-skill
```

**终端一行命令：**

```bash
# 全部 Skill
curl -fsSL https://raw.githubusercontent.com/tsfjx/dao-skill/main/install.sh | bash

# 只装 dao-sun
curl -fsSL https://raw.githubusercontent.com/tsfjx/dao-skill/main/install.sh | bash -s sun
```

**离线安装（下载 .zip 包）：**

从 [GitHub Releases](https://github.com/tsfjx/dao-skill/releases) 下载 `dao-sun.skill.zip`，解压到 `~/.claude/skills/`：

```bash
# 解压后把 dao-sun 目录放入 skills
unzip dao-sun.skill.zip -d ~/.claude/skills/
```

**卸载：**

```bash
# 只卸载 dao-sun
curl -fsSL https://raw.githubusercontent.com/tsfjx/dao-skill/main/uninstall.sh | bash -s sun

# 卸载全部（含仓库缓存）
curl -fsSL https://raw.githubusercontent.com/tsfjx/dao-skill/main/uninstall.sh | bash
```

卸载只移除 skill 文件，运行时数据（`~/.claude/rules/` `~/.knowledge/`）保留，需手动清理。

---

## 贡献

新 Skill 必须有真实项目的实践经验支撑。流程：踩坑 → 反思 → 抽象 → 用道德经哲学校准 → 固化为 Skill。

命名规范：`dao-{概念}`。源目录用英文词，Skill 注册名带 `dao-` 前缀。新增 Skill 在 `skills/` 下创建目录并在 `marketplace.json` 中注册。

---

## 许可

MIT © 2026 tsfjx
