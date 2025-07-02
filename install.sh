#!/bin/sh

#----------------------------------------
# セットアップスクリプトのエントリーポイント
#----------------------------------------

# dotfiles-mac リポジトリのインストール先ディレクトリ
INSTALL_DIR="${INSTALL_DIR:-$HOME/repo/github.com/versu/dotfiles-mac}"

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating dotfiles..."
    git -C "$INSTALL_DIR" pull
else
    echo "Installing dotfiles..."
    git clone https://github.com/versu/dotfiles.git "$INSTALL_DIR"
fi

/bin/bash "$INSTALL_DIR/scripts/setup.sh"
