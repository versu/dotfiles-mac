#!/bin/bash

# 複数Gistダウンロードスクリプト
# 使用例: ./download_gist.sh <保存先パス> <gist_id1> [gist_id2] [gist_id3] ...

# 引数チェック
if [ $# -lt 2 ]; then
    echo "使用方法: $0 <保存先パス> <gist_id1> [gist_id2] [gist_id3] ..."
    echo "例: $0 ./downloads 1234567890abcdef fedcba0987654321"
    echo "例: $0 ~/code abc123 def456 ghi789"
    exit 1
fi

SAVE_PATH="$1"
shift  # 最初の引数（保存先パス）を除去

# 保存先ディレクトリの作成
mkdir -p "$SAVE_PATH"

# 各Gist IDを処理
for GIST_ID in "$@"; do
    echo "========================================="
    echo "処理中: Gist ID '$GIST_ID'"
    echo "========================================="
    
    # Gist情報を取得
    echo "Gist情報を取得中..."
    GIST_INFO=$(curl -s "https://api.github.com/gists/$GIST_ID")
    
    # エラーチェック
    if echo "$GIST_INFO" | grep -q '"message": "Not Found"'; then
        echo "エラー: Gist ID '$GIST_ID' が見つかりません"
        echo "スキップして次のGistを処理します..."
        continue
    fi
    
    # ファイル一覧を取得
    FILES=$(echo "$GIST_INFO" | jq -r '.files | keys[]')
    
    if [ -z "$FILES" ]; then
        echo "エラー: Gist '$GIST_ID' のファイル情報を取得できませんでした"
        echo "スキップして次のGistを処理します..."
        continue
    fi
    
    # ファイル数をカウント
    FILE_COUNT=$(echo "$FILES" | wc -l)
    echo "見つかったファイル数: $FILE_COUNT"
    
    # 各ファイルをダウンロード
    for FILE in $FILES; do
        echo "ダウンロード中: $FILE"
        
        # ファイル内容を取得
        CONTENT=$(echo "$GIST_INFO" | jq -r ".files[\"$FILE\"].content")
        
        # ファイル名に競合がある場合、Gist IDを接頭辞として追加
        OUTPUT_FILE="$SAVE_PATH/$FILE"
        if [ -f "$OUTPUT_FILE" ]; then
            # ファイルが既に存在する場合、Gist IDを接頭辞として追加
            FILENAME="${FILE%.*}"
            EXTENSION="${FILE##*.}"
            if [ "$FILENAME" = "$EXTENSION" ]; then
                # 拡張子がない場合
                OUTPUT_FILE="$SAVE_PATH/${GIST_ID:0:8}_$FILE"
            else
                # 拡張子がある場合
                OUTPUT_FILE="$SAVE_PATH/${GIST_ID:0:8}_$FILENAME.$EXTENSION"
            fi
            echo "ファイル名競合のため、新しいファイル名: $(basename "$OUTPUT_FILE")"
        fi
        
        # ファイルに書き込み
        echo "$CONTENT" > "$OUTPUT_FILE"
        
        echo "保存完了: $OUTPUT_FILE"
    done
    
    echo "Gist '$GIST_ID' の処理完了"
    echo
done

echo "すべてのGistのダウンロードが完了しました"
