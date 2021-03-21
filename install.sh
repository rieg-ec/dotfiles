

# nvim:
# install nvim
# install vim-plug
# install nerdtree icons (pending: install nerdtree plugin)
# 
# install plugins

# tmux:

# install plugin manager:
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

###### CoC extensions for neovim ######
#!/usr/bin/bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi
# Change extension names to the extensions you need
npm install coc-snippets coc-python coc-tsserver coc-html coc-css coc-json coc-yaml --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
