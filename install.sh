#!/bin/bash
set -e

SKILLS_DIR="${HOME}/.claude/skills"
REPO_URL="https://github.com/tsfjx/dao-skill.git"
REPO_DIR="${SKILLS_DIR}/dao-skill"

echo "☯  道·Skill 安装器"

# 克隆/更新仓库
if [ -d "${REPO_DIR}/.git" ]; then
  echo "  ↻ 更新 dao-skill..."
  (cd "${REPO_DIR}" && git pull --ff-only)
else
  echo "  ↓ 克隆 dao-skill..."
  mkdir -p "${SKILLS_DIR}"
  git clone "${REPO_URL}" "${REPO_DIR}"
fi

# 确定要安装的 skill
if [ -n "$1" ]; then
  SKILLS=("$1")
  echo "  → 安装指定 skill: $1"
else
  SKILLS=($(ls -d "${REPO_DIR}/skills/"*/ | xargs -n1 basename))
  echo "  → 安装全部 skill: ${SKILLS[*]}"
fi

# 安装每个 skill
INSTALLED=0
for skill in "${SKILLS[@]}"; do
  SRC="${REPO_DIR}/skills/${skill}"
  DST="${SKILLS_DIR}/${skill}"

  if [ ! -d "${SRC}" ]; then
    echo "  ✗ skill '${skill}' 不存在，跳过"
    continue
  fi

  # 幂等：已存在则跳过
  if [ -d "${DST}" ]; then
    echo "  ✓ ${skill} 已安装，跳过"
  else
    cp -r "${SRC}" "${DST}"
    echo "  ✓ ${skill} 安装完成"
  fi
  INSTALLED=$((INSTALLED + 1))
done

echo "☯  完成！已安装 ${INSTALLED} 个 skill"
