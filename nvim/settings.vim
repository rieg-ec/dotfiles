set clipboard+=unnamedplus  " always use system clipboard for copy/paste
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set hlsearch                " highlight search results
set tabstop=4               " number of columns occupied by a tab character
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set nowrap                  " long lines as just one line
set smarttab                " detect if i have 2-4 spaces as tab
set cursorline              " highlight complete line under cursor
set completeopt=menuone,noselect " required for compe
filetype plugin indent on   " allows auto-indenting depending on file type
syntax on                   " syntax highlighting

let mapleader = ";"

autocmd WinEnter * setlocal cursorline " not working
autocmd WinLeave * setlocal nocursorline

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

