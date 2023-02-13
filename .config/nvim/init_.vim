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

augroup vimrc
  autocmd!

  autocmd BufWritePost *.tex call <sid>start_server()

  autocmd FileType markdown,text,tex,mail,gitcommit setlocal spell spelllang=en_us
  autocmd FileType c,cpp,python let b:ycm_hover = {
    \ 'command': 'GetDoc',
    \ 'syntax': &filetype
    \ }

  autocmd TermEnter * setlocal nonumber norelativenumber signcolumn=no
  autocmd TermEnter * DisableWhitespace

  " disable file reloading
  " autocmd VimEnter * WatchForChangesAllFile
augroup END

