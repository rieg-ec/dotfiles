#!/usr/bin/env bash

dotfiles_dir=$(pwd)
log_file=$HOME/install_progress_log.txt

# 1. symlink bash files
rm  $HOME/.bashrc > /dev/null 2>&1
rm $HOME/.bash_profile > /dev/null 2>&1
ln -sf $dotfiles_dir/bash/.bashrc $HOME/.bashrc
ln -sf $dotfiles_dir/bash/.bash_profile $HOME/.bash_profile
ln -sf $dotfiles_dir/bash/.bash-git-completion $HOME/.bash-git-completion
ln -sf $dotfiles_dir/bash/.bashrc_macOS $HOME/.bashrc_macOS
ln -sf $dotfiles_dir/.fzf.bash $HOME/.fzf.bash

# source bashrc
[ -s "$HOME/.bashrc" ] && \. "$HOME/.bashrc"

# global .gitignore
ln -sf $dotfiles_dir/.gitignore.global $HOME/.gitignore
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

# # ================== opencode ===============================
mkdir -p $HOME/.config/opencode
ln -sf $dotfiles_dir/opencode.json $HOME/.config/opencode/opencode.json
ln -sf $dotfiles_dir/opencode/plugins $HOME/.config/opencode/plugins
ln -sf $dotfiles_dir/opencode/commands $HOME/.config/opencode/commands
ln -sf $dotfiles_dir/opencode/agents $HOME/.config/opencode/agents

# # ================== agent-deck =============================
mkdir -p $HOME/.agent-deck
ln -sf $dotfiles_dir/agent-deck/config.toml $HOME/.agent-deck/config.toml

# # ================== local bin ==============================
mkdir -p $HOME/.local/bin
ln -sf $dotfiles_dir/bin/yolocode $HOME/.local/bin/yolocode
ln -sf $dotfiles_dir/bin/mem-watch $HOME/.local/bin/mem-watch
ln -sf $dotfiles_dir/bin/mem-watch-launchd $HOME/.local/bin/mem-watch-launchd

sh $dotfiles_dir/.macos # optional, macOS only
