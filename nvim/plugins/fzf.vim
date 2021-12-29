let g:fzf_buffers_jump = 1

" command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, <bang>0)
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --color=always --smart-case -- '.shellescape(<q-args>), 2,
  \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
