#!/bin/bash

set -eux -o pipefail

source "$(dirname "$0")/common.sh"
export GOPATH="$XDG_DATA_HOME/go"

### prepare install ###
sudo rm -rf "$XDG_DATA_HOME"/go

### install go ###
#====================================================================
# install version url (https://go.dev/dl/)
#====================================================================
curl -fsSL https://go.dev/dl/go1.24.4.darwin-amd64.tar.gz | tar xzf - -C "$XDG_DATA_HOME"

### install go-pkg ###
"$GOPATH/bin/go" install github.com/x-motemen/ghq@latest
