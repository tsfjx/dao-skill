# Changelog

All notable changes to this project will be documented in this file.

## [v1.6.1] - 2026-06-28

### Added
- 初始版本
- 纠错型采集（"记住这个解法"）
- 偏好型采集（"以后默认用 X"）
- 进化模式（/evolve）：聚类 → 筛选 → 提炼 → 写入
- 查询模式（/rules）
- 规则自动注入 `~/.claude/rules/core-wisdom.md`
- 上下文预算控制：≤30 行 / 500 tokens
- 收录门槛：跨项目 / ≥3 次命中 / 根本性方法论
- 三条提炼约束：可执行、溯其因、已脱敏

## [v1.6.2] - 2026-06-28

### Changed
- 版本自动增长规则从 SKILL.md 移至项目级 CLAUDE.md（合规：skill 不应管理项目版本）
- 新增项目级 CLAUDE.md：版本规则 + Git 工作流规范
