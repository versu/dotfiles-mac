#!/bin/bash
set -eu

# Finder で表示中のフォルダ（ウィンドウが無ければデスクトップ）に空のテキストファイルを作成して選択する。
# Karabiner-Elements の shell_command から呼び出す。

dir=$(osascript -e 'tell application "Finder" to POSIX path of (insertion location as alias)')

# 既存ファイルを上書きしないよう、Finder の新規フォルダと同じく連番で空き名を探す
base="名称未設定"
ext=".txt"
file="$dir$base$ext"
n=2
while [ -e "$file" ]; do
  file="$dir$base $n$ext"
  n=$((n + 1))
done

touch "$file"

# 作成直後に Enter でリネームへ移れるよう選択状態にする
osascript - "$file" <<'EOF'
on run argv
  tell application "Finder" to select (POSIX file (item 1 of argv) as alias)
end run
EOF
