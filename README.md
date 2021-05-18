# My personal dotfiles :coffee:

_disclaimer: README files within directories are personal notes to save the shortcuts i use in case i forget them, but when displayed in github, the markdown ignores \< and \>. To see all the shortcuts i suggest cloning the repo and opening the markdown file in a text editor_

### Installation

1. `chmod +x install.sh`
2. `./install.sh`
3. add output of `which clangd` to `"clangd.path": "<here>"` in `nvim/coc-settings.json` for clangd lsp support

### TODO:

- add split resizing for horizontal splits with <ALT-Arrow>
- set up treesitter language installations in ./install.sh
  (:TSInstall cpp python javascript html css vue typescript c bash go graphql json lua vim php ruby toml yaml)

- learn to use/setup vimspector
- fold/unfold easily
- make backspace not move line after deleting last character
- maybe switch to zsh

plugins:

- file icons (nerd fonts)
- move blocks of selected code (and auto indent)
