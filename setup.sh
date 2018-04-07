#!/bin/sh

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

DOTFILES_DIR=$(cd $(dirname $0);pwd)

cd $HOME

files_to_link=(.zsh .zshrc .zshrc.fzf .zshrc.`uname` .gitconfig .latexmkrc .tmux.conf .bundle)
files_other=(.gitconfig.os .vimrc)
files=(${files_to_link[@]} ${files_other[@]})

exist_symlinks=()
exist_files=()
exist_dirs=()
for file in ${files[@]}; do
  if [ -e $HOME/$file ]; then
    if [ -L $HOME/$file ]; then
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
        rm -rf $HOME/$file
      done
      break ;;
    [Nn]* )
      echo "Please remove them by yourself."
      exit ;;
    * )
      echo Please answer YES or NO. ;;
  esac
done

# make symlink
for file in ${files_to_link[@]}; do
  echo Linking $file
  ln -s $DOTFILES_DIR/$file $HOME/$file
done

# git
echo Linking .gitignore
mkdir -p $HOME/$XDG_CONFIG_HOME/git
ln -s $DOTFILES_DIR/gitignore-global $HOME/$XDG_CONFIG_HOME/git/ignore
echo Linking .gitconfig.os
ln -s $DOTFILES_DIR/.gitconfig.`uname` $HOME/.gitconfig.os

# vim
git clone https://github.com/htlsne/vimrc.git $HOME/.vim

# neovim
echo Linking $XDG_CONFIG_HOME/nvim
ln -s $HOME/.vim $XDG_CONFIG_HOME/nvim

# tmux
mkdir $HOME/.tmux.d
git clone https://github.com/tmux-plugins/tmux-yank.git $HOME/.tmux.d/tmux-yank
