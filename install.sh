#!/usr/bin/env bash

#==============
# Variables
#==============
source ./env.sh

brew install bash && chsh -s /opt/homebrew/bin/bash

dotfiles_dir=$(pwd)
log_file=$HOME/install_progress_log.txt

# # ====================== bash config ======================
rm  $HOME/.bashrc > /dev/null 2>&1
rm $HOME/.bash_profile > /dev/null 2>&1  
ln -sf $dotfiles_dir/bash/.bashrc $HOME/.bashrc
ln -sf $dotfiles_dir/bash/.bash_profile $HOME/.bash_profile
# =========================================================

# # =========================== python packages ===========================
pip3 install flake8 autopep8 jedi pynvim
echo "installed python packages" >> $log_file
# # =======================================================================

# # ====================== nodejs and npm ======================
echo "installing node..."
NVM_DOWNLOAD_LINK=https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh
curl -o- NVM_DOWNLOAD_LINK | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install v15
nvm cache clear
echo "node $(node --version) installed" >> $log_file
# # =======================================================================

# # ====================== neovim config ======================
brew install --HEAD tree-sitter
brew install --HEAD luajit
brew install --HEAD neovim

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

# # ==========================================================


# # ====================== tmux config ======================
echo "installing tmux..."

brew install tmux

if type -p tmux > /dev/null; then
    echo "tmux Installed" >> $log_file
    
    rm -rf $HOME/.tmux.conf > /dev/null 2>&1
    
    ln -sf $dotfiles_dir/tmux/.tmux.conf $HOME/.tmux.conf

else
    echo "tmux FAILED TO INSTALL!!!" >> $log_file
fi  

# # =========================================================

brew install ripgrep # TODO: test for amd or arm arch to install ripgrep from source

if type -n rg > /dev/null 2>&1; then
    echo "rg $(rg --version | grep 'ripgrep') installed" >> $log_file
else
    echo "rg FAILED TO INSTALL!!!" >> $log_file
fi

brew install fzf

if test -n fzf > /dev/null 2>&1; then
    echo "fzf $(fzf --version) installed" >> $log_file
else
    echo "fzf FAILED TO INSTALL!!!" >> $log_file
fi

# #==============
# # Give the user a summary of what has been installed
# #==============
echo -e "\n====== Summary ======\n"
cat $log_file
rm $log_file