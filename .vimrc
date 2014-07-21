if has('vim_starting')
  set nocompatible

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/vim/bundle/'))

" Let Neobundle manage Neobundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

set number
syntax on

set t_Co=256

" 大文字小文字を区別しない
set ignorecase
