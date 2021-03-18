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
- p ~ paste (from system clipboard, visual mode)

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

### TODO:
- auto source config files

plugins:
- ranger (search for files and preview them)
- colorizer
- fz?
- file icons
- autocompletion plugin (lsp native)
- highlight/replace text
- move blocks of selected code (and auto indent)


