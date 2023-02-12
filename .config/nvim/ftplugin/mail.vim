" limit to 72 character width lines, par is cleaner for emails
setlocal colorcolumn=73 formatprg=par\ w\ 72
" don't use modelines since we view other people's emails
setlocal nomodeline
" remap goyo to 72 characters
nnoremap <leader>y :Goyo 73<cr>

" vim-sleuth takes a long time 
let b:sleuth_automatic=0

