# Setup:

Run `./install.sh` (it will make a full installation, unless specified by env variables in `./env.sh`).

## Resources:

### Clipboard support

- Ubuntu:
    `sudo apt install xsel`
### vim-plug

- linux: `sh -c 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \ 
            https://raw.  githubusercontent.com/junegunn/vim-plug/master/plug.vim'`

### Install plugins

- within vim: `:PlugInstall`

- CoC will install all extensions not already installed upon opening vim, but coc-clangd needs clangd binaries: `:CocCommand clangd.install`


# Useful nvim shortcuts:

### save/exit files:

- ZZ ~ write current file and quit
- ZQ ~ exit without saving
- F8 ~ write and save
- :w ~ save
- :q ~ quit
- :wqa ~ write quit all


- :DiffSaved ~ see changes from last saved

### copy/paste:
- y ~ copy to system clipboard (visual mode, or selecting in insert mode)
- p ~ paste (from system clipboard, visual/normal mode)
- <C-o>p ~ paste (from system clipboard, insert mode)
- <C-v>v ~ paste (from system clipboard, insert mode) 
- <Ctrl-S> + v ~ paste in ex mode

### navigation:
- /<text> ~ highlight <text>
- :noh ~ reset highlighed text
- n ~ jump next highlight
- N ~ jump next highlight
- g ~ go bottom of file
- gg ~ go top of file
- { ~ navigate blocks of text
- <Leader>gf ~ go to file under cursor
- <C-6> ~ switch between last file and current file

- * ~ highlight word under cursor

- :%s//<replace>/ ~ replace one instance of highlighted text by <replace>
- :%s//<replace>/g ~ replace all instances of highlighted text by <replace>
- <Leader>f ~ put :%s/<match>/<replace>/gc into input to replace text one by one (normal)
- \`\` ~ go back to last cursor position after done with replacing
- <C-r> ~ enter text and replace with y/n one by one 

### rollback changes:

- u ~ revert in normal mode
- <C+r> revert the revert

### selection:

- S-up/down/left/right/PgUp/PgDown/home/end ~ select text
- d ~ delete text and copy deleted text to so clipboard
- dd ~ delete line
- x ~ delete text
- <C-v> + <S-arrow> ~ select text vertically

- < & > ~ shift left/right

- cc ~ change line
- r ~ replace word under cursor

### text & formatting:
- ~  ~ swap case
- r + <char> ~ swap char under cursor by <char> (normal)
- :Format ~ format current buffer

### Modes:

- i ~ insert mode
- a ~ start insert from next character
- I ~ start in the beginning of line
- A ~ start in the end of line


### plugins:

- :PluginInstall ~ install plugins
- :PluginUpdate  ~ install or update plugins
- :PlugClean[!]  ~ remove unlisted plugins (bang version will clean without prompt)
- :PlugDiff      ~ Examine changes from the previous update and the pending changes

### Tab management:
- gt ~ next tab (normal mode)
- gT ~ previous tab
- <TAB> ~ next tab (normal mode)
- <S-TAB> ~ previous tab (normal mode)

- :tab <file> ~ create new tab inside nvim
- :tab split ~ duplicate current tab
- :vsplit ~ create vertical split
- :hsplit ~ create horizontal split
- <C-h/j/k/l> ~ move to other windows
- <A-left/right> ~ resize tabs horizontally


### buffers:
- :bw ~ buffer wipeout
- <Tab> ~ go to next buffer
- <S-Tab> ~ go to previous buffer
- to change buffer without saving current one, :set hidden

- <Leader>z ~ zoom current split

### shortcuts and macros management
- @: ~ repeat last ex command
- @@ ~ repeat last macro

### plugin manager:
- vim-plug

## plugins shortcuts:

### Codi:
- :Codi ~ start codi

### NERDTree:
- q ~ close nerdtree
- <C-t> ~ toggle nerdtree
- <C-f> ~ find current file on nerdtree
- m ~ display action menu for current node

### vim-commentary:
- gc ~ comment line/block (visual mode)
- gcc ~ comment line (normal mode)

### CoC:
- <Leader>gd ~ jump to definition
- <Leader>gr ~ get reference
- <Leader>h ~ show docs?
- <Leader>gdc ~ jump to declaration
- <Leader>gi ~ jump to implementation
- <Leader>gD ~ jump to type definition
- <Leader>r ~ rename
- :Format ~ format entire file

### coc-snippets:
- <C-e> ~ expand snippets from coc-snippets
- <C-g>e ~ expand snippet or jump to next placeholder

### command history:
- q: ~ show commmmand history
