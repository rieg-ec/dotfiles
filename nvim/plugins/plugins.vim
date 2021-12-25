call plug#begin()
    " basic completion
    Plug 'ncm2/ncm2'
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-path'
    
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

   " bottom line info prettier
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    
    " zoom in and out of windows
    Plug 'dhruvasagar/vim-zoom'

    " markdown visualization
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install'  }

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " show vim marks right next to line number
    Plug 'kshenoy/vim-signature'

    " git integration
    Plug 'airblade/vim-gitgutter'
    
    Plug 'andymass/vim-matchup'
call plug#end()
