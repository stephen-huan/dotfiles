let g:polyglot_disabled = ['autoindent', 'sensible'] " needs to be before
" vim-plug plugins {{{1
call plug#begin(stdpath('data') . '/plugged') " Plugins will be downloaded under the specified directory.
Plug 'stephen-huan/vim-polar'     " fork of habamax/vim-polar
" color scheme editing
Plug 'lifepillar/vim-colortemplate'
Plug 'itchyny/lightline.vim'      " line
Plug 'mhinz/vim-startify'         " start manager
Plug 'mbbill/undotree'            " visualize undo tree
Plug 'djoshea/vim-autoread'       " automatically load changed files
Plug 'junegunn/goyo.vim'          " distraction free writing
Plug 'francoiscabrol/ranger.vim'  " ranger integration
Plug 'rbgrouleff/bclose.vim'      " dependency of ranger.vim
Plug 'junegunn/fzf'               " fzf
Plug 'junegunn/fzf.vim'           " fzf + vim integration
Plug 'ycm-core/YouCompleteMe'     " autocomplete
" Plug 'ncm2/float-preview.nvim'    " open previews in a floating window
Plug 'SirVer/ultisnips'           " snippets engine
Plug 'honza/vim-snippets'         " community snippets
" Plug 'dense-analysis/ale'         " syntax checking
Plug 'tomtom/tcomment_vim'        " comment
Plug 'tpope/vim-sleuth'           " detect indent and adjust indent options
Plug 'tpope/vim-surround'         " editing character pairs
Plug 'godlygeek/tabular'          " misc. text operations
Plug 'andymass/vim-matchup'       " matching
" insert pairs automatically
Plug 'vim-scripts/auto-pairs-gentle'
" highlight extra whitespace
Plug 'ntpeters/vim-better-whitespace'
Plug 'easymotion/vim-easymotion'  " move around easily
Plug 'tpope/vim-repeat'           " allow plugins to . repeat
Plug 'farmergreg/vim-lastplace'   " go to the last position when loading a file
Plug 'airblade/vim-gitgutter'     " show git in the gutter
Plug 'dstein64/vim-startuptime'   " measure startup time
" plugins for specific languages
Plug 'sheerun/vim-polyglot'       " language pack
Plug 'lervag/vimtex'              " LaTeX
Plug 'neomutt/neomutt.vim'        " email
Plug 'dag/vim-fish'               " fish shell
Plug 'tpope/vim-git'              " git
" cython
" Plug 'lambdalisue/vim-cython-syntax'
Plug 'stephen-huan/vim-cython-syntax'
" julia
Plug 'JuliaEditorSupport/julia-vim'
" would be nice if there was a good java syntax plugin
" markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }
Plug 'Glench/Vim-Jinja2-Syntax'   " jinja, setting up matchup
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" keybindings {{{1

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
noremap <c-h>h :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
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
function s:get_words(e)
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
" I would enable this if it worked
" let g:ranger_replace_netrw = 1
nnoremap <leader>r :RangerCurrentDirectoryNewTab<cr>

" fzf {{{2
" directory jumping with z
nnoremap <leader>g :call fzf#run(fzf#wrap({
\ 'source': 'fish -c "_z"',
\ 'sink': 'cd',
\ 'options': ['--preview', '_preview_path {}', '--tiebreak=index']}))<cr>
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

" tcomment_vim {{{2
let g:tcomment_mapleader1 = '<c-.>'
noremap  <c-_> :TComment<cr>
noremap  <leader>/ :TCommentBlock<cr>

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

" vim-markdown {{{2
map <Plug> <Plug>Markdown_MoveToCurHeader
map ]h <Plug>Markdown_MoveToCurHeader

" markdown-preview.nvim {{{2
nmap <leader>m <Plug>MarkdownPreview

" mail {{{2
function s:select_file()
  let temp = $HOME . '/.vim/temp.txt'
  execute 'silent !ranger --choosefile=' . temp
  redraw!
  " file name saved to file above, escape spaces
  if filereadable(temp)
    let path = readfile(temp)[0]
    let out = system("rm " . temp)
    return 'Attach: ' . substitute(path, ' ', '\\ ', 'g')
  endif
  return ''
endfunction

" select file with ranger for attachments
nnoremap <c-h>a "=<sid>select_file()<c-m>p
inoremap <c-h>a <esc>"=<sid>select_file()<c-m>p
" complete emails
inoremap <expr> <c-h>e fzf#vim#complete(fzf#wrap({
\ 'source': 'cat ~/.config/notmuch/emails.txt',
\ 'options': ['--tiebreak=index']}))

" variable-based shortcuts {{{2
" YouCompleteMe
" fix YCM overwriting tab expansion for snippets
let g:ycm_key_list_select_completion=['<down>']
let g:ycm_key_list_previous_completion=['<up>']
" ultisnips
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<c-b>'

" plugins {{{1
" lightline {{{2
" set lightline colorscheme
let g:lightline = {
\   'colorscheme': 'polar',
\ }
" remove 'fileformat' and 'fileencoding' from the default bar
let g:lightline.active = {
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'filetype' ] ]
    \ }

" vim-startify {{{2
" custom header
let g:startify_image_header = 1
if g:startify_image_header
  let logo_path = $HOME . '/.config/nvim/header.txt'
else
  let logo_path = $HOME . '/.config/nvim/header-box.txt'
end
let g:startify_custom_header = startify#pad(readfile(logo_path))
" update sessions
let g:startify_session_persistence = 0

" undotree {{{2
" open on right side
let g:undotree_WindowLayout=3

" goyo.vim {{{2
" weirdly, goyo character width changes by two
let g:goyo_width=81

" fzf {{{2
" start in new window
let g:fzf_layout = {'window':
\   { 'width': 0.9, 'height': 0.6, 'border': 'rounded'
\   }
\ }

" YouCompleteMe {{{2
" run in comments
let g:ycm_complete_in_comments = 1

"ultisnips {{{2
" directories
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'snipps']

" ale {{{2
" disable ale
let g:ale_enabled = 0

" autopair {{{2
" 'gentle' algorithm
let g:AutoPairsUseInsertedCount = 1

" vim-better-whitespace {{{2
" TODO: set 'listchars'
" disable highlighting on these filetypes
let g:better_whitespace_filetypes_blacklist = ['startify']

" easymotion {{{2
let g:EasyMotion_smartcase = 1   " equivalent to vim's smartcase
let g:EasyMotion_startofline = 0 " don't change cursor position

" python-syntax {{{2
let g:python_highlight_all = 1    " highlight python

" vimtex {{{2
let g:tex_flavor = 'latex'          " don't use plain TeX
let g:vimtex_view_method = 'sioyek' " set viewer
" let g:vimtex_view_sioyek_exe = 'sioyek'
" close quickfix
let g:vimtex_quickfix_autoclose_after_keystrokes=3
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
function s:start_server()
    if !g:latex_started
        VimtexCompile
        let g:latex_started = 1
    endif
    VimtexView
endfunction

" vim-markdown {{{2
let g:vim_markdown_folding_disabled = 1 " disable autofold
let g:vim_markdown_strikethrough = 1    " ~~strikethrough~~
let g:vim_markdown_math = 1             " LaTeX

" markdown-preview.nvim {{{2
" browser
let g:mkdp_browser = 'firefox'

" autocmds {{{1
function s:set_colors()
endfunction

augroup colors
    autocmd!
    autocmd ColorScheme * call <sid>set_colors()
    " https://vim.fandom.com/wiki/Highlight_unwanted_spaces
    " autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    " autocmd InsertEnter * call clearmatches()
    " autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    " autocmd BufWinLeave * call clearmatches()
    " https://vim.fandom.com/wiki/Remove_unwanted_spaces
    " remove trailing whitespace: %s/\s\+$//e
augroup END

" colorscheme
colorscheme polar

augroup vimrc
  autocmd!

  autocmd BufWritePost *.tex call <sid>start_server()

  autocmd FileType markdown,text,tex,mail,gitcommit setlocal spell spelllang=en_us
  autocmd FileType c,cpp,python let b:ycm_hover = {
    \ 'command': 'GetDoc',
    \ 'syntax': &filetype
    \ }

  autocmd TermOpen * setlocal nonumber norelativenumber signcolumn=no
  autocmd TermOpen * DisableWhitespace

  " disable file reloading
  " autocmd VimEnter * WatchForChangesAllFile
augroup END

" }}}1
" vim:foldmethod=marker:foldlevel=0
