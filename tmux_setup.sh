#!/usr/bin/env bash

dotfiles_dir=$(pwd)
log_file=$HOME/install_progress_log.txt

if type -p tmux > /dev/null; then
    echo "tmux Installed" >> $log_file

    rm -rf $HOME/.tmux.conf > /dev/null 2>&1
    rm -rf $HOME/.tmux > /dev/null 2>&1

    mkdir -p $HOME/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

    ln -sf $dotfiles_dir/tmux/.tmux.conf $HOME/.tmux.conf
else
    echo "tmux FAILED TO INSTALL!!!" >> $log_file
fi
