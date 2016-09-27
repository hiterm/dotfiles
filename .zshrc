# zsh-completions
fpath=(/usr/local/share/zsh-completions(N-/) $fpath)

# 補完機能を有効にする
autoload -Uz compinit
compinit -u

# シェルのデフォルトエディタ
export EDITOR=vim

# ocamlでrlwrapを有効に
alias ocaml="rlwrap ocaml"
alias luajitlatex='luajittex --fmt=luajitlatex.fmt'

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

# プロンプト
PROMPT_MAIN='%F{blue}%n@%m%%%f '
# zshの入力モード情報を表示
terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
function zle-line-init zle-keymap-select {
    PROMPT_2="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}$PROMPT_MAIN"
    zle reset-prompt
}
preexec () { print -rn -- $terminfo[el]; }
zle -N zle-line-init
zle -N zle-keymap-select
# 右プロンプト
# 現在のパス
# 長いときはパスを省略
RPROMPT_1='%F{cyan}[%35<..<%~%<<]%f'
# Gitの情報を右プロンプトに表示
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
# 表示フォーマットの指定
# %b ブランチ情報
# %a アクション名(mergeなど)
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
# check-for-changes
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "+"    # 適当な文字列に変更する
zstyle ':vcs_info:git:*' unstagedstr "-"  # 適当の文字列に変更する
zstyle ':vcs_info:git:*' formats '[%b]%c%u'
zstyle ':vcs_info:git:*' actionformats '[%b|%a]%c%u'
function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg
# バージョン管理されているディレクトリにいれば表示，そうでなければ非表示
RPROMPT="%1(v|%F{green}%1v%f|)$RPROMPT_1"

# 履歴
# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
export HISTSIZE=1000
# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000
# 重複を記録しない
setopt hist_ignore_dups
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

# OS毎の設定ファイルを読み込む
[ -f $HOME/.zshrc.`uname` ] && . $HOME/.zshrc.`uname`

# fzfの設定
# fzfコマンドが存在し、設定ファイルも存在するとき読み込む
if type fzf > /dev/null && [ -f $HOME/.zshrc.fzf ]; then
    . $HOME/.zshrc.fzf
fi
