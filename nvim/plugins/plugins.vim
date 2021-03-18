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
    Plug 'joshdick/onedark.vim'
    "Plug 'liuchengxu/vim-which-key'
    Plug 'mhinz/vim-startify'      " cool starter page for nvim
    " Plug 'vwxyutarooo/nerdtree-devicons-syntax'
    Plug 'tpope/vim-commentary'    " comment lines and blocks of text
    " Plug 'lifecrisis/vim-difforig'
    " real time debugging with codi
    Plug 'metakirby5/codi.vim'
    " auto completion with compe
    " Plug 'neovim/nvim-lspconfig' requires lua support
    " LSP
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'

    " async autocompletion
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()
