#!/bin/bash
# dao-sun 聚类脚本 — 按 category 机械分组 + 退化检查
# 用法: ./cluster.sh [raw_dir] [core_wisdom_file]
set -euo pipefail

RAW_DIR="${1:-$HOME/.knowledge/raw}"
CORE_WISDOM="${2:-$HOME/.claude/rules/core-wisdom.md}"

echo "=== RAW 聚类 ==="
declare -A CAT_COUNT CAT_SIGNATURES CAT_PROJECTS

for f in "$RAW_DIR"/*.md; do
  [ -f "$f" ] || continue

  cat=$(awk -F': ' '/^category:/ {print $2}' "$f" | xargs)
  [ -z "$cat" ] && cat="uncategorized"

  sig=$(awk -F': ' '/^error_signature:/ {print $2}' "$f" | xargs)
  [ -z "$sig" ] && sig="(no signature)"

  proj=$(awk -F': ' '/^project:/ {print $2}' "$f" | xargs)
  [ -z "$proj" ] && proj="unknown"

  echo "  [$cat] $sig ($proj)"

  CAT_COUNT["$cat"]=$((${CAT_COUNT["$cat"]:-0} + 1))
  CAT_SIGNATURES["$cat"]="${CAT_SIGNATURES["$cat"]:-}  - $sig
"
  CAT_PROJECTS["$cat"]="${CAT_PROJECTS["$cat"]:-}$proj,"
done

echo ""; echo "=== 聚类结果（≥2 次）==="
for cat in "${!CAT_COUNT[@]}"; do
  count="${CAT_COUNT[$cat]}"
  [ "$count" -ge 2 ] || continue

  proj_list="${CAT_PROJECTS[$cat]:-unknown}"
  proj_count=$(echo "$proj_list" | tr ',' '\n' | sort -u | grep -c .)

  echo "  category=$cat | count=$count | projects=$proj_count"
  echo "  signatures:"
  echo "${CAT_SIGNATURES[$cat]}"
done

echo ""; echo "=== 退化检查 ==="
if [ -f "$CORE_WISDOM" ]; then
  while IFS= read -r line; do
    if echo "$line" | grep -q '<!-- meta:'; then
      last=$(echo "$line" | sed -n 's/.*last=\([0-9-]*\).*/\1/p')
      [ -z "$last" ] && last=""
      hits=$(echo "$line" | sed -n 's/.*hit=\([0-9]*\).*/\1/p')
      [ -z "$hits" ] && hits="0"
      projs=$(echo "$line" | sed -n 's/.*projects=\([0-9]*\).*/\1/p')
      [ -z "$projs" ] && projs="0"
      echo "  meta: last=$last hit=$hits projects=$projs"
      if [ -n "$last" ]; then
        last_epoch=$(date -d "$last" +%s 2>/dev/null || echo 0)
        now_epoch=$(date +%s)
        days=$(( (now_epoch - last_epoch) / 86400 ))
        [ "$days" -gt 90 ] && echo "    ⚠ ${days}天未命中 → 建议淘汰"
      fi
    fi
  done < "$CORE_WISDOM"
else
  echo "  （尚无规则）"
fi

echo ""; echo "=== 结束 ==="
echo "以上结果供 AI 提炼。AI 负责：语义抽象 + 退化决策 + 写入 core-wisdom.md"
