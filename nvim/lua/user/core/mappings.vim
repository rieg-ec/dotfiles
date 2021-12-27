" close current buffer
nnoremap <silent> <Leader>c :bp<BAR>bd#<CR>

" exchange cut for deletion
nnoremap d "_d
vnoremap d "_d

" make x not override clipboard
nnoremap x "_x

" rename a word
nnoremap r ciw

nnoremap { }
nnoremap } {
vnoremap { }
vnoremap } {

nnoremap <C-j> 100<C-d>
nnoremap <C-k> 100<C-u>

nnoremap $ ^
nnoremap ^ $
vnoremap $ ^
vnoremap ^ $

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

" indent blocks without loosing selection
vnoremap < <gv
vnoremap > >gv

" disable highlight when entering insert mode
nnoremap i :noh<CR>i
nnoremap a :noh<CR>a

" highlight visual selection pressing enter
xnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
nnoremap <silent> <cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>

" prompt to replace highlighted text one by one with y/n
nnoremap <Leader>f :%s///gc<Left><Left><Left><Left>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" LSP mappings (lua)
nnoremap <Leader>gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <Leader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <Leader>gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <Leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <Leader>gt <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <Leader>h <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <Leader><C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>


"NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

"Telescope
nnoremap ff <cmd>FZF<CR>
nnoremap fg <cmd>Rg<CR>
