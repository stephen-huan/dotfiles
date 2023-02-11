" pass will automatically do some of this, even with no configuration
" https://git.zx2c4.com/password-store/tree/contrib/vim/redact_pass.vim

set viminfo=
set history=0
set noswapfile
set nobackup
set nowritebackup
set noundofile
set secure
set nomodeline
set noshelltemp

set nocompatible               " turn off vi compatibility mode
set backspace=indent,eol,start " make backspace always work
set showcmd                    " show an incomplete command
set showmode                   " show mode

" save file for all modes
noremap  <c-s> :w<CR>
noremap! <c-s> <esc>:w<CR>li
" exit file for all modes
noremap  <c-q> <esc>:q!<CR>
noremap! <c-q> <esc>:q!<CR>

