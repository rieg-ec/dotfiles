function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <Leader>gd <plug>(lsp-definition)
    nmap <Leader>gi <plug>(lsp-implementation)
    nmap <Leader>gr <plug>(lsp-references)
    nmap <Leader>h <plug>(lsp-hover)
    nmap <Leader>gD <plug>(lsp-declaration)
    nmap <Leader>gs <plug>(lsp-document-symbol-search)
    nmap <Leader>gS <plug>(lsp-workspace-symbol-search)
    nmap <Leader>gt <plug>(lsp-type-definition)
    nmap <leader>rn <plug>(lsp-rename)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go,*py,*.js call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
