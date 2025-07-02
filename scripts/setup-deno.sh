#!/bin/bash

set -eux

source "$(dirname "$0")/common.sh"

export DENO_INSTALL="${DENO_INSTALL:-$XDG_DATA_HOME/deno}"
echo "Installing Deno..."

#----------------------------------------
# install dependencies
#----------------------------------------
echo "checking required packages..."
if ! command -v unzip >/dev/null 2>&1; then
  echo "unzip is not installed. Installing..."
  brew install unzip
else
  echo "unzip is already installed. skip install"
fi


#----------------------------------------
# install deno
# PATHを通すか聞かれるが、zshrcで設定しているので No で進める
#----------------------------------------
curl -fsSL https://deno.land/x/install/install.sh | /bin/sh
echo "Install Deno completions..."
