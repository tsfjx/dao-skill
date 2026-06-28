#!/bin/bash
# dao-sun 聚类脚本 — 按 category 机械分组 + 退化检查
# 用法: ./cluster.sh [raw_dir] [core_wisdom_file]
set -euo pipefail

RAW_DIR="${1:-$HOME/.knowledge/raw}"
CORE_WISDOM="${2:-$HOME/.claude/rules/core-wisdom.md}"

echo "=== RAW 聚类 ==="
declare -A CAT_COUNT CAT_PROJECTS

for f in "$RAW_DIR"/*.md; do
  [ -f "$f" ] || continue

  cat=$(grep -oP 'category:\s*\K.*' "$f" 2>/dev/null || echo "uncategorized")
  cat=$(echo "$cat" | xargs); [ -z "$cat" ] && cat="uncategorized"

  sig=$(grep -oP 'error_signature:\s*\K.*' "$f" 2>/dev/null || echo "")
  sig=$(echo "$sig" | xargs)

  proj=$(grep -oP 'project:\s*\K.*' "$f" 2>/dev/null || echo "unknown")
  proj=$(echo "$proj" | xargs)

  echo "  [$cat] $sig ($proj)"

  key="${cat}|${sig}"
  CAT_COUNT["$key"]=$((${CAT_COUNT["$key"]:-0} + 1))

  seen="${key}|projs"
  CAT_PROJECTS["$seen"]="${CAT_PROJECTS["$seen"]:-}$proj,"
done

echo ""; echo "=== 聚类结果（≥2 次）==="
for key in "${!CAT_COUNT[@]}"; do
  count="${CAT_COUNT[$key]}"
  [ "$count" -ge 2 ] || continue

  cat="${key%%|*}"; sig="${key#*|}"
  proj_list="${CAT_PROJECTS[${key}|projs]:-unknown}"
  proj_count=$(echo "$proj_list" | tr ',' '\n' | sort -u | grep -c .)

  echo "  category=$cat count=$count projects=$proj_count"
  echo "    signature: $sig"
done

echo ""; echo "=== 退化检查 ==="
if [ -f "$CORE_WISDOM" ]; then
  while IFS= read -r line; do
    if echo "$line" | grep -q '<!-- meta:'; then
      last=$(echo "$line" | grep -oP 'last=\K[0-9-]+' || echo "")
      hits=$(echo "$line" | grep -oP 'hit=\K[0-9]+' || echo "0")
      projs=$(echo "$line" | grep -oP 'projects=\K[0-9]+' || echo "0")
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
