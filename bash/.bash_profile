if [ -f /etc/profile ]; then
    PATH=""
    source /etc/profile
fi

source $HOME/.bashrc


. "$HOME/.cargo/env"
