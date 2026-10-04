#!/bin/bash
set -eux
source "$(dirname "$0")/../common.sh"

# Finder の右クリックメニューに「VS Codeで開く」のクイックアクションを追加する

NAME="VS Codeで開く"
ASSETS_DIR="$CUR_DIR/assets"
WORKFLOW_DIR="$HOME/Library/Services/$NAME.workflow"

mkdir -p "$HOME/Library/Services"
cp -R "$ASSETS_DIR/$NAME.workflow" "$HOME/Library/Services/"

# Automator で画像を選択したときと同じ場所・名前でアイコンを置く。
# メニュー上では横長の領域に描画されるため、vscode.svg はあらかじめ横に2倍へ引き伸ばしてある
mkdir -p "$WORKFLOW_DIR/Contents/Resources"
sips -s format tiff "$ASSETS_DIR/vscode.svg" --out "$WORKFLOW_DIR/Contents/Resources/workflowCustomImage.tiff"

# ファイルを置いただけではクイックアクションが無効のままなので、有効にする
defaults write pbs NSServicesStatus -dict-add "\"(null) - $NAME - runWorkflowAsService\"" \
  '<dict><key>presentation_modes</key><dict><key>ContextMenu</key><true/><key>FinderPreview</key><true/><key>ServicesMenu</key><true/><key>TouchBar</key><true/></dict></dict>'

# 再ログインを待たずにメニューへ反映させる
/System/Library/CoreServices/pbs -update
