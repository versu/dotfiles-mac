#!/bin/bash
set -eux
source "$(dirname "$0")/common.sh"

mkdir -p \
  "$XDG_CONFIG_HOME" \
  "$XDG_STATE_HOME" 

# 除外したいディレクトリ名をここに追加
EXCLUDE_DIRS=("raycast" "claude")

for entry in "$REPO_DIR/config/"*; do
  name=$(basename "$entry")
  skip=false
  for ex in "${EXCLUDE_DIRS[@]}"; do
    if [[ "$name" == "$ex" ]]; then
      skip=true
      break
    fi
  done
  if ! $skip; then
    ln -sfv "$entry" "$XDG_CONFIG_HOME/"
  fi
done

ln -sfv "$XDG_CONFIG_HOME/zsh/.zshenv" "$HOME/.zshenv"

# Claude Code
ln -sfv "$XDG_CONFIG_HOME/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
