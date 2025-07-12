#!/bin/bash

set -eux

source "$(dirname "$0")/common.sh"

echo "Installing fzf..."
git clone --depth 1 "https://github.com/junegunn/fzf.git" "$XDG_DATA_HOME/.fzf"
"$XDG_DATA_HOME"/.fzf/install --xdg --key-bindings --completion --no-update-rc
echo "Install fzf completions..."
