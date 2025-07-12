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
}

export ZENO_HOME="$XDG_CONFIG_HOME/zeno"
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

eval "$(/opt/homebrew/bin/brew shellenv)"

