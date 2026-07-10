#!/bin/bash

set -eux

if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    brew install mise
else
    echo "Upgrading mise..."
    brew upgrade mise
fi
