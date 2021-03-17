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
- n-N ~ navigate highlighted text
- G ~ go bottom
- gg ~ go top
- { ~  

### rollback changes:

- u ~ revert in normal mode
- <C+r> revert the change

### selection:

- S-up/down/left/right/PgUp/PgDown/home/end ~ select text
- d ~ delete text and copy deleted text to so clipboard
- dd ~ delete line
- x ~ delete text

-  < & > ~ shift left/right

### text & formatting:

- Gu ~ MAKE UPPERCASE
- GU ~ MAKE LOWERCASE
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
- :tab <tabname> ~ create new tab inside nvim
- gt ~ next tab
- gT ~ previous tab
- <Ctrl-PgUp/PgDown> ~ next/previous tab
- :tab split ~ duplicate current tab



### plugin manager:
- vim-plug

# plugins shortcuts:

## NERDTree:
- q ~ close nerdtree
- <C-t> ~ toggle nerdtree
- <C-f> ~ find current file on nerdtree

### TODO:

- setup:

plugins:
- vim-which-key
- ranger
- colorizer

- file icons
- autocompletion plugin (lsp native)
- fuzzy finder
- font colors
- highlight/replace text
- move blocks of selected code (and auto indent)
- vertical mouse creation


