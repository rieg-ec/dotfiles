# Dotfiles

Personal development environment configuration for macOS.

## What's Included

### Neovim (`nvim/`)
Full IDE-like setup with native LSP support:
- **Language servers**: TypeScript, Vue, Python (Pyright), Ruby (Solargraph + RuboCop), Go, Rust, C/C++, Tailwind CSS
- **Plugins**: Telescope, Treesitter, Gitsigns, Diffview, NERDTree, Copilot, ChatGPT integration
- **Formatting**: Auto-format on save via conform.nvim (black, eslint, rubocop, gofmt, rustfmt, etc.)
- **Completion**: nvim-cmp with LSP, buffer, path, and snippet sources

### Bash (`bash/`)
Shell configuration with development focus:
- Git branch in prompt
- Version managers: pyenv, rbenv, nodenv, jenv, nvm
- Git aliases (`gs`, `gd`, `ga`, `gri`, `gria`, `gcf`, `gca`, `grc`, `gpfl`)
- Docker utilities (`docker_wipe_container`, `docker_prune_all`)
- FZF integration

### Tmux (`tmux/`)
Terminal multiplexer config:
- Vi-mode keybindings
- Mouse support
- tmux-resurrect for session persistence (Ctrl-s save, Ctrl-r restore)
- New panes open in current directory

### Git (`.gitconfig`)
- Delta pager with side-by-side diffs
- zdiff3 merge conflict style

### macOS (`.macos`)
System defaults for keyboard, Finder, and trackpad.

## Setup Scripts

| Script | Purpose |
|--------|---------|
| `setup.sh` | Symlinks bash configs, sets up global gitignore |
| `nvim_setup.sh` | Installs vim-plug and plugins |
| `tmux_setup.sh` | Installs tpm and symlinks config |
| `brew.sh` | Installs Homebrew packages |

## Installation

```bash
# Clone and enter repo
git clone <repo> && cd dotfiles

# Install Homebrew packages
./brew.sh

# Version managers
# pyenv: https://github.com/pyenv/pyenv#automatic-installer
# rbenv: https://github.com/rbenv/rbenv
# nodenv: https://github.com/nodenv/nodenv-installer

# Run setup scripts
./setup.sh
./nvim_setup.sh
./tmux_setup.sh
```

### Language tooling

```bash
# Python
pyenv install 3.12
pip install pynvim

# Ruby
rbenv install 3.3
gem install solargraph rubocop bundler

# Node
nodenv install 22.x.x
```

