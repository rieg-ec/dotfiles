set hidden                  " move through buffer without saving
set clipboard+=unnamedplus  " always use system clipboard for copy/paste
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching brackets.
set ignorecase              " case insensitive matching
set hlsearch                " highlight search results
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
set nowrap                  " long lines as just one line
set smarttab                " detect if i have 2-4 spaces as tab
set smartindent
set autoindent
set numberwidth=2           " line number column space
filetype plugin indent on   " allows auto-indenting depending on file type
syntax on                   " syntax highlighting
set noshowmode
set mouse=a                 " mouse support
set expandtab

if has('nvim-0.5')
  set signcolumn=number
else
  set signcolumn=yes
endif

let mapleader = ";"
let lsp_diagnostics_enabled = 1

let NERDTreeShowHidden = 1 " for dotfiles
let g:MyNERDTreeIgnore = ['^__init__.py', '^__pycache__']
let g:NERDTreeIgnore = MyNERDTreeIgnore

let g:NERDTreeGitStatusIndicatorMapCustom = {
  \ 'Modified'  :'✚',
  \ 'Untracked' :'✭',
  \ 'Renamed'   :'➜',
  \ 'Deleted'   :'✖',
  \ 'Dirty'     :'✗',
  \ 'Ignored'   :'☒',
  \ 'Clean'     :'✔︎',
  \ 'Unknown'   :'?',
  \ }

function! s:myNERDTreeUnignoreAll()
  let g:MyNERDTreeIgnore=[] | call NERDTreeRender()
endfunction
com! MyNERDTreeUnignoreAll call s:MyNERDTreeUnignoreAll()

function! s:myNERDTreeIgnoreAll()
  let g:NERDTreeIgnore=MyNERDTreeIgnore | call NERDTreeRender()
endfunction
com! MyNERDTreeIgnoreAll call s:myNERDTreeIgnoreAll()

let g:airline#extensions#tabline#enabled = 1 " Use the airline tabline (replacement for buftabline)

" autocmd WinEnter * setlocal cursorline
" autocmd WinLeave * setlocal nocursorline

" remove preview window when autocomplete done
" autocmd CompleteDone * pclose
" set completeopt-=preview

" enable preview window
set completeopt=menuone,noselect

autocmd BufRead,BufNewFile  *.txt,*.md setlocal wrap linebreak

" by default, the indent is 2 spaces. 

" " status line:
" set laststatus=2
" set statusline=
" set statusline+=%=
" " mode
" set statusline+=%{StatuslineMode()}
" " modified tag
" set statusline+=%m
" " read only
" set statusline+=%r
" " path
" set statusline+=%F
" " current line number
" " set statusline+=%l
" " total lines
" set statusline+=%L
" " current column number
" " set statusline+=%c
" " encoding
" set statusline+=%{strlen(&fenc)?&fenc:'none'}
" https://www.tdaly.co.uk/projects/vim-statusline-generator/

set ts=2 sw=2 sts=2

" for html/rb files, 2 spaces
autocmd Filetype *.ruby setlocal ts=2 sw=2 sts=2
autocmd Filetype javascript setlocal ts=2 sw=2
autocmd Filetype *.html setlocal ts=2 sw=2 sts=2
autocmd Filetype *.css setlocal ts=2 sw=2 sts=2 
autocmd Filetype *.json setlocal ts=2 sw=2 sts=2
autocmd Filetype *.vue setlocal ts=2 sw=2 sts=2

" for js/coffee/jade files, 4 spaces

autocmd Filetype *.cpp setlocal ts=2 sw=2 sts=2

autocmd Filetype python setlocal ts=4 sw=4 sts=4
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']


" show differences between file in disk and current version
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

let g:loaded_matchit = 1


" function! StatuslineMode()
"   let l:mode=mode()
"   if l:mode==#"n"
"     return "NORMAL"
"   elseif l:mode==?"v"
"     return "VISUAL"
"   elseif l:mode==#"i"
"     return "INSERT"
"   elseif l:mode==#"R"
"     return "REPLACE"
"   elseif l:mode==?"s"
"     return "SELECT"
"   elseif l:mode==#"t"
"     return "TERMINAL"
"   elseif l:mode==#"c"
"     return "COMMAND"
"   elseif l:mode==#"!"
"     return "SHELL"
"   endif
" endfunction
