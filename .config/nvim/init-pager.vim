" vim-plug plugins {{{1
call plug#begin(stdpath('data') . '/plugged') " Plugins will be downloaded under the specified directory.
Plug 'rakr/vim-one'               " Atom's One theme
Plug 'itchyny/lightline.vim'      " line
Plug 'easymotion/vim-easymotion'  " move around easily
call plug#end()                   " List ends here. Plugins become visible to Vim after this call.

" default options {{{1
" list of options ':options'
" editing {{{2
set nocompatible                  " turn off vi compatibility mode
set encoding=utf-8                " utf-8 encoding
set fileformat=unix               " UNIX file format
set shell=/usr/local/bin/fish     " shell

" appearance {{{2
set termguicolors                 " 24 bit colors
set background=light              " light background
syntax on                         " syntax highlighting
set laststatus=2                  " draw status bar for each window
set showcmd                       " show an incomplete command
set noshowmode                    " don't show mode, shown in bar already
set wildmenu                      " visual autocomplete for command menu
set number                        " line numbers
set relativenumber                " numbers relative to cursor line
set cursorline                    " highlight current line
" set cursorlineopt=screenline,number                " screenline vs file line
set noshowmatch                   " disable matching [{()}]
set nolist                        " disable show whitespace with characters
set wrap                          " wrap if longer than window size
set nolinebreak                   " disable break on specific characters
let &showbreak='↪ '               " show when the lines are wrapped
set breakindent                   " match indentation on wrapping
set colorcolumn=80                " display bar at 80 characters
set signcolumn=yes                " always draw signcolumn
set display=truncate,uhex         " truncate last line, display unicode as hex

" search {{{2
set ignorecase                    " ignore upper/lower case when searching
set smartcase                     " case sensitive if upper case 
set incsearch                     " show partial matches for a search phrase
set hlsearch                      " highlight all matching phrases
set wrapscan                      " wrap search

" windows {{{2
set nosplitbelow                  " split windows above
set splitright                    " split windows right

" miscellaneous {{{2
set clipboard=unnamedplus         " system clipboard
set mouse=a                       " mouse support
set mousemodel=popup              " right clicking opens a menu

" keybindings {{{1
" timing {{{2
set timeout                       " wait for mappings, if they are a prefix 
set ttimeout                      " timeout for key codes
set timeoutlen=1000               " delay for mappings until timeout 
set ttimeoutlen=10                " delay for key codes

" }}}2
let mapleader = "\<space>"        " leader prefix
" move visually
noremap <down> gj
noremap <up> gk

" ctrl shortcuts {{{2
" save file for all modes
noremap  <c-s> :w<cr>
noremap! <c-s> <esc>:w<cr>li
" exit file for all modes
noremap  <c-q> <esc>:q!<cr>
noremap! <c-q> <esc>:q!<cr>
" exit all tabs for all modes
noremap  <c-j> <esc>:qa!<cr>
noremap! <c-j> <esc>:qa!<cr>
" new tab
nnoremap <c-n> :tabnew<cr>

" show highlight under cursor
noremap <c-h> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

" leader shortcuts {{{2
" toggle search highlight
nnoremap <leader>c :set hlsearch! hlsearch?<cr>
" toggle spell check
nnoremap <leader>C :set spell! spell?<cr>
" source vimrc
nnoremap <leader>v :source ~/.config/nvim/init.vim<cr>
" reset syntax
nnoremap <leader>e :syntax off <bar> syntax on<cr>

" vim-easymotion {{{2
map s <Plug>(easymotion-jumptoanywhere)
map <leader>w <Plug>(easymotion-w)
map <leader>f <Plug>(easymotion-f)

map <s-right> <Plug>(easymotion-lineforward)
map <s-left>  <Plug>(easymotion-linebackward)
map <s-down>  <Plug>(easymotion-j)
map <s-up>    <Plug>(easymotion-k)

map <leader>; <Plug>(easymotion-next)
map <leader>, <Plug>(easymotion-prev)

map <leader>n <Plug>(easymotion-n)
map <leader>N <Plug>(easymotion-N)

" plugins {{{1
" one {{{2
function! s:set_colors()                                     " overwrite default colors
    highlight Normal                   guibg=#ffffff
    " error highlight from https://github.com/habamax/vim-polar
    highlight Error      guifg=#ffffff guibg=#e07070
 
    " spell highlight
    highlight SpellBad   guifg=#e45649 guibg=NONE    " red
    highlight SpellCap   guifg=#4078f2 guibg=NONE    " blue
    highlight SpellRare  guifg=#a626a4 guibg=NONE    " magenta
    highlight SpellLocal guifg=#0184bc guibg=NONE    " cyan
    " diff taken from https://github.com/endel/vim-github-colorscheme
    highlight DiffAdd    guifg=#494b53 guibg=#ddffdd " green
    highlight DiffChange               guibg=#f0f0f0 " grey
    highlight DiffText   guifg=#494b53 guibg=#ddddff " blue
    highlight DiffDelete guifg=#ffdddd guibg=#ffdddd " red
    " hide things
    highlight Hide       guifg=#ffffff guibg=NONE 
endfunction

augroup colors
    autocmd!
    autocmd ColorScheme * call <SID>set_colors() 
augroup END

let g:one_allow_italics = 1       " support italics
colorscheme one                   " colorscheme

" lightline {{{2
let g:lightline = {
\   'colorscheme': 'mono', 
\ }

" easymotion {{{2
let g:EasyMotion_smartcase = 1   " equivalent to vim's smartcase
let g:EasyMotion_startofline = 0 " don't change cursor position
" }}}1
" vim:foldmethod=marker:foldlevel=0:textwidth=0
