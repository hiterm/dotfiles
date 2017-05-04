dirs=(dotfiles .vim .tmux.d/tmux-yank)
for dir in ${dirs[@]}; do
  echo $dir:
  cd $HOME/$dir
  git pull
done
