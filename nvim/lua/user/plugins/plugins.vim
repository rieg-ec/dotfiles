call plug#begin()
    Plug 'nvim-lua/plenary.nvim'

    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

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


    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'lewis6991/gitsigns.nvim'
    Plug 'tpope/vim-fugitive'

    Plug 'andymass/vim-matchup'

    Plug 'matze/vim-move'
call plug#end()
