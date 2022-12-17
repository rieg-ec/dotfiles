#!/usr/bin/env bash

dotfiles_dir=$(pwd)
log_file=$HOME/install_progress_log.txt

# 1. symlink bash files
rm  $HOME/.bashrc > /dev/null 2>&1
rm $HOME/.bash_profile > /dev/null 2>&1
ln -sf $dotfiles_dir/bash/.bashrc $HOME/.bashrc
ln -sf $dotfiles_dir/bash/.bash_profile $HOME/.bash_profile

# source bashrc
[ -s "$HOME/.bashrc" ] && \. "$HOME/.bashrc"

# global .gitignore
ln -sd $dotfiles_dir/.gitignore.global $HOME/.gitignore
git config --global core.excludesfile ~/.gitignore

# # ================== ripgrep ===============================
if type -n rg > /dev/null 2>&1; then
    echo "rg $(rg --version | grep 'ripgrep') installed" >> $log_file
else
    echo "rg FAILED TO INSTALL!!!" >> $log_file
fi

# # ================== fzf ===================================
if test -n fzf > /dev/null 2>&1; then
    echo "fzf $(fzf --version) installed" >> $log_file
    $(brew --prefix)/opt/fzf/install
else
    echo "fzf FAILED TO INSTALL!!!" >> $log_file
fi

sh $dotfiles_dir/.macos # optional, macOS only
