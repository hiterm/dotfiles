dirs=(dotfiles .vim .tmux.d/tmux-yank .tmux.d/nord-tmux .nord-dircolors)
for dir in ${dirs[@]}; do
  echo $dir:
  cd $HOME/$dir
  git pull
done
