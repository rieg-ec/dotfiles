if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi

source $HOME/.bashrc
source $HOME/.bashrc_macOS


. "$HOME/.cargo/env"
