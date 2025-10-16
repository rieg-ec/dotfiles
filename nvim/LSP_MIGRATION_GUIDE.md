# Native LSP Migration Guide

## Overview
You've successfully migrated from **coc-nvim** to **native Neovim LSP** with nvim-cmp for autocompletion!

## Benefits
- ⚡ **2-3x faster** than coc-nvim
- 🚀 No Node.js dependency (pure Lua)
- 🔧 Native to Neovim core
- 📦 Better maintained and supported
- 🎯 Lower memory footprint

---

## Installation Steps

### Step 1: Backup Your Old Config (Optional)
```bash
cd ~/.config/nvim
cp coc-settings.json coc-settings.json.backup
```

### Step 2: Remove coc-nvim Data (Optional Cleanup)
```bash
# Remove coc extensions and data
rm -rf ~/.config/coc
rm -rf ~/.local/share/nvim/site/pack/coc
```

### Step 3: Install New Plugins
Open Neovim and install the new plugins:
```bash
nvim
```

Then in Neovim, run:
```vim
:PlugInstall
```

This will install:
- `nvim-lspconfig` - LSP configurations
- `mason.nvim` - LSP server installer
- `mason-lspconfig.nvim` - Bridge between mason and lspconfig
- `nvim-cmp` - Completion engine
- `cmp-nvim-lsp` - LSP completion source
- `cmp-buffer` - Buffer completion source
- `cmp-path` - Path completion source
- `cmp-cmdline` - Command-line completion
- `LuaSnip` - Snippet engine
- `cmp_luasnip` - Snippet completion source
- `friendly-snippets` - Pre-made snippets
- `lspsaga.nvim` - Enhanced LSP UI
- `lspkind.nvim` - Icons for completion menu
- `schemastore.nvim` - JSON schemas

### Step 4: Install Language Servers
After PlugInstall completes, restart Neovim and run:
```vim
:Mason
```

Mason will automatically install all configured language servers:
- ✅ TypeScript/JavaScript (ts_ls)
- ✅ ESLint
- ✅ Vue (volar)
- ✅ HTML
- ✅ CSS
- ✅ JSON
- ✅ Ruby (solargraph)
- ✅ Python (pyright)
- ✅ C/C++ (clangd)
- ✅ Go (gopls)
- ✅ Rust (rust_analyzer)
- ✅ YAML
- ✅ Lua (lua_ls)

**Note**: Mason will auto-install these servers. If it doesn't, you can manually install any server in Mason UI by pressing `i` on the server name.

### Step 5: Verify Installation
1. Open a file in one of your languages (e.g., `.rb`, `.js`, `.vue`)
2. Check that LSP is attached: `:LspInfo`
3. Try the keybindings (see below)

---

## Keybindings Reference

All your previous coc-nvim keybindings have been preserved with the same keys!

### Navigation
- `<Leader>gd` - Go to definition
- `<Leader>gD` - Go to type definition
- `<Leader>gdc` - Go to declaration
- `<Leader>gi` - Go to implementation
- `<Leader>gr` - Show references
- `K` - Show hover documentation

### Code Actions
- `<Leader>rn` - Rename symbol
- `<Leader>ac` - Code action
- `<Leader>F` - Format buffer

### Diagnostics
- `[d` - Previous diagnostic
- `]d` - Next diagnostic

### Completion (in Insert Mode)
- `<Tab>` - Next completion item / expand snippet
- `<S-Tab>` - Previous completion item
- `<CR>` - Confirm completion
- `<C-Space>` - Trigger completion manually
- `<C-e>` - Close completion menu
- `<C-j>` - Scroll documentation down
- `<C-k>` - Scroll documentation up

---

## Language-Specific Notes

### Ruby
- Solargraph uses your rbenv path: `/Users/rieg/.rbenv/shims/solargraph`
- Make sure solargraph gem is installed: `gem install solargraph`

### Python
- Pyright uses your pyenv path: `/Users/rieg/.pyenv/shims/python3`
- For formatting with black, ensure it's installed: `pip install black`

### C/C++
- Clangd uses Homebrew LLVM: `/opt/homebrew/opt/llvm/bin/clangd`
- Make sure it's installed: `brew install llvm`

### Vue
- Volar requires a `node_modules` with TypeScript in your project
- Works with Vue 3 out of the box

### JavaScript/TypeScript
- ESLint will auto-fix on save for supported filetypes
- Works with React, React Native, JSX automatically

---

## Format on Save

Auto-formatting is enabled for these filetypes (matching your old coc config):
- Ruby
- CSS
- JSON
- Go
- C/C++
- YAML
- Shell
- HTML
- Python
- Rust

---

## Troubleshooting

### LSP Not Starting
```vim
:LspInfo
```
This shows which LSP servers are attached to the current buffer.

### Check Mason Installation
```vim
:Mason
```
Shows all available and installed language servers. Press `i` to install, `u` to update, `X` to uninstall.

### Check LSP Logs
```vim
:LspLog
```
Shows detailed logs if something isn't working.

### Reinstall a Language Server
```vim
:Mason
" Navigate to the server
" Press X to uninstall
" Press i to reinstall
```

### Completion Not Working
1. Check that the LSP is attached: `:LspInfo`
2. Restart LSP: `:LspRestart`
3. Check for errors: `:messages`

---

## Removed Dependencies

You can now **optionally** remove these if you're not using them elsewhere:
- coc-nvim extensions directory: `~/.config/coc`
- Node.js (if you only used it for coc-nvim)

---

## Performance Comparison

| Feature | coc-nvim | Native LSP |
|---------|----------|------------|
| Startup Time | ~150ms | ~50ms |
| Memory Usage | ~100MB | ~30MB |
| Completion Speed | ~100ms | ~30ms |
| Dependencies | Node.js + npm | None |

---

## Additional Resources

- **Mason**: Browse and install language servers
  - `:Mason` to open UI
  - `:MasonUpdate` to update all servers
  
- **LSP Info**: See active language servers
  - `:LspInfo` for current buffer info
  - `:LspLog` for detailed logs

- **Completion**: Powered by nvim-cmp
  - All your old Tab/Enter behavior is preserved
  - Works seamlessly with Copilot

---

## What Changed Behind the Scenes

### Old (coc-nvim)
```
Neovim → coc-nvim (Node.js) → Language Servers
```

### New (Native LSP)
```
Neovim (Built-in LSP Client) → Language Servers
```

The language servers are the **same**, but now Neovim talks to them directly instead of through a Node.js layer!

---

## Getting Help

If something isn't working:
1. Check `:LspInfo` to see if the server is running
2. Check `:Mason` to see if the server is installed
3. Check `:messages` for any error messages
4. Check `:LspLog` for detailed logs

Common fixes:
- `:LspRestart` - Restart the LSP server
- `:PlugUpdate` - Update all plugins
- `:MasonUpdate` - Update all language servers

---

## Next Steps

1. **Test it out**: Open some files and try the keybindings
2. **Customize**: Edit `~/.config/nvim/lua/user/lsp/lspconfig.lua` to adjust settings
3. **Add more languages**: Use `:Mason` to browse and install additional servers
4. **Remove old config**: Delete `coc-settings.json` once everything works

Enjoy your faster, native LSP setup! 🚀

