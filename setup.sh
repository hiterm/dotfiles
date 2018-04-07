#!/bin/sh

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

DOTFILES_DIR=$(cd $(dirname $0);pwd)

cd $HOME

files=(.zsh .zshrc .zshrc.fzf .zshrc.`uname` .gitconfig .latexmkrc .tmux.conf .bundle)

exist_symlinks=()
exist_files=()
exist_dirs=()
for file in ${files[@]}; do
  if [ -e $HOME/$file ]; then
    if [ -L $HOME/$file ]; then
      echo "symlink $file"
      exist_symlinks+=($file)
    elif [ -f $HOME/$file ]; then
      exist_files+=($file)
    else
      exist_dirs+=($file)
    fi
  fi
done
echo "The following files exist."
echo "File: ${exist_files[@]}"
echo "Symlink: ${exist_symlinks[@]}"
echo "Directory: ${exist_dirs[@]}"

exist_all=(${exist_files[@]} ${exist_symlinks[@]} ${exist_dirs[@]})
while true; do
  read -p 'Remove these files? [y/n] ' Answer
  case $Answer in
    [Yy]* )
      for file in ${exist_all[@]}; do
        echo "Removing $file"
        rm -f $HOME/$file
      done
      break ;;
    [Nn]* )
      echo "Please remove them by yourself."
      exit ;;
    * )
      echo Please answer YES or NO. ;;
  esac
done

for file in ${files[@]}; do
  echo Linking $file
  ln -s $DOTFILES_DIR/$file $HOME/$file
done

echo Linking .gitignore
mkdir -p $HOME/$XDG_CONFIG_HOME/git
ln -s $DOTFILES_DIR/gitignore-global $HOME/$XDG_CONFIG_HOME/git/ignore

echo Linking .gitconfig.os
ln -s $DOTFILES_DIR/.gitconfig.`uname` .gitconfig.os

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

# neovim
ln -s $HOME/.vim $XDG_CONFIG_HOME/nvim

# tmux
mkdir $HOME/.tmux.d
git clone https://github.com/tmux-plugins/tmux-yank.git $HOME/.tmux.d/tmux-yank
