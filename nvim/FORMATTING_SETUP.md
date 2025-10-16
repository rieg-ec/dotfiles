# Formatting Setup with conform.nvim

## 🎯 Overview

Your Neovim now uses **conform.nvim** for formatting instead of LSP built-in formatters. This provides better, more reliable formatting.

## ✅ What's Configured

### Auto-format on Save (Enabled)
All these languages will auto-format when you save:

| Language | Formatter |
|----------|-----------|
| Ruby | **RuboCop** ✅ Installed |
| Python | **Black** (needs install) |
| JavaScript/TypeScript | **Prettier** (auto-installed by Mason) |
| React/JSX | **Prettier** |
| Vue | **Prettier** |
| HTML/CSS | **Prettier** |
| JSON/YAML | **Prettier** |
| Go | **gofmt** |
| Rust | **rustfmt** |
| C/C++ | **clang-format** |
| Shell | **shfmt** |
| Lua | **stylua** |

## 🔧 Installation Steps

### 1. Install the Plugin
```vim
:PlugInstall
```

### 2. Install Formatters

Most formatters install automatically, but verify these:

#### Ruby (Already Installed ✅)
```bash
gem install rubocop
```

#### Python (If you use Python)
```bash
pip install black
```

#### JavaScript/TypeScript/Vue/etc
Prettier installs automatically via npm when needed.

## 🎮 Usage

### Automatic
Just save your file - it will auto-format! `:w`

### Manual Formatting
If you disabled auto-format or want to format manually:
```vim
<Leader>F
```

## 🔧 Customization

### Disable Auto-format for a Language
Edit `lua/user/lsp/conform.lua`:

```lua
-- Remove the language from formatters_by_ft
formatters_by_ft = {
  -- ruby = { "rubocop" },  -- Comment out to disable
}
```

### Disable Auto-format Globally (Format Manually Only)
Edit `lua/user/lsp/conform.lua`:

```lua
-- Comment out or remove this section:
-- format_on_save = {
--   timeout_ms = 500,
--   lsp_fallback = true,
-- },
```

## 📝 RuboCop Configuration

Create a `.rubocop.yml` in your project root to customize Ruby formatting:

```yaml
AllCops:
  TargetRubyVersion: 3.0
  NewCops: enable

Style/StringLiterals:
  EnforcedStyle: single_quotes

Layout/LineLength:
  Max: 120
```

## 🐛 Troubleshooting

### Formatter Not Working?
1. Check if the formatter is installed:
   ```bash
   which rubocop
   which black
   which prettier
   ```

2. Check conform status in Neovim:
   ```vim
   :ConformInfo
   ```

3. Check for errors:
   ```vim
   :messages
   ```

### Ruby Formatting Still Buggy?
Make sure RuboCop is in your PATH:
```bash
which rubocop
# Should show: /Users/rieg/.rbenv/shims/rubocop
```

### Format Taking Too Long?
Increase timeout in `conform.lua`:
```lua
format_on_save = {
  timeout_ms = 1000,  -- Increase from 500 to 1000
  lsp_fallback = true,
},
```

## 🎉 Result

- ✅ Ruby files format properly with RuboCop (no more "m" characters!)
- ✅ All your languages auto-format on save
- ✅ Consistent code style across projects
- ✅ Manual format with `<Leader>F` still works

Enjoy your properly formatted code! 🚀

