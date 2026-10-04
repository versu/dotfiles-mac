#!/bin/bash
set -eux

# 設定ファイルを既定の ~/.hammerspoon ではなく、dotfiles がリンクする ~/.config 配下から読ませる
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
