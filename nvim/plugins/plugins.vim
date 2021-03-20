call plug#begin('~/.config/nvim/plugged')

    Plug 'ncm2/ncm2'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'scrooloose/NERDTree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " theme
    Plug 'joshdick/onedark.vim'
    "Plug 'liuchengxu/vim-which-key' TODO
    Plug 'mhinz/vim-startify'      " cool starter page for nvim
    " Plug 'vwxyutarooo/nerdtree-devicons-syntax'   TODO
    Plug 'tpope/vim-commentary'    " comment lines and blocks of text

    " real time debugging with codi
    Plug 'metakirby5/codi.vim'     " TODO cling in cpp
    
    " Plug 'neovim/nvim-lspconfig' 
 
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'

    " auto completion with compe
    Plug 'hrsh7th/nvim-compe'

    " async autocompletion
    " Plug 'prabirshrestha/asyncomplete.vim'
    " Plug 'prabirshrestha/asyncomplete-lsp.vim'
    
    " bottom line info prettier
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " see buffers in bottom line
    Plug 'bling/vim-bufferline'

call plug#end()
