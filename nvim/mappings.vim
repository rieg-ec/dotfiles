" Select with shift + arrows
inoremap    <S-Left>              <Left><C-o>v
inoremap    <S-Right>             <C-o>v
inoremap    <S-Up>                <Left><C-o>v<Up><Right>
inoremap    <S-Down>              <C-o>v<Down><Left>
inoremap    <S-Home>              <C-o>v<Home>
inoremap    <S-End>               <C-o>v<End><left>
imap        <C-S-Left>            <S-Left><C-Left>
imap        <C-S-Right>           <S-Right><C-Right>
imap        <S-PageUp>            <C-o>v<S-PageUp>
imap        <S-PageDown>          <C-o>v<S-PageDown>
imap        <C-S-Left>            <S-Left><C-Left>
imap        <C-S-Right>           <S-Right><C-Right>
vnoremap    <S-Left>              <Left>
vnoremap    <S-Right>             <Right>
vnoremap    <S-Up>                <Up>
vnoremap    <S-Down>              <Down>
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>

" Auto unselect when not holding shift
vmap        <Left>                <Esc>
vmap        <Right>               <Esc><Right>
vmap        <Up>                  <Esc><Up>
vmap        <Down>                <Esc><Down>
vmap        <PageUp>              <Esc><PageUp>
vmap        <PageDown>            <Esc><PageDown>
vmap        <Home>                <Esc><Home>
vmap        <End>                 <Esc><End>


" exchange cut for deletion
nnoremap d "_d
vnoremap d "_d

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

" move through tab splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" resize tab splits
nnoremap <A-Left> <C-w><
nnoremap <A-Right> <C-w>>

" indent blocks without loosing selection
vnoremap < <gv

vnoremap > >gv


" disable highlight when entering insert mode
nnoremap i :noh<CR>i
nnoremap a :noh<CR>a

" ???????????
" nnoremap <Enter> <Enter>
" xnoremap <Enter> <Enter>

" highlight visual selection pressing enter
xnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<CR>

" prompt to replace highlighted text one by one with y/n
nnoremap <Leader>f :%s///gc<Left><Left><Left><Left>

" higlight word under cursor without moving cursor
nnoremap * <Cmd>let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>

" rename a word
nnoremap r ciw

"""""  CoC Code navigation  """""""""
nmap <Leader>gd <Plug>(coc-definition)
nmap <Leader>gdc <Plug>(coc-declaration)
nmap <Leader>gD <Plug>(coc-type-definition)
nmap <Leader>gi <Plug>(coc-implementation)
nmap <Leader>gr <Plug>(coc-references)
nmap <Leader>h :call <SID>show_documentation()<CR>
""""""""""""""""""""""""""""""""""""""

" CoC snippets
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" shift-tab un-tabs text if no pumvisible
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-D>" 
inoremap <silent><expr> <C-space> coc#refresh()
imap <C-e> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" LSP mappings: (currently using the ones in lsp-config.vim)
" nnoremap <Leader>gr :LspReference<CR>
" nnoremap <Leader>gd :LspDefinition<CR>
" nnoremap <Leader>gdc :LspDeclaration<CR>
" nnoremap <Leader>h :LspHover<CR>
" nnoremap <Leader>gt :LspTypeDefinition<CR>

" LSP mappings (lua)
" nnoremap <Leader>gd <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <Leader>gD <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <Leader>gr <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <Leader>gi <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <Leader>gt <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <Leader>h <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <Leader><C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

" get file
nnoremap <Leader>gf gf<CR> 


" TODO: assign gf to something more common
nnoremap gf :%s<Left> 

" move tab/untab blocks of selected text
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

"NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
