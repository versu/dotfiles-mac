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
