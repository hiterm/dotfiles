# シェルのデフォルトエディタ
export EDITOR=vim

# PATH
path=($HOME/bin(N-/) \
    $path)

# OS毎の設定ファイルを読み込む
[ -f $HOME/.zshenv.`uname` ] && source $HOME/.zshenv.`uname`
