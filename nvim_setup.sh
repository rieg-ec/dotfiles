#!/usr/bin/env bash

dotfiles_dir=$(pwd)
log_file=$HOME/install_progress_log.txt

if type -p nvim > /dev/null; then
    if [ -d $HOME/.config/nvim ]; then
        rm -rf $HOME/.config/nvim > /dev/null 2>&1
    fi

    mkdir -p $HOME/.config

    ln -sf $dotfiles_dir/nvim $HOME/.config/nvim
    ln -sf $dotfiles_dir/nvim/lua/user/plugins/coc-settings.json $HOME/.config/nvim/coc-settings.json

    sh -c 'curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    if [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
        echo "plug-vim installed" >> $log_file
        echo "installing plugins..."
        nvim --headless +PlugInstall +qa
        echo "plugins installed" >> $log_file
        echo "installing coc plugins..."
        nvim --headless +CocInstall +qa
        echo "coc plugins installed" >> $log_file
    else
        echo "plug-vim FAILED TO INSTALL!!" >> $log_file
    fi
else
    echo "neovim FAILED TO INSTALL!!!" >> $log_file
fi
