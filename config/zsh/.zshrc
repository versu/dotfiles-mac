# ---------------------------------------------------------
# zinit
# ---------------------------------------------------------

declare -A ZINIT
ZINIT[HOME_DIR]="$XDG_DATA_HOME/zinit"
ZINIT[ZCOMPDUMP_PATH]="$XDG_STATE_HOME/zcompdump"
source "${ZINIT[HOME_DIR]}/bin/zinit.zsh"

# ---------------------------------------------------------
# path
# ---------------------------------------------------------

# ---------------------------------------------------------
# homebrew をユーザーインストールした場合は、以下のコメントアウトを外す
# homebrew をユーザーインストールした場合に、アプリケーションのインストールフォルダをユーザーディレクトリ配下に変更するための設定
# Homebrew Cask でアプリケーション（.app）をインストールすると、デフォルトでは /Applications にインストールしようとするため、仮に管理者権限がないような貸与端末だとインストール時にエラーとなってしまう。
# これを回避するため、ユーザーディレクトリ配下（~/Applications）にインストールするよう変更する。
# ---------------------------------------------------------
# export PATH=~/homebrew/bin:$PATH   # homebrew をユーザーインストールした場合にパスを通すために必要
# export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# ---------------------------------------------------------
# alias
# ---------------------------------------------------------

alias dg="download-gist"

# ---------------------------------------------------------
# zinit plugins
# ---------------------------------------------------------

zinit wait lucid blockf light-mode for \
  atload'async_init' mafredri/zsh-async \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  zdharma-continuum/fast-syntax-highlighting

# ---------------------------------------------------------
# fzf
# ---------------------------------------------------------

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# ---------------------------------------------------------
# zsh fuzzy completion and utility plugin with Deno.
# yuki-yano/zeno.zsh(https://github.com/yuki-yano/zeno.zsh#user-configuration-file-example)
# ---------------------------------------------------------

__zeno_atload() {
  bindkey ' ' zeno-auto-snippet
  bindkey '^m' zeno-auto-snippet-and-accept-line
  bindkey '^i' zeno-completion
  bindkey '^r' zeno-history-selection
  # bindkey '^x' zeno-insert-snippet
  bindkey '^g' zeno-ghq-cd

  # deno は deno.json が無いと cwd の tsconfig.json を設定として拾い、
  # 非対応の compilerOptions を stderr に警告する。zinit のターボモードでは
  # それがプロンプト描画後に流れ込み、表示が崩れる。出力を捨てて非同期実行する。
  ( deno cache --quiet --unstable-byonm --no-lock --no-check -- "${ZENO_ROOT}/src/cli.ts" &> /dev/null &! )
}

export ZENO_HOME="$XDG_CONFIG_HOME/zeno"
export ZENO_DISABLE_EXECUTE_CACHE_COMMAND=1
zinit wait lucid light-mode for \
  atload'__zeno_atload' \
  @'yuki-yano/zeno.zsh'

export FZF_DEFAULT_OPTS='--reverse'

# ---------------------------------------------------------
# starship
# ---------------------------------------------------------

export STARSHIP_CONFIG="${XDG_CONFIG_HOME}"/starship/starship.toml
zinit ice as"command" from"gh-r" atload'eval "$(starship init zsh)"'
zinit light starship/starship

# ---------------------------------------------------------
# theme(lsd)
# ---------------------------------------------------------

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

zinit ice as"command" from"gh-r" pick"lsd*/lsd"
zinit light lsd-rs/lsd

# ---------------------------------------------------------
# key binds
# ---------------------------------------------------------

# bash base key bind
bindkey \^U backward-kill-line


# ---------------------------------------------------------
# mise
# ---------------------------------------------------------

eval "$(mise activate zsh)"

# ---------------------------------------------------------
# home brew
# ---------------------------------------------------------

# eval "$(/opt/homebrew/bin/brew shellenv)"




# vim: set ts=4:
# Copyright 2022-present Jakub Jirutka <jakub@jirutka.cz>.
# SPDX-License-Identifier: MIT
#
# Emacs shift-select mode for Zsh - select text in the command line using Shift
# as in many text editors, browsers and other GUI programs.
#
# Version: 0.1.1
# Homepage: <https://github.com/jirutka/zsh-shift-select>

# Move cursor to the end of the buffer.
# This is an alternative to builtin end-of-buffer-or-history.
function end-of-buffer() {
	CURSOR=${#BUFFER}
	zle end-of-line -w  # trigger syntax highlighting redraw
}
zle -N end-of-buffer

# Move cursor to the beginning of the buffer.
# This is an alternative to builtin beginning-of-buffer-or-history.
function beginning-of-buffer() {
	CURSOR=0
	zle beginning-of-line -w  # trigger syntax highlighting redraw
}
zle -N beginning-of-buffer

# Kill the selected region and switch back to the main keymap.
function shift-select::kill-region() {
	zle kill-region -w
	zle -K main
}
zle -N shift-select::kill-region

# Copy the selected region to clipboard.
function shift-select::copy-region() {
	if (( REGION_ACTIVE )); then
		local start=$((MARK < CURSOR ? MARK : CURSOR))
		local end=$((MARK > CURSOR ? MARK : CURSOR))
		local selected_text=${BUFFER[start+1,end]}
		printf '%s' "$selected_text" | pbcopy
	fi
}
zle -N shift-select::copy-region

# Paste from clipboard at cursor position.
function shift-select::paste() {
	local clipboard_content
	clipboard_content=$(pbpaste)
	BUFFER="${BUFFER[1,CURSOR]}${clipboard_content}${BUFFER[CURSOR+1,-1]}"
	CURSOR=$((CURSOR + ${#clipboard_content}))
}
zle -N shift-select::paste

# Cut the selected region (copy and delete).
function shift-select::cut-region() {
	if (( REGION_ACTIVE )); then
		local start=$((MARK < CURSOR ? MARK : CURSOR))
		local end=$((MARK > CURSOR ? MARK : CURSOR))
		local selected_text=${BUFFER[start+1,end]}
		printf '%s' "$selected_text" | pbcopy
		zle kill-region -w
		zle -K main
	fi
}
zle -N shift-select::cut-region

# macOS版 Ctrl+C コピー機能（Windows WSL2アプローチを適応）
# コマンド入力待機中：Ctrl+Cを別キーに変更してコピー機能を優先
function zle-pre-cmd {
	stty intr "^@"  # Ctrl+@ に変更（通常使わないキー）
}

# コマンド実行中：Ctrl+Cを中断キーに戻す
function zle-pre-exec {
	stty intr "^C"  # 元のCtrl+Cに戻す
}

# 賢いCtrl+Cハンドリング：選択状態に応じて動作を切り替え
function zle-clipboard-copy {
	if ((REGION_ACTIVE)); then
		# テキスト選択中の場合 → コピー機能
		local start=$((MARK < CURSOR ? MARK : CURSOR))
		local end=$((MARK > CURSOR ? MARK : CURSOR))
		local selected_text=${BUFFER[start+1,end]}
		printf '%s' "$selected_text" | pbcopy
		REGION_ACTIVE=0  # 選択を解除
	else
		# 未選択の場合 → プロセス中断
		zle send-break
	fi
}
zle -N zle-clipboard-copy

# precmd/preexec関数を登録
precmd_functions=("zle-pre-cmd" ${precmd_functions[@]})
preexec_functions=("zle-pre-exec" ${preexec_functions[@]})

# Deactivate the selection region, switch back to the main keymap and process
# the typed keys again.
function shift-select::deselect-and-input() {
	zle deactivate-region -w
	# Switch back to the main keymap (emacs).
	zle -K main
	# Push the typed keys back to the input stack, i.e. process them again,
	# but now with the main keymap.
	zle -U "$KEYS"
}
zle -N shift-select::deselect-and-input

# If the selection region is not active, set the mark at the cursor position,
# switch to the shift-select keymap, and call $WIDGET without 'shift-select::'
# prefix. This function must be used only for shift-select::<widget> widgets.
function shift-select::select-and-invoke() {
	if (( !REGION_ACTIVE )); then
		zle set-mark-command -w
		zle -K shift-select
	fi
	zle ${WIDGET#shift-select::} -w
}

function {
	emulate -L zsh

	# Create a new keymap for the shift-selection mode.
	bindkey -N shift-select

	# Bind all possible key sequences to deselect-and-input, i.e. it will be used
	# as a fallback for "unbound" key sequences.
	bindkey -M shift-select -R '^@'-'^?' shift-select::deselect-and-input

	local kcap seq seq_mac widget

	# Bind Shift keys in the emacs and shift-select keymaps.
	for	kcap   seq          seq_mac    widget (             # key name
		kLFT   '^[[1;2D'    x          backward-char        # Shift + LeftArrow
		kRIT   '^[[1;2C'    x          forward-char         # Shift + RightArrow
		kri    '^[[1;2A'    x          up-line              # Shift + UpArrow
		kind   '^[[1;2B'    x          down-line            # Shift + DownArrow
		kHOM   '^[[1;2H'    '^[[2H'    beginning-of-line    # Shift + Home
		x      '^[[97;6u'   x          beginning-of-line    # Shift + Ctrl + A
		kEND   '^[[1;2F'    '^[[2F'    end-of-line          # Shift + End
		x      '^[[101;6u'  x          end-of-line          # Shift + Ctrl + E
		x      '^[[1;6D'    '^[[1;6D'  backward-word        # Shift + Ctrl + LeftArrow
		x      '^[[1;6C'    '^[[1;6C'  forward-word         # Shift + Ctrl + RightArrow
		x      '^[[1;6H'    '^[[1;4H'  beginning-of-buffer  # Shift + Ctrl/Option + Home
		x      '^[[1;6F'    '^[[1;4F'  end-of-buffer        # Shift + Ctrl/Option + End
	); do
		# Use alternative sequence (Option instead of Ctrl) on macOS, if defined.
		[[ "$OSTYPE" = darwin* && "$seq_mac" != x ]] && seq=$seq_mac

		zle -N shift-select::$widget shift-select::select-and-invoke
		bindkey -M emacs ${terminfo[$kcap]:-$seq} shift-select::$widget
		bindkey -M shift-select ${terminfo[$kcap]:-$seq} shift-select::$widget
	done

	# macOS標準ターミナル用の追加キーバインド（フォールバック対応）
	if [[ "$OSTYPE" = darwin* ]]; then
		# macOS標準ターミナルでよく使用される代替キーシーケンス
		local additional_bindings=(
			'^[[H'     shift-select::beginning-of-line   # Alternative Shift + Home
			'^[[F'     shift-select::end-of-line         # Alternative Shift + End
			'^[OH'     shift-select::beginning-of-line   # Another alternative
			'^[OF'     shift-select::end-of-line         # Another alternative
		)
		
		for i in {1..${#additional_bindings[@]}..2}; do
			local key_seq="${additional_bindings[$i]}"
			local widget_name="${additional_bindings[$((i+1))]}"
			
			# emacsとshift-selectの両方のキーマップに追加
			bindkey -M emacs "$key_seq" "$widget_name" 2>/dev/null
			bindkey -M shift-select "$key_seq" "$widget_name" 2>/dev/null
		done
	fi

	# Bind keys in the shift-select keymap.
	for	kcap   seq        widget (                          # key name
		kdch1  '^[[3~'    shift-select::kill-region         # Delete
		bs     '^?'       shift-select::kill-region         # Backspace
	); do
		bindkey -M shift-select ${terminfo[$kcap]:-$seq} $widget
	done

	# Bind copy/paste/cut keys in both emacs and shift-select keymaps.
	
	# Basic key bindings that work in all environments (from ver1.md)
	bindkey -M emacs '^C' zle-clipboard-copy               # Ctrl+C (智能コピー)
	bindkey -M emacs '^X' shift-select::cut-region         # Ctrl+X
	bindkey -M emacs '^V' shift-select::paste              # Ctrl+V
	bindkey -M shift-select '^C' zle-clipboard-copy        # Ctrl+C (智能コピー)
	bindkey -M shift-select '^X' shift-select::cut-region  # Ctrl+X
	bindkey -M shift-select '^V' shift-select::paste       # Ctrl+V
	
	# Universal fallback bindings that should work in most environments
	bindkey -M emacs '^[[21~' shift-select::copy-region    # F10 key (universal)
	bindkey -M shift-select '^[[21~' shift-select::copy-region # F10 key
}
