#!/bin/bash

set -eu
source "$(dirname "$0")/common.sh"

### install GitHub CLI ###
if ! command -v gh &> /dev/null; then
    echo "Installing gh..."
    brew install gh
fi

### authenticate ###
# credential.username で指定したアカウントを認証対象とする。
# gh auth status ではいずれかのアカウントが認証済みなら成功してしまうため、
# gh auth token でアカウントを名指しして判定する。
GH_USER="$(git config --get credential.https://github.com.username)"

if gh auth token -u "$GH_USER" > /dev/null 2>&1; then
    echo "gh: $GH_USER は認証済みです"
else
    echo "gh: $GH_USER が未認証のため、ブラウザでログインします"
    gh auth login --hostname github.com --git-protocol https --web
fi
