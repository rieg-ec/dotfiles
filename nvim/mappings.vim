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

noremap     <F8>                  :wq<CR> " save with f8

" switch lines
inoremap <C-Down> <Esc>:m .+1<CR>gi
inoremap <C-Up> <Esc>:m .-2<CR>gi

" switch tabs
nnoremap <TAB> :tabn<CR>
nnoremap <S-TAB> :tabp<CR>

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

" move left a line of text in insert mode
inoremap <S-TAB> <C-D>
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

"NERDTree
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
