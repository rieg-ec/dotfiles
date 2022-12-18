# My personal dotfiles :coffee:

## Install steps

1. clone repo
2. run `./setup.sh`
3. install pyenv: [https://github.com/pyenv/pyenv#automatic-installer](https://github.com/pyenv/pyenv#automatic-installer)
4. install python `pyenv install 3.10.4`
5. install python de packages:

   ```bash
   sudo python3 -m pip install flake8 autopep8 jedi pynvim
   ```

6. install rbenv: [https://github.com/rbenv/rbenv#:~:text=and some alternatives.-,Installation,-On systems with](https://github.com/rbenv/rbenv#:~:text=and%20some%20alternatives.-,Installation,-On%20systems%20with)
7. install ruby-build: [https://github.com/rbenv/ruby-build#readme](https://github.com/rbenv/ruby-build#readme)
8. install ruby: `rbenv install 3.1.3`
9. install ruby gems:

   ```bash
   gem install solargraph
   gem install bundler
   gem install rubocop
   ```

10. install nodenv-installer: [https://github.com/nodenv/nodenv-installer#nodenv-installer](https://github.com/nodenv/nodenv-installer#nodenv-installer)
11. install nodenv-alias: https://github.com/nodenv/nodenv-aliases
12. install node-build: https://github.com/nodenv/node-build
13. install node 16: `nodenv install 16.x.x && nodenv alias 16 --auto`
14. install neovim: https://github.com/neovim/neovim
15. run `./setup_nvim.sh`
16. install FZF: https://github.com/junegunn/fzf
17. install Rg: [https://github.com/BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
