#!/usr/bin/bash

#### Full setup for desktop computers

# TODO: git, .gitconfig? 
# Steps:
#   1. install/setup neovim
#   2. install/setup tmux
#   3. setup bash
#   4. install useful stuff (npm, docker, docker-compose)

#==============
# Variables
#==============
source ./env.sh

if [ "$USER" != "root" ]; then
    HOME=/home/$USER
fi

dotfiles_dir=$(pwd)
log_file=$HOME/install_progress_log.txt

apt install -y lsb-release

. /etc/lsb-release # source release

# ====================== nodejs and npm ======================
if [ "$minimal" == false ] && [ "$install_node" == true ] ; then
    echo "installing node..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt install -y nodejs
    if type -p npm > /dev/null && type -p node > /dev/null; then
        echo "nodejs $(node --version) and npm $(npm --version) Installed" >> $log_file
    else
        echo "npm and nodejs FAILED TO INSTALL!!!" >> $log_file
    fi
fi

# ====================== neovim config ======================
echo "installing xsel and neovim..."

apt install -y xsel # for neovim selection engine

if [ $(python3 -c "print(1 if float($DISTRIB_RELEASE) < 19.04 else 0)") ]; then
    apt install -y software-properties-common
    add-apt-repository ppa:neovim-ppa/stable
fi

apt update && apt install -y neovim

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
    else
        echo "plug-vim FAILED TO INSTALL!!" >> $log_file    
    fi

else
    echo "neovim FAILED TO INSTALL!!!" >> $log_file
fi

# TODO: do i need to run PlugInstall or not?
# ==========================================================


# ====================== tmux config ======================
echo "installing tmux..."
apt install -y tmux

if type -p tmux > /dev/null; then
    echo "tmux Installed" >> $log_file
    
    rm -rf $HOME/.tmux > /dev/null 2>&1
    rm -rf $HOME/.tmux.conf > /dev/null 2>&1
    
    ln -sf $dotfiles_dir/tmux/.tmux.conf $HOME/.tmux.conf

else
    echo "tmux FAILED TO INSTALL!!!" >> $log_file
fi  

# =========================================================


# ====================== bash config ======================
rm -rf $HOME/.bashrc > /dev/null 2>&1
ln -sf $dotfiles_dir/bash/.bashrc $HOME/.bashrc
# =========================================================

#============= Docker & docker-compose =============#

if [ "$minimal" != true ] && [ "$install_docker" != false ]; then
    echo "installing docker and docker-compose..."
    apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt update
    apt install -y docker-ce docker-ce-cli containerd.io 

    if type -p docker > /dev/null; then
        echo "$(docker --version) Installed" >> $log_file
    else
        echo "docker FAILED TO INSTALL!!!" >> $log_file
    fi

    # add user to docker group to avoid asking for root privileges on each command
    usermod -aG docker $USER >> $log_file

    compose_version=1.28.6
    curl -L \
        "https://github.com/docker/compose/releases/download/$compose_version/docker-compose-$(uname -s)-$(uname -m)" -o \
        /usr/local/bin/docker-compose >> $log_file

    chmod +x /usr/local/bin/docker-compose

    if type -p docker-compose > /dev/null; then
        echo "$(docker-compose --version) installed" >> $log_file
    else
        echo "docker-compose FAILED TO INSTALL!!!" >> $log_file
    fi
fi
#===================================================#

apt install -y ripgrep # TODO: test for amd or arm arch to install ripgrep from source

if test -n rg > /dev/null 2>&1; then
    echo "rg $(rg --version | grep 'ripgrep') installed" >> $log_file
else
    echo "rg FAILED TO INSTALL!!!" >> $log_file
fi

if [ $(python3 -c "print(1 if float($DISTRIB_RELEASE) < 19.04 else 0)") ]; then
    echo "installing fzf trough git..."
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install > /dev/null
else
    echo "installing fzf trough apt..."
    apt install -y fzf
fi

if test -n fzf > /dev/null 2>&1; then
    echo "fzf $(fzf --version) installed" >> $log_file
else
    echo "fzf FAILED TO INSTALL!!!" >> $log_file
fi

#==============
# Give the user a summary of what has been installed
#==============
echo -e "\n====== Summary ======\n"
cat $log_file
rm $log_file
