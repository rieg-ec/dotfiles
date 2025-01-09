call plug#begin()
    Plug 'nvim-lua/plenary.nvim'

    Plug 'SirVer/ultisnips'
    Plug 'rieg-ec/vim-snippets'

    " LSP
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " File Explorer
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'

    " theme
    Plug 'navarasu/onedark.nvim'
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

    Plug 'lewis6991/gitsigns.nvim'
    Plug 'tpope/vim-fugitive'
    Plug 'sindrets/diffview.nvim'

    Plug 'github/copilot.vim'

    Plug 'tpope/vim-rails'

    Plug 'segeljakt/vim-silicon'

    Plug 'andymass/vim-matchup'

    Plug 'matze/vim-move'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'p00f/nvim-ts-rainbow'

    Plug 'yuezk/vim-js'
    Plug 'maxmellon/vim-jsx-pretty'

    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'sudormrfbin/cheatsheet.nvim'

    Plug 'jackMort/ChatGPT.nvim'
    Plug 'MunifTanjim/nui.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    " create shareable urls to upstream repository
    Plug 'tpope/vim-rhubarb'

    Plug 'HiPhish/rainbow-delimiters.nvim'
call plug#end()
