#!/bin/bash
set -eux
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.sh"

/bin/bash "$CUR_DIR/setup-brew.sh"
/bin/bash "$CUR_DIR/setup-obsidian.sh"
/bin/bash "$CUR_DIR/setup-links.sh"
/bin/bash "$CUR_DIR/setup-zinit.sh"
/bin/bash "$CUR_DIR/setup-mise.sh"
/bin/bash "$CUR_DIR/setup-my-command.sh"
/bin/bash "$CUR_DIR/setup-ghq.sh"
