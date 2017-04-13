#!/bin/sh

DOTFILES_DIR=$(cd $(dirname $0);pwd)

cd $HOME

files=(.zsh .zshrc .zshrc.fzf .zshrc.`uname` .gitconfig .latexmkrc .tmux.conf .gitignore)

for file in ${files[@]}; do
  if [ -e $HOME/$file ]; then
    if [ -L $HOME/$file ]; then
      type=symlink
    elif [ -f $HOME/$file ]; then
      type=file
    else
      type=directory
    fi
    echo Already $type $HOME/$file exists.
    read -p 'Remove this? [y/n]' Answer
    case $Answer in
      [Yy]* )
        rm -rf $HOME/$file ;;
      [Nn]* )
        ;;
      * )
        echo Please answer YES or NO. ;;
    esac
  fi
done

for file in ${files[@]}; do
  echo Linking $file
  ln -s $DOTFILES_DIR/$file
done

ln -s $DOTFILES_DIR/.gitignore.`uname` .gitignore.os

# vim

vimfiles=(.vim .vimrc)

for file in ${vimfiles[@]}; do
  if [ -e $HOME/$file ]; then
    if [ -L $HOME/$file ]; then
      type=symlink
    elif [ -f $HOME/$file ]; then
      type=file
    else
      type=directory
    fi
    echo Already $type $HOME/$file exists.
    read -p 'Remove this? [y/n]' Answer
    case $Answer in
      [Yy]* )
        rm -rf $HOME/$file ;;
      [Nn]* )
        ;;
      * )
        echo Please answer YES or NO.  ;;
    esac
  fi
done

git clone https://github.com/htlsne/vimrc.git $HOME/.vim
