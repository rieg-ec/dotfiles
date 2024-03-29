## Install plugins

- within vim: `:PlugInstall`

- CoC will install all extensions not already installed upon opening vim, but coc-clangd needs clangd binaries: `:CocCommand clangd.install`

# Useful nvim shortcuts:

### save/exit files:

- :w ~ save
- :q ~ quit
- :DiffSaved ~ see changes from last saved

### recording

- q<register> ~ start recording in register
- q ~ stop recording

### copy/paste:

- :reg ~ show registers
- yiw | bvey ~ yank word under cursor
- viwp | bvep ~ replace word under cursor with yanked word
- y ~ copy to system clipboard (visual mode, or selecting in insert mode)
- yy ~ copy entire line
- p ~ paste (from system clipboard, visual/normal mode)

### navigation:

- / ~ highlight <text>
- <Leader>/ ~ fzf text in current buffer
- :noh ~ reset highlighed text
- n ~ jump next highlight
- N ~ jump next highlight
- G ~ go bottom of file
- gg ~ go top of file
- ma ~ create mark "a"
- \`a ~ go to mark "a"
- { ~ navigate blocks of text
- <Leader>gf ~ go to file under cursor
- <C-6> ~ switch between last file and current file
- e ~ jump to next word (normal mode)
- ^ ~ jump to end of line
- $ ~ jump to beginning of line
- <Shift-v> ~ select line

- :%s//<replace>/ ~ replace one instance of highlighted text by <replace>
- :%s//<replace>/g ~ replace all instances of highlighted text by <replace>
- <Leader>f ~ put :%s/<match>/<replace>/gc into input to replace text one by one (normal)
- \`\` ~ go back to last cursor position after done with replacing

- zz ~ bring current line to middle of window
- <Ctrl-e> ~ scroll window instead of cursor (useful for scrolling past end of file)
- <Ctrl-y> ~ scroll window instead of cursor

### rollback changes:

- u ~ revert in normal mode
- <C+r> revert the revert

### selection:

- S-up/down/left/right/PgUp/PgDown/home/end ~ select text
- dd ~ delete line
- D ~ delete text from cursor to right
- x ~ delete text
- <C-v> + <S-arrow> ~ select text vertically
- < & > ~ shift left/right
- cc ~ remove line + insert mode (normal mode)
- r ~ replace word under cursor (normal mode)
- diw ~ remove word under cursor
- o ~ insert text under cursorline (normal mode)
- s ~ replace replace and insert

### text & formatting:

- ~ ~ swap case
- r + <char> ~ swap char under cursor by <char> (normal)
- :Format ~ format current buffer

### Modes:

- i ~ insert mode
- a ~ start insert from next character
- I ~ start in the beginning of line
- A ~ start in the end of line

### plugins:

- :PluginInstall ~ install plugins
- :PluginUpdate ~ install or update plugins
- :PlugClean[!] ~ remove unlisted plugins (bang version will clean without prompt)
- :PlugDiff ~ Examine changes from the previous update and the pending changes

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
- <C-Home/End> ~ move through vertical splits
- <C-W-arrows> ~ navigate splits
- <A-left/right> ~ resize tabs horizontally

### buffers:

- :bw ~ buffer wipeout
- <Tab> ~ go to next buffer
- <S-Tab> ~ go to previous buffer
- to change buffer without saving current one, :set hidden
- <Leader>z ~ zoom current split
- <Leader>c ~ close buffer and keep tab split

### shortcuts and macros management

- @: ~ repeat last ex command
- @@ ~ repeat last macro

### Extras

- set nuw=x ~ change line number column spacing

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

### command history

- q: ~ show commmmand history

### FZF

- :Files ~ search all files
- :GFiles ~ search files in version control with preview window
- :GFiles? ~ search files not staged for commit + its state (modified, untracked, deleted files)
- :Colors ~ change colorschemes
- :Lines ~ text search over lines in opened buffers
- :BLines ~ text search over current buffer
- :History ~ show recently opened buffers
- :Commits ~ show commit history with diffs -> <S-up/down> to explore
- :BCommits ~ git commits for current buffer
- :Mappings ~ show normal mode mappings
- :Filetypes ~ change filetype of current buffer

### VimSpector debugger

to install vimspector debuggers for specific language:\_ `VimspectorInstall <tab>`

-
