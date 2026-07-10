#!/bin/bash
set -eux
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.sh"

/bin/bash "$CUR_DIR/setup-brew.sh"
# setup-links.sh で git の credential 設定を有効化してから gh を認証する。
# obsidian-vault は private なため、認証後でないと clone できない
/bin/bash "$CUR_DIR/setup-links.sh"
/bin/bash "$CUR_DIR/setup-gh.sh"
/bin/bash "$CUR_DIR/setup-obsidian.sh"
/bin/bash "$CUR_DIR/setup-zinit.sh"
/bin/bash "$CUR_DIR/setup-mise.sh"
/bin/bash "$CUR_DIR/setup-my-command.sh"
/bin/bash "$CUR_DIR/setup-ghq.sh"
