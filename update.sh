dirs=(dotfiles .vim .tmux.d/tmux-yank .tmux.d/tmux-gruvbox)
for dir in ${dirs[@]}; do
  echo $dir:
  cd $HOME/$dir
  git pull
done
