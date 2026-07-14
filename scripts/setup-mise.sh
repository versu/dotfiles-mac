#!/bin/bash

set -eux

if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    brew install mise
else
    echo "Upgrading mise..."
    brew upgrade mise
fi

# config/mise/config.toml に定義したツール（deno, go, fzf, ghq 等）を導入する。
# setup-links.sh が ~/.config/mise へリンク済みであることが前提。
echo "Installing mise tools..."
mise install
