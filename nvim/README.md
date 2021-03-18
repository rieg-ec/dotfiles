# Useful nvim shortcuts:

### save/exit files:

- ZZ ~ write current file and quit
- ZQ ~ exit without saving
- F8 ~ write and save
- :w ~ save
- :q ~ quit
~ :wqa ~ write quit all

### copy/paste:
- y ~ copy to system clipboard (visual mode, or selecting in insert mode)
- p ~ paste (from system clipboard, visual/normal mode)
- <C-o>p ~ paste (from system clipboard, insert mode)

### navigation:

- /<text> ~ highlight <text>
- :noh ~ reset highlighed text
- n-N ~ navigate highlighted text
- G ~ go bottom
- gg ~ go top
- { ~ navigate blocks of text
- gf ~ go to filepath on new buffer
- <C-o> go to previous buffer

- * ~ highlight word under cursor
- <Enter> highlight word under cursor (normal mode)

- :%s//<replace>/ ~ replace one instance of highlighted text by <replace>
- :%s//<replace>/g ~ replace all instances of highlighted text by <replace>
- \f ~ put :%s/<match>/<replace>/gc into input to replace text one by one (normal)
- <C-r> ~ enter text and replace with y/n one by one 

- :DiffSaved ~ see changes from last saved

### rollback changes:

- u ~ revert in normal mode
- <C+r> revert the change

### selection:

- S-up/down/left/right/PgUp/PgDown/home/end ~ select text
- d ~ delete text and copy deleted text to so clipboard
- dd ~ delete line
- x ~ delete text
- <C-v> + <S-arrow> ~ select text vertically

-  < & > ~ shift left/right

### text & formatting:
- ~  ~ swap case
- r + <char> ~ swap char under cursor by <char> (normal)

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

- :tab <tabname> ~ create new tab inside nvim
- :tab split ~ duplicate current tab
- :split ~ create vertical split
- :hsplit ~ create horizontal split
- <C-h/j/k/l> ~ switch tabs
- <A-left/right> ~ resize tabs horizontally

### Codi:
- :Codi ~ start codi

### plugin manager:
- vim-plug

# plugins shortcuts:

## NERDTree:
- q ~ close nerdtree
- <C-t> ~ toggle nerdtree
- <C-f> ~ find current file on nerdtree

## vim-commentary:
- gc ~ comment line/block (visual mode)
- gcc ~ comment line (normal mode)

### lsp-nvim
- LspInstall ~ install language server for current filetype
    - install plugins
    - install language servers (lsp github instructions)

### command history:

- q: ~ show commmmand history


### TODO:
- setup lsp and figure out wtf with lua support
- auto source config files
- setup vim-plug installation in install.sh
- make codi launch automatically

plugins:
- autocompletion plugin (lsp native)
- ranger (search for files and preview them)?
- colorizer
- fzf?
- file icons (nerd fonts)
- move blocks of selected code (and auto indent)


