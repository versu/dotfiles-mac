#!/bin/sh

# obsidian をインストール 
brew install obsidian

# obsidian-vault リポジトリのインストール先ディレクトリ
INSTALL_DIR="${INSTALL_DIR:-$HOME/repo/github.com/versu/obsidian-vault}"

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating obsidian-vault..."
    git -C "$INSTALL_DIR" pull
else
    echo "Installing obsidian-vault..."
    git clone https://github.com/versu/obsidian-vault.git "$INSTALL_DIR"
fi
