#!/bin/bash

source "$(dirname "$0")/common.sh"

MY_COMMAND_DIR="$REPO_DIR/scripts/my-command"

DOWNLOAD_GIST_COMMAND_PATH="$MY_COMMAND_DIR/download-gist.sh"
DOWNLOAD_GIST_EXECUTE_PATH=~/bin/download-gist

mkdir -p ~/bin
cp "$DOWNLOAD_GIST_COMMAND_PATH" "$DOWNLOAD_GIST_EXECUTE_PATH"
chmod +x "$DOWNLOAD_GIST_EXECUTE_PATH"
