# Native LSP Quick Start Guide

## 🚀 Installation (3 Steps)

### 1. Run the Install Script
```bash
cd ~/.config/nvim
./install_lsp.sh
```

### 2. Verify in Neovim
```bash
nvim
```

Then run:
```vim
:Mason
```
Wait for all language servers to install (green checkmarks).

### 3. Test It
Open a file (e.g., `test.rb` or `test.js`) and try:
- `K` - hover documentation
- `<Leader>gd` - go to definition
- Type and see completion popup

---

## 📋 Essential Commands

| Command | What It Does |
|---------|--------------|
| `:Mason` | Open language server manager |
| `:LspInfo` | Check LSP status for current file |
| `:LspRestart` | Restart LSP server |
| `:LspLog` | View LSP error logs |
| `:MasonUpdate` | Update all language servers |

---

## ⌨️ Key Bindings Quick Reference

### Navigation
```
K           - Show docs
<Leader>gd  - Go to definition
<Leader>gr  - Show references
<Leader>gi  - Go to implementation
```

### Editing
```
<Leader>rn  - Rename
<Leader>ac  - Code action
<Leader>F   - Format file
```

### Completion (Insert Mode)
```
Tab         - Next item
Shift+Tab   - Previous item
Enter       - Confirm
Ctrl+Space  - Show completion
```

### Diagnostics
```
]d          - Next error/warning
[d          - Previous error/warning
```

---

## 🔧 Troubleshooting

**LSP not working?**
1. `:LspInfo` - check if server is running
2. `:Mason` - check if server is installed
3. `:LspRestart` - restart the server

**Completion not showing?**
- Make sure LSP is attached: `:LspInfo`
- Try manually triggering: `Ctrl+Space`

**Server not installed?**
1. Open `:Mason`
2. Find your server
3. Press `i` to install

---

## 📦 Supported Languages

✅ JavaScript/TypeScript  
✅ React/React Native/JSX  
✅ Vue  
✅ HTML/CSS  
✅ Ruby  
✅ Python  
✅ C/C++  
✅ Go  
✅ Rust  
✅ JSON/YAML  
✅ Lua  

Add more via `:Mason`!

---

## 🎯 What Changed?

**Before:** coc-nvim (Node.js layer)  
**After:** Native Neovim LSP (built-in, faster)

**Same keybindings, better performance!**

---

## 📚 More Help

See `LSP_MIGRATION_GUIDE.md` for detailed documentation.

