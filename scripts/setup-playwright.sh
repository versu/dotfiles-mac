#!/bin/bash

set -eux

# Playwright 実行用ブラウザ(Chromium)のインストール。
# Chrome は setup-brew.sh で導入済みのため、ここでは Playwright 既定の Chromium のみを入れる。
# playwright install は導入済みなら再ダウンロードしないため、再実行しても安全。
# setup.sh は mise activate されていない bash で走るため、mise exec 経由で呼び出す。
echo "Installing Playwright browsers (chromium)..."
mise exec npm:playwright -- playwright install chromium
