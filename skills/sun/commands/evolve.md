---
description: 扫描 raw/ 经验，聚类提炼为规则并写入 ~/.claude/rules/core-wisdom.md
---

执行 dao-sun 进化模式：

1. 扫描 `~/.knowledge/raw/` 下所有采集记录
2. 按 `error_signature` / `scenario` 聚类，找出 ≥2 次的同类经验
3. 按收录门槛过滤（跨项目 ≥2 / 命中 ≥3 / 根本性方法论，满足 ≥2 条）
4. 提炼规则：每条 ≤3 行，含 Why、已脱敏
5. 写入 `~/.claude/rules/core-wisdom.md`（写入前备份旧版本）
6. 归档已处理的 raw 文件到 `~/.knowledge/archived/YYYY-MM/`

详细流程见 SKILL.md「进化模式」章节。
