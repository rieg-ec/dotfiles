#!/usr/bin/env bash

#==============
# Variables
#==============
dotfiles_dir=$(pwd)
log_file=$HOME/install_progress_log.txt

# # ====================== bash config ======================
rm  $HOME/.bashrc > /dev/null 2>&1
rm $HOME/.bash_profile > /dev/null 2>&1  
ln -sf $dotfiles_dir/bash/.bashrc $HOME/.bashrc
ln -sf $dotfiles_dir/bash/.bash_profile $HOME/.bash_profile

[ -s "$HOME/.bashrc" ] && \. "$HOME/.bashrc"

# ===========================================================

# # =========================== python packages =============
sudo pip3 install flake8 autopep8 jedi pynvim
echo "installed python packages" >> $log_file
# # =========================================================


# # =========================== ruby packages ===============
sudo gem install solargraph
# # =========================================================

# # ====================== nodejs and npm ===================
echo "installing node..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install v15
nvm cache clear
echo "node $(node --version) installed" >> $log_file
# # =========================================================

# # ====================== neovim config ====================
if type -p nvim > /dev/null; then
    echo "neovim $(nvim --version | grep 'NVIM v') Installed" >> $log_file
    
    if [ -d $HOME/.config/nvim ]; then
        rm -rf $HOME/.config/nvim > /dev/null 2>&1
    fi

    mkdir -p $HOME/.config

    ln -sf $dotfiles_dir/nvim $HOME/.config/nvim

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

# # =========================================================


# # ====================== tmux config ======================
if type -p tmux > /dev/null; then
    echo "tmux Installed" >> $log_file
    
    rm -rf $HOME/.tmux.conf > /dev/null 2>&1
    
    ln -sf $dotfiles_dir/tmux/.tmux.conf $HOME/.tmux.conf

else
    echo "tmux FAILED TO INSTALL!!!" >> $log_file
fi  

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

sh $dotfiles_dir/.macos

# #==============
# # Give the user a summary of what has been installed
# #==============
echo -e "\n====== Summary ======\n"
cat $log_file
rm $log_file
