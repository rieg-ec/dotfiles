set hidden                  " move through buffer without saving
set clipboard+=unnamedplus  " always use system clipboard for copy/paste
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set hlsearch                " highlight search results
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set nowrap                  " long lines as just one line
set smarttab                " detect if i have 2-4 spaces as tab
set cursorline              " highlight complete line under cursor
set numberwidth=2           " line number column space
filetype plugin indent on   " allows auto-indenting depending on file type
syntax on                   " syntax highlighting

let mapleader = ";"
let lsp_diagnostics_enabled = 1

let NERDTreeShowHidden = 1 " for dotfiles


let g:airline#extensions#tabline#enabled = 1 " Use the airline tabline (replacement for buftabline)

autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

" remove preview window when autocomplete done
autocmd CompleteDone * pclose
" set completeopt-=preview

" enable preview window (compe requirement)
set completeopt=menuone,noselect

autocmd BufRead,BufNewFile  *.txt,*.md setlocal wrap linebreak

" by default, the indent is 2 spaces. 
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" for html/rb files, 2 spaces
autocmd Filetype *.ruby setlocal ts=2 sw=2 expandtab
autocmd Filetype *.javascript setlocal ts=2 sw=2 expandtab
autocmd Filetype *.html setlocal ts=2 sw=2 expandtab
autocmd Filetype *.css setlocal ts=2 sw=2 expandtab
autocmd Filetype *.json setlocal ts=2 sw=2 expandtab
autocmd Filetype *.vue setlocal ts=2 sw=2 expandtab

" for js/coffee/jade files, 4 spaces
autocmd Filetype python setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype cpp setlocal ts=4 sw=4 sts=0 expandtab

" show differences between file in disk and current version
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

