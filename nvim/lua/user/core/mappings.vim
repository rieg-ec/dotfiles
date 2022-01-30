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

" COC
nmap <Leader>gd <Plug>(coc-definition)
nmap <Leader>gdc <Plug>(coc-declaration)
nmap <Leader>gD <Plug>(coc-type-definition)
nmap <Leader>gi <Plug>(coc-implementation)
" make arrow keys ignore completion windows:
inoremap <expr> <up> pumvisible() ? '<c-e><up>' : '<up>'
inoremap <expr> <down> pumvisible() ? '<c-e><down>' : '<down>'
" shift-tab un-tabs text if no pumvisible
imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-d>" 
imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-t>" 

inoremap <silent><expr> <C-space> coc#refresh()
" inoremap <Leader>s 
nnoremap <leader>a <Plug>(coc-codeaction-selected)

" nnoremap <expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
" nnoremap <expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-j> pumvisible() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-k> pumvisible() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
" vnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<Plug>MoveBlockDown"
" vnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<Plug>MoveBlockUp"

vmap <C-j> <Plug>MoveBlockDown
vmap <C-k> <Plug>MoveBlockUp

inoremap <silent><expr> <CR>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand',''])\<CR>" :
      \ "\<CR>" 

let g:coc_snippet_next = '<tab>'
let g:UltiSnipsExpandTrigger = '<nop>'
