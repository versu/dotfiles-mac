#!/bin/bash

set -eux

source "$(dirname "$0")/common.sh"

export BUN_INSTALL="${BUN:-$XDG_DATA_HOME/bun}"
echo "Installing Bun..."
curl -fsSL https://bun.sh/install | bash
echo "Install Bun completions..."
