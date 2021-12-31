# zpmod
# uncomment to use zpmod
#
# module_path+=( "$HOME/.zinit/mod-bin/zmodules/Src" )
# zmodload zdharma-continuum/zplugin

# 環境変数
if type nvim > /dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi
export XDG_CONFIG_HOME=$HOME/.config

# PATH
## cargo
export path=($HOME/.cargo/bin $path)

## Go
export GOPATH=$HOME/go
path=($GOPATH/bin $path)

# dircolors
if type dircolors > /dev/null; then
  test -r "$HOME/.nord-dircolors/src/dir_colors" && eval $(dircolors ~/.nord-dircolors/src/dir_colors)
fi

# aliases
# ocamlでrlwrapを有効に
alias ocaml="rlwrap ocaml"
alias luajitlatex='luajittex --fmt=luajitlatex.fmt'
# neovim as vim
if type nvim > /dev/null; then
    alias vim=nvim
fi
# neovim-remote
alias nvim-server='NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim'
# git
alias git-rmbr="git pull --prune && git branch -r | awk '{print \$1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print \$1}' > /tmp/merged-branches && vim /tmp/merged-branches && xargs git branch -d < /tmp/merged-branches"
# ps
alias psgrep="ps aux | grep"
# rails
alias be="bundle exec"
# xclipのデフォルトselection
alias xclip="xclip -selection clipboard"
# latex
alias biber-uplatex="biber --bblencoding=utf8 -u -U --output_safechars"
# kubectl
alias k="kubectl"
# ls
alias ls="ls --color=auto"
# exa
alias le="exa"
alias lef="exa -F"

# 補完で大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# '#' 以降をコメントとして扱う
setopt interactive_comments

# emacsとviを組み合わせたキーバインドにする
bindkey -e
bindkey -M main "\e" vi-cmd-mode
# surround.vimのような機能
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -a cs change-surround
bindkey -a ds delete-surround
bindkey -a ys add-surround
bindkey -M visual S add-surround
# push-line
bindkey -M vicmd "q" push-line

# zshの入力モード切り替えの時間を短く
KEYTIMEOUT=1

#
# zleiab
#
setopt extended_glob

typeset -A abbreviations
abbreviations=(
  "Il"    "| less"
  "Ia"    "| awk"
  "Ig"    "| rg"
  "Ih"    "| head"
  "It"    "| tail"
  "Is"    "| sort"
  "Iw"    "| wc"
  "Ix"    "| xargs"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

# 履歴
# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
setopt hist_ignore_all_dups
# 開始と終了を記録
setopt EXTENDED_HISTORY
# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space
# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# タイプミスを修正するか聞くように
setopt correct

# 補完候補をハイライト
zstyle ':completion:*:default' menu select=2

# 補完関数の表示を強化する
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

# 補完後に|でスペースを削除しない
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

# ディレクトリの移動履歴を保存
setopt auto_pushd

# cdするたびにls。多いときは省略して表示
chpwd() {
  ls_abbrev
}
ls_abbrev() {
  # -a : Do not ignore entries starting with ..
  # -C : Force multi-column output.
  # -F : Append indicator (one of */=>@|) to entries.
  local cmd_ls='ls'
  local -a opt_ls
  opt_ls=('-CF' '--color=always')
  case "${OSTYPE}" in
    freebsd*|darwin*)
      if type gls > /dev/null 2>&1; then
        cmd_ls='gls'
      else
        # -G : Enable colorized output.
        opt_ls=('-CFG')
      fi
      ;;
  esac

  local ls_result
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

  local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

  if [ $ls_lines -gt 10 ]; then
    echo "$ls_result" | head -n 5
    echo '...'
    echo "$ls_result" | tail -n 5
    echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
  else
    echo "$ls_result"
  fi
}

# auto_pushd
DIRSTACKSIZE=100
setopt AUTO_PUSHD
setopt pushd_ignore_dups
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Ctrl-Dでログアウトしない
setopt IGNOREEOF

# lilypond
function lilypond-m () {
    lilypond "$1" && mid2m4a "${1%.*}.midi"
}
function lilypond-p () {
    lilypond "$1" && open "${1%.*}.pdf"
}
function lilypond-pm () {
    lilypond "$1" && open "${1%.*}.pdf" && mid2m4a "${1%.*}.midi"
}
alias lilypond-mp='lilypond-pm'

# beepを消す
setopt nobeep

# pathの重複をなくす
typeset -U path cdpath fpath manpath

# 単語削除で/で止まるように
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars ' /=;@:{}[]()<>,|.'
zstyle ':zle:*' word-style unspecified

# cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 1000

# Ctrl-Zでfg
_zsh_cli_fg() { fg; }
zle -N _zsh_cli_fg
bindkey '^Z' _zsh_cli_fg

# fpath
fpath=($fpath $HOME/.zsh/completion(N-/))

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

zinit ice atinit'autoload -Uz colors; colors'
zinit snippet OMZP::colored-man-pages

zinit snippet OMZP::git-auto-fetch

zinit ice wait"0" blockf lucid
zinit light zsh-users/zsh-completions

zinit ice wait"0" \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
  atload"fast-theme -q q-jmnemonic" \
  atload"noglob unset FAST_HIGHLIGHT[chroma-ruby]" \
  lucid
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit ice wait"0" pick"git-escape-magic" lucid
zinit light "knu/zsh-git-escape-magic"

# rbenv
path=($HOME/.rbenv/bin(N-/) $path)
zinit ice wait"0" lucid has"rbenv"
zinit light htlsne/zinit-rbenv

# OS毎の設定ファイルを読み込む
[ -f $HOME/.zshrc.`uname` ] && source $HOME/.zshrc.`uname`

# git管理しない設定ファイルを読み込む
[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local

# fzfの設定
# fzfコマンドが存在し、設定ファイルも存在するとき読み込む
if type fzf > /dev/null && [ -f $HOME/.zshrc.fzf ]; then
    source $HOME/.zshrc.fzf
fi

# mkdir and cd
function mkdircd() {
  mkdir $1 && cd $_
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
