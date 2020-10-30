" vim-plug plugins {{{1
call plug#begin(stdpath('data') . '/plugged') " Plugins will be downloaded under the specified directory.
Plug 'rakr/vim-one'               " Atom's One theme
Plug 'itchyny/lightline.vim'      " line
Plug 'mhinz/vim-startify'         " start manager
Plug 'mbbill/undotree'            " visualize undo tree
Plug 'djoshea/vim-autoread'       " automatically load changed files
Plug 'junegunn/goyo.vim'          " distraction free writing
Plug 'francoiscabrol/ranger.vim'  " ranger integration
" Plug '/usr/local/opt/fzf'       " homebrew path to fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " cutting-edge fzf version
Plug 'junegunn/fzf.vim'           " fzf + vim integration
" Plug 'ycm-core/YouCompleteMe'                     " autocomplete
Plug stdpath('data') .  '/plugged/YouCompleteMe'    " load YCM without updating
Plug 'ncm2/float-preview.nvim'    " open previews in a floating window
Plug 'SirVer/ultisnips'           " snippets engine
Plug 'honza/vim-snippets'         " community snippets
Plug 'dense-analysis/ale'         " syntax checking
Plug 'tpope/vim-commentary'       " comment
Plug 'tpope/vim-sleuth'           " detect indent and adjust indent options 
Plug 'tpope/vim-surround'         " editing character pairs
Plug 'godlygeek/tabular'          " misc. text operations
Plug 'andymass/vim-matchup'       " matching
Plug 'vim-scripts/auto-pairs-gentle'                " insert pairs automatically               
Plug 'easymotion/vim-easymotion'  " move around easily
Plug 'tpope/vim-repeat'           " allow plugins to . repeat
Plug 'svermeulen/vim-yoink'       " maintain a yank history
Plug 'farmergreg/vim-lastplace'   " go to the last position when loading a file
Plug 'chrisbra/Colorizer', {'on': 'ColorHighlight', 'for': 'startify'}  " colors
Plug 'airblade/vim-gitgutter'     " show git in the gutter
Plug 'dstein64/vim-startuptime'   " measure startup time
Plug 'voldikss/vim-floaterm'      " floating terminal
" Plug 'mattn/emmet-vim'            " fancy web development plugin
" Plugins for specific languages
Plug 'vim-python/python-syntax'   " python
Plug 'Vimjas/vim-python-pep8-indent'                " python indent
Plug 'lervag/vimtex'              " LaTeX
Plug 'dag/vim-fish'               " fish shell
Plug 'tpope/vim-git'              " git
Plug 'octol/vim-cpp-enhanced-highlight'            " c++
" would be nice if there was a good java syntax plugin
Plug 'fatih/vim-go'               " go
Plug 'plasticboy/vim-markdown'    " markdown
" markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'chrisbra/csv.vim'           " CSVs
Plug 'stephpy/vim-yaml'           " yaml
Plug 'Glench/Vim-Jinja2-Syntax'   " jinja, setting up matchup
Plug 'pangloss/vim-javascript'    " javascript
Plug 'hail2u/vim-css3-syntax'     " css
Plug 'cakebaker/scss-syntax.vim'  " sass 
Plug 'tpope/vim-dadbod'           " databases
Plug 'vim-scripts/dbext.vim'      " original database plugin
Plug 'mityu/vim-applescript'      " applescript
Plug 'sudar/vim-arduino-syntax'   " arduino
call plug#end()                   " List ends here. Plugins become visible to Vim after this call.

" default options {{{1
" list of options ':options'
" providers {{{2
let g:python_host_prog   = '/usr/bin/python'
let g:python3_host_prog  = '/Users/stephenhuan/.pyenv/versions/3.8.5/bin/python'

" editing {{{2
set nocompatible                  " turn off vi compatibility mode
filetype plugin indent on         " autoindent based on filetype
set encoding=utf-8                " utf-8 encoding
set noarabicshape                 " disable arabic
set fileformat=unix               " UNIX file format
set shell=/usr/local/bin/fish     " shell
set backspace=indent,eol,start    " make backspace always work
set tabstop=4                     " number of visual spaces per tab
set expandtab                     " change tab into spaces
set softtabstop=0                 " since tab = spaces, tabs don't exist
set shiftwidth=4                  " number of spaces for shifting
set shiftround                    " round shifts to the nearest multiple
set autoindent                    " autoindent based on current line
set copyindent                    " get autoindent from other lines
set nrformats=alpha,hex,bin       " number formats for ctrl-a and ctrl-x

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

" backup/undo {{{2
set backup                        " store backups
" store file at nvim, defaulting to . if not found
set backupdir=~/.config/nvim/backupdir//,. 
" set patchmode=.orig               " store original files (doesn't store to backupdir)
set undofile                      " store undo information to a file
set undodir=~/.config/nvim/undodir,.
set directory=~/.config/nvim/swapdir//,. 
set updatetime=100                " swapfile write frequency, also cursor update

" spellcheck {{{2
" enable spellcheck locally for certain file types
set thesaurus+=~/.vim/thesaurus/english.txt  " add thesaurus
set dictionary+=/usr/share/dict/words        " add dictionary

" insert completions {{{2
" set completeopt=menuone,popup     " open extra information in a popup window 
set complete+=kspell              " spelling in autocomplete
set infercase                     " smartcase but for completions

" windows {{{2
set nosplitbelow                  " split windows above
set splitright                    " split windows right

" folding {{{2
set foldenable                    " enable folding
set foldlevelstart=0              " don't open folds by default

" sessions {{{2
set sessionoptions-=blank         " remove blank files from sessions

" miscellaneous {{{2
set clipboard=unnamedplus         " system clipboard
set mouse=a                       " mouse support
set mousemodel=popup              " right clicking opens a menu
set notildeop                     " ~ not an operator

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

" comments
vmap <c-_> gc 

" show highlight under cursor
noremap <c-h> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<cr>

" fzf {{{3
" mappings
nmap <c-p> <plug>(fzf-maps-n)
imap <c-p> <plug>(fzf-maps-i)
xmap <c-p> <plug>(fzf-maps-x)
omap <c-p> <plug>(fzf-maps-o)

" completions 
" replace the default dictionary completion with fzf-based fuzzy completion
inoremap <expr> <c-x><c-k> fzf#vim#complete('cat /usr/share/dict/words')
" path
imap <c-x><c-f> <plug>(fzf-complete-path)
" lines from any buffer
imap <c-x><c-l> <plug>(fzf-complete-line)

" thesaurus support with mythes (hunspell library)
function! s:get_words(e)
  let lines=system("fish -c \"_mythes '" . a:e . "' | _parse_mythes \"")
  return split(lines, '\n')
endfunction

inoremap <expr> <c-x><c-t> fzf#vim#complete(fzf#wrap({
\ 'source': function('<sid>get_words'), 
\ 'options': '--query ""'}))

" leader shortcuts {{{2
" toggle search highlight
nnoremap <leader>c :set hlsearch! hlsearch?<cr>
" toggle spell check
nnoremap <leader>C :set spell! spell?<cr>
" source vimrc
nnoremap <leader>v :source ~/.config/nvim/init.vim<cr>
" reset syntax
nnoremap <leader>e :syntax off <bar> syntax on<cr>

" startify {{{2
nnoremap <leader>s :execute 'SSave!' . fnamemodify(v:this_session, ':t')<cr>

" undotree {{{2
nnoremap <leader>u :UndotreeToggle<cr>

" goyo {{{2
nnoremap <leader>y :Goyo<cr>

" ranger {{{3
let g:ranger_map_keys = 0
nnoremap <leader>r :Ranger<cr>

" fzf {{{2
" directory jumping with z
nnoremap <leader>g :call fzf#run(fzf#wrap({
\ 'source': 'TMPFILE=`mktemp -t vim_fzf_z` \|\| exit 1; fish -c "_z" > $TMPFILE; cat $TMPFILE', 
\ 'sink': 'cd', 
\ 'options': ['--preview', '_preview_path {}']}))<cr>
" files with fzf
nnoremap <leader>o :Files<cr>
" ag searcher
nnoremap <leader>a :Ag<cr>
" lines in current buffer
nnoremap <leader>L :BLines<cr>
" windows
nnoremap <leader>W :Windows<cr>
" help
nnoremap <leader>H :Helptags<cr>

" use fzf to select a entry from the yank stack
function! s:yank_list()
  redir => y
  execute "Yanks"
  redir END
  return split(y, '\n')[1:]
endfunction

function! s:buf_copy(e)
  let s = substitute(a:e, '\', '\\\\\\\\', 'g')
  let s = escape(s, '''"\')
  echo system("fish -c \"echo -ne (string sub -s 3 (string replace -a '^M' '\\n' (_parse_token -p '" . s . "'))) | pbcopy\"")
endfunction

nnoremap <leader>p :call fzf#run(fzf#wrap({
\ 'source': <sid>yank_list(),
\ 'sink': function('<sid>buf_copy')}))<cr>

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

" vim-yoink {{{2
" nmap <leader>p <plug>(YoinkPostPasteSwapBack)
" nmap <leader>P <plug>(YoinkPostPasteSwapForward)

nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)

" vim-gitgutter {{{2
let g:gitgutter_map_keys = 0
nmap ghp <Plug>(GitGutterPreviewHunk)
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)

nmap [c <Plug>(GitGutterPrevHunk)
nmap ]c <Plug>(GitGutterNextHunk)

omap ic <Plug>(GitGutterTextObjectInnerPending)
omap ac <Plug>(GitGutterTextObjectOuterPending)
xmap ic <Plug>(GitGutterTextObjectInnerVisual)
xmap ac <Plug>(GitGutterTextObjectOuterVisual)

" vim-floaterm
nnoremap <leader>t :FloatermNew<CR>

" vim-markdown {{{2
map <Plug> <Plug>Markdown_MoveToCurHeader
map ]h <Plug>Markdown_MoveToCurHeader

" markdown-preview.nvim {{{2
nmap <leader>m <Plug>MarkdownPreview

" variable-based shortcuts {{{2
" YouCompleteMe
" fix YCM overwriting tab expansion for snippets
let g:ycm_key_list_select_completion=['<Down>']
let g:ycm_key_list_previous_completion=['<Up>']
" ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

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

" vim-startify {{{2
let g:startify_session_persistence = 0                       " update sessions

" undotree {{{2
let g:undotree_WindowLayout=3    " open on right side

" goyo.vim {{{2
let g:goyo_width=81              " weirdly, goyo character width changes by two

" fzf {{{2
" start in new window
" hide border because --border is part of the default args for fzf
let g:fzf_layout = {'window': 
\   { 'width': 0.9, 'height': 0.6, 
\     'highlight': 'Hide', 'border': 'rounded'
\   } 
\ }

" YouCompleteMe {{{2
let g:ycm_complete_in_comments = 1                           " run in comments

"ultisnips {{{2
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'snipps']    " directories

" ale {{{2
let g:ale_enabled = 0            " disable ale

" autopair {{{2
let g:AutoPairsUseInsertedCount = 1                          "'gentle' algorithm

" easymotion {{{2
let g:EasyMotion_smartcase = 1   " equivalent to vim's smartcase
let g:EasyMotion_startofline = 0 " don't change cursor position

" vim-yoink {{{2
let g:yoinkMaxItems=100          " history size
let g:yoinkIncludeDeleteOperations=1                         " include delete
let g:yoinkShowYanksWidth=1000   " number of characters stored

" Colorizer {{{2
let g:colorizer_auto_filetype='startify'                     " start on startify

" python-syntax {{{2
let g:python_highlight_all = 1    " highlight python

" vimtex {{{2
let g:tex_flavor='latex'          " don't use plain TeX
let g:vimtex_view_method='skim'   " set viewer
let g:vimtex_quickfix_autoclose_after_keystrokes=3           " close quickfix
let g:vimtex_compiler_latexmk = {
\   'executable' : 'latexmk',
\   'options' : [
\     '-verbose',
\     '-file-line-error',
\     '-synctex=1',
\     '-interaction=nonstopmode',
\     '-shell-escape'
\   ],
\}

" start server on first BufWrite, always call VimtexView
let g:latex_started = 0
function! s:start_server()
    if !g:latex_started
        VimtexCompile
        let g:latex_started = 1
    endif
    VimtexView
endfunction

" vim-markdown {{{2
let g:vim_markdown_folding_disabled = 1                      " disable autofold
let g:vim_markdown_strikethrough = 1                         " ~~strikethrough~~  
let g:vim_markdown_math = 1                                  " LaTeX

" markdown-preview.nvim {{{2
let g:mkdp_browser = 'Google Chrome'                         " browser

" }}}1
" autocmds {{{1
augroup vimrc
  autocmd!

  " only load custom header when startify starts
  autocmd VimEnter *
    \ if !argc()
    \ |   let g:startify_custom_header = startify#pad(split(system('cat ~/logo.txt'), '\n'))
    \ |  endif

  autocmd BufWritePost *.tex call <SID>start_server()

  autocmd FileType markdown,text,tex setlocal spell spelllang=en_us
  autocmd FileType c,cpp,python let b:ycm_hover = {
    \ 'command': 'GetDoc',
    \ 'syntax': &filetype
    \ }

  " disable file reloading
  " autocmd VimEnter * WatchForChangesAllFile
augroup END

" }}}1
" vim:foldmethod=marker:foldlevel=0:textwidth=0
