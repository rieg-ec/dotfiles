# Neovim Config

Native LSP setup with nvim-cmp for autocompletion. Leader key is `;`.

## Installation

### Prerequisites

- Neovim 0.9+
- Node.js (for TypeScript, Vue, ESLint LSPs)
- ripgrep (for FZF/Telescope grep)

Language-specific:
- Ruby: solargraph + rubocop gems
- Python: pyenv + black
- C/C++: LLVM/clangd (`brew install llvm`)
- Rust: cargo

### Setup

```bash
# 1. Symlink config
ln -s ~/cs/dotfiles/nvim ~/.config/nvim

# 2. Install plugins
nvim +PlugInstall

# 3. LSP servers install automatically via Mason
#    Verify with :Mason inside nvim
```

## Plugin Manager

[vim-plug](https://github.com/junegunn/vim-plug) — plugins listed in `lua/user/plugins/plugins.vim`.

## Plugins

### LSP & Completion

| Plugin | Purpose |
|--------|---------|
| nvim-lspconfig | LSP client configuration |
| mason.nvim + mason-lspconfig | Auto-install LSP servers |
| nvim-cmp | Autocompletion engine |
| cmp-nvim-lsp, cmp-buffer, cmp-path, cmp-cmdline | Completion sources |
| LuaSnip + friendly-snippets | Snippet engine + library |
| UltiSnips + vim-snippets | Additional snippets |
| lspsaga.nvim | LSP UI enhancements (hover, rename, code actions) |
| lspkind.nvim | Completion item icons |
| conform.nvim | Code formatting (format on save) |
| schemastore.nvim | JSON schemas for jsonls |

### LSP Servers (via Mason)

- **Web:** ts_ls, eslint, vue_ls, tailwindcss, html, cssls, jsonls
- **Ruby:** solargraph, rubocop
- **Python:** pyright
- **Systems:** clangd, rust_analyzer
- **Other:** yamlls, lua_ls

### Formatters (via conform.nvim)

Python (black), Go (gofmt), Rust (rustfmt), C/C++ (clang_format), Shell (shfmt), Lua (stylua). Ruby and JS/TS use their LSPs for formatting.

### Editor

| Plugin | Purpose |
|--------|---------|
| NERDTree + nerdtree-git-plugin | File explorer |
| Comment.nvim | Toggle comments (gcc/gc) |
| auto-pairs | Auto-close brackets/quotes |
| vim-move | Move lines/blocks with Alt+j/k |
| vim-zoom | Zoom splits |
| nvim-treesitter | Syntax highlighting + text objects |
| rainbow-delimiters.nvim | Rainbow parentheses |

### Search

| Plugin | Purpose |
|--------|---------|
| fzf + fzf.vim | Fuzzy file/text search |
| telescope.nvim | LSP navigation (definitions, references) |
| cheatsheet.nvim | Searchable keybinding cheatsheet |

### Git

| Plugin | Purpose |
|--------|---------|
| gitsigns.nvim | Git signs in gutter, hunk staging |
| vim-fugitive | Git commands (:Git blame, :Git log, etc.) |
| vim-rhubarb | GitHub URLs for fugitive (:GBrowse) |
| diffview.nvim | Side-by-side diff viewer |
| octo.nvim | GitHub issues and PRs in Neovim |

### UI & Theme

| Plugin | Purpose |
|--------|---------|
| onedark.nvim | Color scheme (darker variant, transparent bg) |
| vim-airline | Status line |
| alpha-nvim | Dashboard / start screen |
| nvim-web-devicons | File type icons |

### Other

| Plugin | Purpose |
|--------|---------|
| copilot.vim | GitHub Copilot |
| ChatGPT.nvim | ChatGPT integration (requires OpenAI API key in `.env`) |
| markdown-preview.nvim | Live markdown preview in browser |
| vim-rails | Rails navigation/commands |
| vim-silicon | Code screenshots |
| vim-js + vim-jsx-pretty | JS/JSX syntax |

## Config Structure

```
lua/user/
├── core/
│   ├── options.lua        # Editor settings (tabs, clipboard, etc.)
│   ├── keymaps.lua        # All keybindings
│   ├── functions.lua      # Custom functions
│   └── git-diff.lua       # Git diff navigation
├── lsp/
│   ├── mason.lua          # LSP server installation list
│   ├── lspconfig.lua      # LSP setup orchestration
│   ├── cmp.lua            # Autocompletion config
│   ├── conform.lua        # Formatter config
│   ├── lspsaga.lua        # LSP UI config
│   └── languages/         # Per-language LSP settings
│       ├── web.lua        # TS, Vue, HTML, CSS, Tailwind
│       ├── ruby.lua       # Solargraph + RuboCop
│       ├── python.lua     # Pyright
│       ├── systems.lua    # C/C++, Rust, Go
│       └── other.lua      # YAML, Lua
├── plugins/
│   ├── plugins.vim        # vim-plug plugin list
│   └── *.lua              # Individual plugin configs
└── snippets/              # Custom snippets (React, JS, HTML)
```

## Keybindings

See `cheatsheet.txt` or run `:Cheatsheet` inside Neovim.
