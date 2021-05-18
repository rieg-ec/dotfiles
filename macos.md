# Setup instructions specific to macOS

setup:

0. `brew install bash`
1. add `"/opt/homebrew/bin/bash"` to `/etc/shells`
2. `chmod +x install.sh && ./install.sh`

things to do manually:

1. install docker desktop
2. install karabiner-elements && `rm ~/.config/karabiner/karabiner.json && ln -s ~/<dotfiles_repo>/karabiner.json ~/.config/karabiner/karabiner.json`
