---
description: 扫描 raw/ 经验，脚本机械聚类 + AI 语义提炼 + 退化淘汰，写入 core-wisdom.md
---

执行 dao-sun 进化模式：

**Step 0 — 运行聚类脚本（机械，非 AI 判断）：**
```bash
bash ~/.claude/skills/dao-sun/scripts/cluster.sh ~/.knowledge/raw ~/.claude/rules/core-wisdom.md
```
脚本输出：按 `category` 分组统计 + 现有规则退化检查。AI 读取输出后执行以下步骤。

**Step 1 — 聚类确认：** 验证脚本分组合并是否合理。同 category 同 error_signature 的合并为一条候选规则。

**Step 2 — 筛选：** 收录门槛（需满足 ≥2 条）：跨项目 ≥2 / 命中 ≥3 / 根本性方法论。不达标归档但不进入 core-wisdom。

**Step 3 — 退化淘汰：** 脚本已输出退化建议。AI 确认：`last > 90` 天首次标记「待淘汰」、第二次直接删除。按 `hit` 升序淘汰至 ≤30 行。

**Step 4 — 提炼：** 每条规则 ≤3 行，含 Why、已脱敏，附带 meta 注释（`category` `hit` `last` `projects`）。

**Step 5 — 写入：** 备份旧版 → 覆盖 core-wisdom.md → 归档 raw/ → 报告新增/淘汰数量。

详细流程见 SKILL.md「进化模式」章节。
