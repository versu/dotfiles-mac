#!/bin/bash

set -eux

# Claude Code は公式のネイティブインストーラで導入する。
# npm global（mise の node 配下）に入れると、mise が node = "latest" を上げた際に
# インストール先ごと PATH から外れて claude が消えるため、node に依存しない
# ネイティブ版を使う。インストール先は ~/.local/bin/claude で、PATH は
# config/zsh/.zshrc で通している。
# インストーラは導入済みなら最新版への更新として動作するため、再実行しても安全。
echo "Installing Claude Code (native installer)..."
curl -fsSL https://claude.ai/install.sh | bash

# MCP サーバは ~/.claude.json に保存され dotfiles で管理できないため、ここで登録する。
# 登録済みなら add がエラーになるので、get で存在確認してから追加する。
# 認証（OAuth）は初回に Claude Code 上の /mcp から行う。
# このスクリプトは .zshrc を読まないため、インストール直後でも claude を呼べるよう PATH を通す。
export PATH="$HOME/.local/bin:$PATH"
if ! claude mcp get notion >/dev/null 2>&1; then
  echo "Adding Notion MCP server..."
  claude mcp add --transport http --scope user notion https://mcp.notion.com/mcp
fi
