#!/bin/bash

cd $HOME
git clone git@github.com:htlsne/dotfiles.git
./dotfiles/setup.sh

wget https://github.com/junegunn/fzf-bin/releases/download/0.18.0/fzf-0.18.0-linux_amd64.tgz
tar xzf fzf-0.18.0-linux_amd64.tgz
wget https://github.com/junegunn/fzf/raw/master/bin/fzf-tmux

mkdir bin
mv fzf fzf-tmux bin

echo "Please install neovim"
