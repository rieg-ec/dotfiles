call plug#begin()

    " basic completion
    Plug 'ncm2/ncm2'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    
    " syntax highlighting
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " File Explorer
    Plug 'scrooloose/NERDTree'
    Plug 'Xuyuanp/nerdtree-git-plugin'

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

   " bottom line info prettier
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    
    " CoC completion
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " zoom in and out of windows
    Plug 'dhruvasagar/vim-zoom'

    " snippets with coc
    Plug 'honza/vim-snippets'

    " markdown visualization
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " show vim marks right next to line number
    Plug 'kshenoy/vim-signature'

    " git integration
    Plug 'airblade/vim-gitgutter'
    
    Plug 'puremourning/vimspector'

    Plug 'andymass/vim-matchup'
    
    Plug 'github/copilot.vim'

    Plug 'segeljakt/vim-silicon'

    Plug 'vim-ruby/vim-ruby'

call plug#end()
