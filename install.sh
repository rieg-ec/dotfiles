#!/usr/bin/bash
set -o errexit    # exit when command fails

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
dotfiles_dir=~/dotfiles
log_file=~/install_progress_log.txt

source ./env.sh

if [ "$minimal" != true ] && [ "$install_node" != false ] ; then
    apt-get -y install npm nodejs
    if type -p npm > /dev/null && type -p nodejs > /dev/null; then
        echo "nodejs and npm Installed" >> $log_file
    else
        echo "npm and nodejs FAILED TO INSTALL!!!" >> $log_file
    fi
fi

# ====================== neovim config ======================
apt install -y neovim # TODO: is installing from source better for lua support?
apt install -y xsel # for neovim selection engine

if type -p nvim > /dev/null; then
    echo "neovim Installed" >> $log_file
else
    echo "neovim FAILED TO INSTALL!!!" >> $log_file
fi

if [ -d ~/.config/nvim ]; then
    rm -rf ~/.config/nvim > /dev/null 2>&1
fi

mkdir -p ~/.config

ln -sf $dotfiles_dir/nvim ~/.config/nvim

sh -c 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if [ -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
    echo "plug-vim installed" >> $log_file
else
    echo "plug-vim FAILED TO INSTALL!!" >> $log_file    
fi

# TODO: do i need to run PlugInstall or not?
# ==========================================================


# ====================== tmux config ======================
apt install -y tmux

if type -p tmux > /dev/null; then
    echo "tmux Installed" >> $log_file
else
    echo "tmux FAILED TO INSTALL!!!" >> $log_file
fi  

rm -rf ~/.tmux > /dev/null 2>&1
rm -rf ~/.tmux.conf > /dev/null 2>&1

ln -sf $dotfiles_dir/tmux/.tmux.conf ~/.tmux.conf

# =========================================================


# ====================== bash config ======================
rm -rf ~/.bashrc > /dev/null 2>&1
ln -sf $dotfiles_dir/bash/.bashrc ~/.bashrc
# =========================================================

#============= Docker & docker-compose =============#

if [ "$minimal" != true ] && [ "$install_docker" != false ]; then
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
        echo "docker Installed" >> $log_file
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
        echo "docker-compose installed" >> $log_file
    else
        echo "docker-compose FAILED TO INSTALL!!!" >> $log_file
    fi
fi
#===================================================#

# TODO: setup fzf and Rg and those things to make terminal better and comes with vim plugins
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install > /dev/null

if test -n fzf > /dev/null 2>&1; then
    echo "fzf installed" >> $log_file
else
    echo "fzf FAILED TO INSTALL!!!" >> $log_file
fi

wget -P /tmp/ripgrep https://github.com/BurntSushi/ripgrep/releases/download/12.1.1/ripgrep_12.1.1_amd64.deb
dpkg -i /tmp/ripgrep/ripgrep_12.1.1_amd64.deb

if test -n rg > /dev/null 2>&1; then
    echo "rg installed" >> $log_file
else
    echo "rg FAILED TO INSTALL!!!" >> $log_file
fi


#==============
# Give the user a summary of what has been installed
#==============
echo -e "\n====== Summary ======\n"
cat $log_file
rm $log_file
