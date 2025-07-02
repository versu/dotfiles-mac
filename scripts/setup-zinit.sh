#!/bin/bash
set -eux
source "$(dirname "$0")/common.sh"

if [ -d "$XDG_DATA_HOME/zinit/bin" ]; then
  echo "zinit is already installed."
  git -C "$XDG_DATA_HOME/zinit/bin" pull
else
  echo "Installing zinit..."
  git clone "https://github.com/zdharma-continuum/zinit" "$XDG_DATA_HOME/zinit/bin"
fi
