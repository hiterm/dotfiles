# brew install zsh --disable-etcdir としたため
# /etc/zshenv の内容をコピーした
# system-wide environment settings for zsh(1)
if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
fi


PATH="/usr/local/bin:${PATH}:/usr/local/sbin:/Applications/Ghostscript.app"
PATH="${PATH}:/Users/ht/.bin"
export PATH

alias cemacs="open -a /Applications/Emacs.app"
alias ls="ls -G"
export LSCOLORS=gxfxcxdxbxegedabagacad

alias rm="rm -i"
alias mikutter="ruby ~/.bin/mikutter/mikutter.rb"
alias ustroku="wine ~/Others/Wine/USTroku108/USTroku.exe"

alias updatedb='/usr/libexec/locate.updatedb'

# Javaのエンコーディング
#export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF-8
alias java="java -Dfile.encoding=UTF-8"
alias javac="javac -encoding UTF-8"
# rbenvの設定
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# x11でuim
export LANG=ja_JP.UTF-8
export XMODIFIERS=@im=uim
export GTK_IM_MODULE=uim

# GTKのテーマを変える
export GTK_PATH=/usr/local/lib/gtk-2.0

# シェルのデフォルトエディタ
export EDITOR=vim

# Homebrewのエディタを設定
# export HOMEBREW_EDITOR=emacs

# 補完を増やす
fpath=(/Users/ht/.zsh/completion/zsh-completions/src $fpath)

# 補完機能を有効にする
autoload -Uz compinit
compinit

# Emacs Caskの補完を有効に
source /usr/local/share/zsh/site-functions/cask_completion.zsh

# 補完で大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# '#' 以降をコメントとして扱う
setopt interactive_comments

# emacs 風キーバインドにする
bindkey -e

# プロンプト
PROMPT='%F{blue}%n@%m%%%f '
# RPROMPT='%F{cyan}[%~]%f'

# VCSの情報を取得するzshの便利関数 vcs_infoを使う
autoload -Uz vcs_info

# 表示フォーマットの指定
# %b ブランチ情報
# %a アクション名(mergeなど)
zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

# バージョン管理されているディレクトリにいれば表示，そうでなければ非表示
RPROMPT="%1(v|%F{green}%1v%f|)%F{cyan}[%35<..<%~%<<]%f"

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
# setopt share_history

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
  opt_ls=('-aCF' '--color=always')
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
