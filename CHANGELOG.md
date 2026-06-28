# Changelog

All notable changes to dao-skill will be documented in this file.

## [v1.6.11] - 2026-06-28

### Changed
- **自动注入**：确认 `~/.claude/rules/*.md` 被 Claude Code 原生自动加载。修正 SKILL.md 生效机制描述
- **命令注册**：新增 `commands/evolve.md` `commands/rules.md`，plugin.json 注册 `/evolve` `/rules`
- **安装统一**：install.sh 目标改为 `dao-{概念}`，支持 `--force` 强制覆盖+备份，glob 替代 ls，依赖检测
- **文案修正**：README 改为「框架 + 首个 skill」，顶部加名字速查表
- 全部文档同步更新目录结构图

## [v1.6.8] - 2026-06-28

### Changed
- README 重写为人类阅读风格：分段清晰、哲学映射可视化、回答「它解决什么问题」、统一安装用语

## [v1.6.7] - 2026-06-28

### Fixed
- SKILL.md 标题和正文中 `Wisdom` → `dao-sun`，目录路径 `wisdom/` → `sun/`
- plugin.json / marketplace.json 版本号同步为 v1.6.7
- keywords 补充 `dao`、`sun`、`道德经` 标签

## [v1.6.6] - 2026-06-28

### Changed
- Skill 命名统一规范：`dao-{概念}` — SKILL.md `name: dao-sun`，plugin.json `name: dao-sun`
- 命名规范：`dao-` 前缀区分社区其他 skill，`{概念}` 取道德经哲学关键词
- README 同步更新命名引用

## [v1.6.5] - 2026-06-28

### Changed
- README 全面重写：哲学根基、道法术器架构、sun skill 的哲学内涵与实践映射、完整项目结构说明

## [v1.6.4] - 2026-06-28

### Added
- `.claude-plugin/marketplace.json` — 支持 `/plugin install sun@dao-skill` 一键安装
- README 添加 Claude Code 内 `/plugin` 安装方式（方式一：AI 对话或命令）

## [v1.6.3] - 2026-06-28

### Added
- `install.sh`：支持单独安装指定 skill（`install.sh sun`）或全部安装
- README 添加一行安装命令（curl pipe bash）

## [v1.6.2] - 2026-06-28

### Changed
- 重构目录：技能文件移入 `skills/sun/`，以道德经哲学概念命名
- 根目录补全 README.md、LICENSE、.gitignore
- CLAUDE.md 更新文件结构描述

## [v1.6.1] - 2026-06-28

### Added
- 初始化 dao-skill 仓库：以道德经哲学指导 skill 开发的容器
- 收录 sun-skill（日损·经验蒸馏）：wisdom skill 的完整实现
