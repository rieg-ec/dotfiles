" save current buffer
nnoremap <Leader>w :w<CR>

" close current buffer
nnoremap <silent> <Leader>c :bp<BAR>bd#<CR>

" exchange cut for deletion
nnoremap d "_d
vnoremap d "_d

" make x not override clipboard
nnoremap x "_x
nnoremap s "_s

" make S-c not override clipboard
nnoremap <S-c> "_<S-c>

" rename a word
nnoremap r ciw

nnoremap { }
nnoremap } {
vnoremap { }
vnoremap } {

nnoremap <C-j> 100<C-d>
nnoremap <C-k> 100<C-u>

nnoremap <S-b> ^
nnoremap <S-e> $
vnoremap <S-b> ^
vnoremap <S-e> $h
" go to end of line in insert mode
inoremap <C-e> <Esc>A
" go to beginning of line in insert mode
" needs to press <b> twice due to tmux capturing the first press
inoremap <C-a> <Esc>I

nnoremap <Leader>/ :BLines<CR>

" paste in insert mode
inoremap <C-v> <Left><C-o>p

" switch lines
inoremap <C-Down> <Esc>:m .+1<CR>gi
inoremap <C-Up> <Esc>:m .-2<CR>gi

" move through buffers
nnoremap <tab> :bn<CR>
nnoremap <s-tab> :bp<CR>

" zoom on window
nmap <Leader>z <C-w>m

" tab navigation
nnoremap gt :tabnext<CR>
nnoremap gT :tabprevious<CR>

" get file
nnoremap <Leader>gf gf<CR>

" tab/untab blocks of selected text
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

" move through tab splits
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" resize tab splits
nnoremap <A-Left> <C-w><
nnoremap <A-Right> <C-w>>
nnoremap <M-Down> :resize +1<CR>
nnoremap <M-Up> :resize -1<CR>

" disable highlight when entering insert mode
nnoremap i :noh<CR>i
nnoremap a :noh<CR>a

" highlight visual selection pressing enter
xnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
nnoremap <silent> <cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>

" prompt to replace highlighted text one by one with y/n
nnoremap <Leader>f :%s///gc<Left><Left><Left><Left>

"NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" FZF
nnoremap ff <cmd>Files<CR>
nnoremap fg <cmd>Rg<CR>

" NOTE: LSP keybindings are now defined in lua/user/lsp/lspconfig.lua
" They will be automatically loaded when LSP attaches to a buffer
" Main keybindings:
"   <Leader>gd  - Go to definition
"   <Leader>gD  - Go to type definition
"   <Leader>gdc - Go to declaration
"   <Leader>gi  - Go to implementation
"   <Leader>gr  - Show references
"   <Leader>rn  - Rename symbol
"   <Leader>ac  - Code action
"   <Leader>F   - Format buffer
"   K           - Show hover documentation
"   [d          - Previous diagnostic
"   ]d          - Next diagnostic

" Completion mappings are handled by nvim-cmp in lua/user/lsp/cmp.lua
" Tab/S-Tab for navigation, Enter to confirm, C-j/C-k for scrolling docs

vmap <C-j> <Plug>MoveBlockDown
vmap <C-k> <Plug>MoveBlockUp


let g:UltiSnipsExpandTrigger = '<nop>'

imap <C-n> <Plug>(copilot-next)
imap <C-p> <Plug>(copilot-previous)
imap <silent><script><expr> <C-y> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

nnoremap ]c :lua get_next_commit('next')<CR>
nnoremap [c :lua get_next_commit('prev')<CR>
