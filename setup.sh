#!/bin/sh

DOTFILES_DIR=$(cd $(dirname $0);pwd)

cd $HOME

files=(.zsh .zshrc .zshrc.fzf .zshrc.`uname` .gitconfig .latexmkrc .tmux.conf .gitignore)

for file in ${files[@]}; do
  if [ -e $HOME/$file ]; then
    echo Already $HOME/$file exists.
    read -p 'Remove this? [y/n]' Answer
    case $Answer in
      [Yy]* )
        rm $HOME/$file
        break;
        ;;
      [Nn]* )
        break;
        ;;
      * )
        echo Please answer YES or NO.
        ;;
    esac
  fi
done

for file in ${files[@]}; do
  echo Linking $file
  ln -s $DOTFILES_DIR/$file
done

vimfiles=(.vim .vimrc)

for file in ${vimfiles[@]}; do
  if [ -e $HOME/$file ]; then
    echo Already $HOME/$file exists.
    read -p 'Remove this? [y/n]' Answer
    case $Answer in
      [Yy]* )
        rm $HOME/$file
        break;
        ;;
      [Nn]* )
        break;
        ;;
      * )
        echo Please answer YES or NO.
        ;;
    esac
  fi
done

git clone git@github.com:htlsne/vimrc.git $HOME/.vim
