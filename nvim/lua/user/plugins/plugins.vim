call plug#begin()
    Plug 'nvim-lua/plenary.nvim'

    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    " LSP
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " File Explorer
    Plug 'preservim/nerdtree'
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

    " Plug 'posva/vim-vue'


    Plug 'kyazdani42/nvim-web-devicons'

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'lewis6991/gitsigns.nvim'
    Plug 'tpope/vim-fugitive'

    Plug 'github/copilot.vim'

    Plug 'vim-ruby/vim-ruby'
    Plug 'tpope/vim-rails'

    Plug 'segeljakt/vim-silicon'

    Plug 'andymass/vim-matchup'

    Plug 'matze/vim-move'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'p00f/nvim-ts-rainbow'

    Plug 'yuezk/vim-js'
    Plug 'maxmellon/vim-jsx-pretty'

    Plug 'rieg-ec/coc-tailwindcss', {'do': 'yarn install --frozen-lockfile && yarn build'}

    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'sudormrfbin/cheatsheet.nvim'
call plug#end()
