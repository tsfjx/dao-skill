# Changelog

All notable changes to dao-skill will be documented in this file.

## [v1.7.3] - 2026-06-28

### Added
- install.sh 安装时写入默认种子规则（论证先于实施），首次即生效，不覆盖已有规则

## [v1.7.2] - 2026-06-28

### Added
- CLAUDE.md 新增「开发铁律」章节：全局审视 → 第一性原理 → 实践/官方论证 → 先设验证标准再实施

## [v1.7.1] - 2026-06-28

### Fixed
- cluster.sh：awk 替代 grep -P（跨平台兼容），按 category 合并签名而非按 signature 精确匹配

## [v1.7.0] - 2026-06-28

### Added
- **P0 采集模板化**：9 分类枚举表（dependency/config/port/auth/build/runtime/testing/workflow/tooling），强制字段约束
- **P1 规则生命周期**：HTML meta 注释（category/hit/last/projects），90 天退化淘汰，按 hit 升序预算控制
- **P2 聚类脚本化**：scripts/cluster.sh 机械聚类 + 退化检查，AI 只做语义抽象

## [v1.6.14] - 2026-06-28

### Changed
- 命令重命名：`/evolve` → `/dao-evolve`，`/rules` → `/dao-rules`，避免与社区 skill 冲突

## [v1.6.13] - 2026-06-28

### Added
- uninstall.sh：支持单独/全部卸载，保留运行时数据

## [v1.6.12] - 2026-06-28

### Added
- install.sh 自动创建 `~/.claude/rules/` 和 `~/.knowledge/` 运行时目录

## [v1.6.11] - 2026-06-28

### Changed
- 评估报告全面修正：确认 `~/.claude/rules/*.md` 原生自动加载，命令注册，安装统一 dao-前缀，README 文案诚实化，名字速查表

## [v1.6.10] - 2026-06-28

### Fixed
- install.sh 改用 HTTPS clone（`https://github.com/...`），无需 GitHub SSH 密钥

## [v1.6.9] - 2026-06-28

### Changed
- README 总体引语改为第42章「道生一，一生二，二生三，三生万物」

## [v1.6.8] - 2026-06-28

### Changed
- README 重写为人类阅读风格：哲学映射可视化、问答式介绍、统一安装用语

## [v1.6.7] - 2026-06-28

### Fixed
- SKILL.md 标题和正文中 `Wisdom` → `dao-sun`，目录路径 `wisdom/` → `sun/`
- keywords 补充 `dao`、`道德经` 标签

## [v1.6.6] - 2026-06-28

### Changed
- Skill 命名统一规范：`dao-{概念}` — SKILL.md `name: dao-sun`，plugin.json `name: dao-sun`

## [v1.6.5] - 2026-06-28

### Changed
- README 全面重写：哲学根基、道法术器架构、sun skill 哲学内涵与实践映射、完整项目结构

## [v1.6.4] - 2026-06-28

### Added
- `.claude-plugin/plugin.json` — 社区标准插件元数据
- `.claude-plugin/marketplace.json` — 支持 `/plugin install dao-sun@dao-skill` 一键安装

## [v1.6.3] - 2026-06-28

### Added
- install.sh：支持单独/全部 skill 安装
- README 一行安装命令（curl pipe bash）

## [v1.6.2] - 2026-06-28

### Changed
- 重构目录：skill 文件移入 `skills/sun/`，以道德经哲学概念命名
- 根目录补全 README.md、LICENSE、.gitignore
- CLAUDE.md 更新文件结构描述

## [v1.6.1] - 2026-06-28

### Added
- 初始化 dao-skill 仓库：以道德经哲学指导 skill 开发的容器
- 收录 sun-skill（日损·经验蒸馏）：wisdom skill 的完整实现
