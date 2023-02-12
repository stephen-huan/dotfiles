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
nnoremap <leader>v :source ~/.config/nvim/init.lua<cr>
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

" start server on first BufWrite, always call VimtexView
function s:start_server()
    if !g:latex_started
        VimtexCompile
        let g:latex_started = 1
    endif
    VimtexView
endfunction

" autocmds {{{1

augroup colors
    autocmd!
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
