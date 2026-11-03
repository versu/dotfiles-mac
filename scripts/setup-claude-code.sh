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
# このスクリプトは .zshrc を読まないため、インストール直後でも claude を呼べるよう PATH を通す。
export PATH="$HOME/.local/bin:$PATH"

# Notion の private / work 両ワークスペースを同時に扱うため、ワークスペースごとに登録する。
# 同じ URL のリモート MCP は重複登録できないため、mcp-remote 経由の stdio サーバーとして登録する。
# 認証情報は MCP_REMOTE_CONFIG_DIR でワークスペースごとに保存先を分け、混ざらないようにしている。
# トークンを含むため ~/.mcp-auth は dotfiles 管理外とする。
NOTION_MCP_URL="https://mcp.notion.com/mcp"

# 以前は単一ワークスペース用に notion という名前でリモート MCP を登録していたため、移行時に削除する。
if claude mcp get notion >/dev/null 2>&1; then
  echo "Removing legacy Notion MCP server..."
  claude mcp remove --scope user notion
fi

for workspace in private work; do
  server_name="notion-$workspace"
  auth_dir="$HOME/.mcp-auth/$server_name"

  if ! claude mcp get "$server_name" >/dev/null 2>&1; then
    echo "Adding $server_name MCP server..."
    claude mcp add --scope user "$server_name" \
      -e MCP_REMOTE_CONFIG_DIR="$auth_dir" \
      -- npx -y mcp-remote "$NOTION_MCP_URL"
  fi

  # 未認証の場合のみブラウザ認証を行う。
  # setup.sh は mise activate されていない bash で走るため、mise exec 経由で npx を呼び出す。
  if ! compgen -G "$auth_dir/*/*_tokens.json" >/dev/null; then
    echo "Authenticating $server_name... Notion の許可画面では「${workspace}」ワークスペースを選択してください"
    MCP_REMOTE_CONFIG_DIR="$auth_dir" mise exec node -- npx -y -p mcp-remote mcp-remote-client "$NOTION_MCP_URL"
  fi
done
