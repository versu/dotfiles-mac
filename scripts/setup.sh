#!/bin/bash
set -eux
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.sh"

/bin/bash "$CUR_DIR/setup-brew.sh"
/bin/bash "$CUR_DIR/setup-obsidian.sh"
/bin/bash "$CUR_DIR/setup-links.sh"
/bin/bash "$CUR_DIR/setup-deno.sh"
/bin/bash "$CUR_DIR/setup-zinit.sh"
/bin/bash "$CUR_DIR/setup-fzf.sh"
/bin/bash "$CUR_DIR/setup-go.sh"
/bin/bash "$CUR_DIR/setup-mise.sh"
