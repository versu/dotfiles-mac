#!/bin/bash

#----------------------------------------
# install homebrew
#----------------------------------------
set -eux
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

#----------------------------------------
# install packages
#----------------------------------------

brew install google-chrome

brew install --cask visual-studio-code

# ime(google ime のインストールに必要)
softwareupdate --install-rosetta	
brew install google-japanese-ime

# キーマッピング
brew install karabiner-elements

# Karabiner では判別できない、フォーカス位置に応じたキー操作の変更
brew install --cask hammerspoon

# マウスとタッチパッドのスクロール方向をそれぞれ設定できるようにする
brew install scroll-reverser

# 画面キャプチャ
brew install shottr

# ランチャー
brew install raycast

# mac で windows と同じようにalt + tab でウィンドウ切り替えを行えるようにする
brew install alt-tab

# Nerdフォント（starship で文字化けしないために必要）
brew install font-hack-nerd-font

# docker desktop on mac
brew install --cask docker

# db client
brew install --cask dbeaver-community

# git client
brew install --cask fork

# Postman
brew install --cask postman

# RDP クライアント（Windows へのリモートデスクトップ接続）
brew install --cask windows-app

# Cloudflare One Client（旧称 Cloudflare WARP。cask 名は旧称のまま）
brew install --cask cloudflare-warp

# Java(plantuml のために必要)
brew install openjdk
brew install graphviz
