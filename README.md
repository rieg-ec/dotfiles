# My personal dotfiles :coffee:

## Install steps

- clone repo
- install pyenv: [https://github.com/pyenv/pyenv#automatic-installer](https://github.com/pyenv/pyenv#automatic-installer)
- install python `pyenv install 3.10.4`
- install python de packages:
```bash
sudo python3 -m pip install flake8 autopep8 jedi pynvim
```
- install [rbenv](https://github.com/rbenv/rbenv#:~:text=and%20some%20alternatives.-,Installation,-On%20systems%20with)
- install [ruby-build](https://github.com/rbenv/ruby-build#readme)
- install ruby: `rbenv install 3.1.3`
- install ruby gems:
```bash
gem install solargraph
gem install bundler
gem install rubocop
```
- install [nodenv-installer](https://github.com/nodenv/nodenv-installer#nodenv-installer)
- install [nodenv-alias](https://github.com/nodenv/nodenv-aliases)
- install [node-build](https://github.com/nodenv/node-build)
- install node 16: `nodenv install 16.x.x && nodenv alias 16 --auto`
- install [neovim](https://github.com/neovim/neovim)
- run `./nvim_setup.sh`
- install [FZF](https://github.com/junegunn/fzf)
- install [Rg](https://github.com/BurntSushi/ripgrep)
- run `./setup.sh`

