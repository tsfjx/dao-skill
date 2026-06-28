#!/bin/bash
set -euo pipefail

command -v git >/dev/null || { echo "✗ 需要 git，请先安装: https://git-scm.com"; exit 1; }

SKILLS_DIR="${HOME}/.claude/skills"
REPO_URL="https://github.com/tsfjx/dao-skill.git"
REPO_DIR="${SKILLS_DIR}/dao-skill"
FORCE=0
TARGETS=()

usage() {
  echo "用法: install.sh [--force] [skill名...]"
  echo "  skill名  sun, water, ...    单独安装指定 skill（用源目录名）"
  echo "  --force                     强制覆盖已安装的 skill（备份旧版本）"
  echo "  无参数                       安装全部 skill"
  exit 0
}

# 解析参数
for arg in "$@"; do
  case "$arg" in
    --force|-f) FORCE=1 ;;
    -h|--help) usage ;;
    *) TARGETS+=("$arg") ;;
  esac
done

echo "☯  道·Skill 安装器"

# 克隆/更新仓库
if [ -d "${REPO_DIR}/.git" ]; then
  echo "  ↻ 更新 dao-skill..."
  (cd "${REPO_DIR}" && git pull --ff-only) || {
    echo "  ✗ git pull 失败，检查 ${REPO_DIR} 是否有本地改动"
    exit 1
  }
else
  echo "  ↓ 克隆 dao-skill..."
  mkdir -p "${SKILLS_DIR}"
  git clone "${REPO_URL}" "${REPO_DIR}"
fi

# 确定要安装的 skill（用 glob，不解析 ls）
if [ "${#TARGETS[@]}" -eq 0 ]; then
  shopt -s nullglob
  for d in "${REPO_DIR}/skills/"*/; do
    TARGETS+=("$(basename "$d")")
  done
  shopt -u nullglob
  echo "  → 安装全部 skill: ${TARGETS[*]}"
else
  echo "  → 安装指定 skill: ${TARGETS[*]}"
fi

# 安装每个 skill
INSTALLED=0
for skill in "${TARGETS[@]}"; do
  SRC="${REPO_DIR}/skills/${skill}"
  install_name="dao-${skill}"
  DST="${SKILLS_DIR}/${install_name}"

  if [ ! -d "${SRC}" ]; then
    echo "  ✗ skill '${skill}' 不存在，跳过"
    continue
  fi

  if [ -d "${DST}" ]; then
    if [ "$FORCE" -eq 1 ]; then
      echo "  ↻ 强制更新 ${install_name}（旧版已备份）"
      cp -r "${DST}" "${DST}.bak.$(date +%s)"
      rm -rf "${DST}"
    else
      echo "  ✓ ${install_name} 已安装，跳过（用 --force 强制覆盖）"
      INSTALLED=$((INSTALLED + 1))
      continue
    fi
  fi

  cp -r "${SRC}" "${DST}"
  echo "  ✓ ${install_name} 安装完成"
  INSTALLED=$((INSTALLED + 1))
done

# 创建 dao-sun 所需的运行时目录
mkdir -p "${HOME}/.claude/rules" "${HOME}/.knowledge/raw" "${HOME}/.knowledge/archived"
echo "  ✓ 运行时目录已就绪"

echo "☯  完成！已安装 ${INSTALLED} 个 skill"
