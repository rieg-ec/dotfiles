" Select with shift + arrows
inoremap    <S-Left>              <Left><C-o>v
inoremap    <S-Right>             <C-o>v
inoremap    <S-Up>                <Left><C-o>v<Up><Right>
inoremap    <S-Down>              <C-o>v<Down><Left>
inoremap    <S-Home>              <C-o>v<Home>
inoremap    <S-End>               <C-o>v<End>
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

" switch lines
inoremap <C-Down> <Esc>:m .+1<CR>gi
inoremap <C-Up> <Esc>:m .-2<CR>gi

" move through buffers
nnoremap <tab> :bn<CR>
nnoremap <s-tab> :bp<CR>

" tab navigation
nnoremap gt gt
nnoremap gt :tabNext<CR>
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

" search/replace functionality:
" highlight the visual selection after pressing enter.
xnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<CR>
" highlight text under cursor pressing enter
nnoremap <silent> <cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>

" disable highlight when entering insert mode
nnoremap i :noh<CR>i
nnoremap a :noh<CR>a

" ???????????
" nnoremap <Enter> <Enter>
" xnoremap <Enter> <Enter>

" prompt to replace highlighted text one by one with y/n
nnoremap <Leader>f :%s///gc<Left><Left><Left><Left>

" LSP mappings:
" nnoremap <Leader>gr :LspReference<CR>
" nnoremap <Leader>gd :LspDefinition<CR>
" nnoremap <Leader>gdc :LspDeclaration<CR>
" nnoremap <Leader>h :LspHover<CR>
" nnoremap <Leader>gf gf<CR>
" nnoremap <Leader>gt :LspTypeDefinition<CR>

" TODO: assign gf to something more common
nnoremap gf :%s<Left> 

" asyncomplete tab completion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" move left a line of text in insert mode
inoremap <S-TAB> <C-D>
" move tab/untab blocks of selected text
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

"NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
