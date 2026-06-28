# Dao Skill

> **为学日益，为道日损。损之又损，以至于无为。**
>
> —— 《道德经》第48章

把《道德经》的哲学智慧，变成 Claude Code 里真实可用的 AI 工作方法。

---

## 这是什么

Dao Skill 是一个 Claude Code Skill 集合。每个 Skill 对应《道德经》的一个哲学概念，经真实项目的开发实践反复验证后，沉淀为可安装、可复用的方法论。

**不是凭空设计，是实战中踩坑、反思、抽象后长出来的。**

---

## 道法术器

《道德经》讲「道生一，一生二，二生三，三生万物」。对应到 Skill 开发：

| 层次 | 是什么 | 一句话 |
|------|--------|--------|
| **道** | 哲学本源 | 为什么做——「为道日损」「大道至简」 |
| **法** | 方法论 | 怎么做——每个 SKILL.md 是一套完整的实践流程 |
| **术** | 技术手段 | 用什么做——模板、脚本、验证规则 |
| **器** | 交付物 | 做出来什么——Raw 数据、Core-Wisdom 规则、自动化注入 |

---

## Skills

### dao-sun · 日损·经验蒸馏

源自第48章「为道日损，去繁就简」。

**它解决什么问题：** AI 踩过的坑下次又踩，你纠正过的错误换个项目它又犯。

**它怎么做：**

1. **采集** — 对 AI 说「记住这个解法」，自动记录错误特征和解决方案
2. **提炼** — 执行 `/evolve`，同类经验自动聚类，生成 If-Then 规则
3. **生效** — 规则写入 `~/.claude/rules/core-wisdom.md`，每次会话自动注入 AI 上下文

**哲学映射：**

```
为学日益  →  每天积累经验，Raw 库持续增长
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
├── .gitignore
├── .claude-plugin/
│   └── marketplace.json       # 插件市场注册
└── skills/                    # Skill 独立目录
    └── sun/                   # 日损
        ├── SKILL.md           # Skill 定义
        └── .claude-plugin/
            └── plugin.json    # 插件元数据
```

每个 Skill 独立文件夹，用道德经概念命名目录，互不影响。新增 Skill 只需在 `skills/` 下创建目录并在 `marketplace.json` 中注册。

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

---

## 贡献

新 Skill 必须有真实项目的实践经验支撑。流程是：踩坑 → 反思 → 抽象 → 用道德经哲学校准 → 固化为 Skill。

命名规范：`dao-{概念}`，目录用英文词、Skill 名带 `dao-` 前缀。

---

## 许可

MIT © 2026 tsfjx
