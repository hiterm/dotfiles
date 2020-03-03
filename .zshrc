# 環境変数
if type nvim > /dev/null; then
    export EDITOR=nvim
else
    export EDITOR=vim
fi
export XDG_CONFIG_HOME=$HOME/.config

# PATH
## cargo
export path=($path $HOME/.cargo/bin)

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
alias psgrep="ps aux | grep"
alias k="kubectl"
if type exa > /dev/null; then
    alias ls=exa
fi

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
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-max 1000

# fpath
fpath=($fpath $HOME/.zsh/completion(N-/))

# zinit
if [ ! -d $HOME/.zinit/bin/ ]; then
    git clone https://github.com/zdharma/zinit.git $HOME/.zinit/bin
fi
source ~/.zinit/bin/zinit.zsh

zinit ice wait"0" blockf lucid
zinit light zsh-users/zsh-completions

zinit ice depth=1
zinit light romkatv/powerlevel10k

zinit ice wait"0" atinit"zpcompinit; zpcdreplay" atload"fast-theme -q q-jmnemonic" lucid
zinit light zdharma/fast-syntax-highlighting

# rbenv
path=($HOME/.rbenv/bin(N-/) $path)
if type rbenv > /dev/null 2>&1; then
    zinit ice wait"0" lucid
    zinit light htlsne/zinit-rbenv
fi

# rails
alias be="bundle exec"

# xclipのデフォルトselection
alias xclip="xclip -selection clipboard"

# latex
alias biber-uplatex="biber --bblencoding=utf8 -u -U --output_safechars"

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
