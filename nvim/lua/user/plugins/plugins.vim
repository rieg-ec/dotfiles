call plug#begin()
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/cmp-nvim-lsp'

    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'L3MON4D3/LuaSnip'

    " Plug 'rafamadriz/friendly-snippets'


    " File Explorer
    Plug 'scrooloose/NERDTree'
    Plug 'Xuyuanp/nerdtree-git-plugin'

    " theme
    Plug 'joshdick/onedark.vim'
    Plug 'numToStr/Comment.nvim'

   " bottom line info prettier
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    Plug 'goolord/alpha-nvim' 

    Plug 'jiangmiao/auto-pairs'
    
    " zoom in and out of windows
    Plug 'dhruvasagar/vim-zoom'

    " markdown visualization
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

    Plug 'kyazdani42/nvim-web-devicons'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " show vim marks right next to line number
    Plug 'kshenoy/vim-signature'

    " git integration
    Plug 'airblade/vim-gitgutter'
    
    Plug 'andymass/vim-matchup'

    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer'


    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'p00f/nvim-ts-rainbow'
call plug#end()
