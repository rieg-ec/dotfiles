# Quick Fix Summary: TypeScript in Vue Files

## The Problem
You weren't getting TypeScript suggestions or type errors in Vue files.

## The Root Cause
Volar v2+ requires **both** `volar` AND `ts_ls` (TypeScript language server) to be attached to `.vue` files. Your config only had Volar enabled but `ts_ls` wasn't configured to handle Vue files.

## The Fix
1. Added `"vue"` to the `ts_ls` filetypes in `lua/user/lsp/lspconfig.lua`
2. Disabled conflicting `ts_ls` features for Vue files (Volar handles these better)
3. Added error handling to prevent "document not opened" errors

```lua
lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    -- For Vue files, let Volar handle formatting and highlighting
    if vim.bo[bufnr].filetype == "vue" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentHighlightProvider = false
    end
    on_attach(client, bufnr)
  end,
  filetypes = {
    "javascript",
    "typescript",
    "vue",  -- This line was missing!
  },
})
```

## How to Apply the Fix

### 1. Restart Neovim
```bash
# Close Neovim completely and reopen
```

### 2. Ensure Both LSP Servers Are Installed
```vim
:Mason
```
Check that both are installed:
- ✓ `ts_ls` (TypeScript/JavaScript)
- ✓ `volar` (Vue)

### 3. Open a Vue File
```vim
:e lsp-test/vue.vue
```

### 4. Verify BOTH LSP Servers Are Attached
```vim
:LspInfo
```

**You MUST see BOTH:**
- `ts_ls` 
- `volar`

If you only see one, that's the problem!

### 5. Test It Works
Try this in the `<script setup>` section:
```typescript
const wrong: string = 123  // Should show red error
```

Or type:
```typescript
const user = { name: 'test' }
user.  // Should show autocomplete for 'name'
```

## If It Still Doesn't Work

### Check Your Project Has TypeScript
```bash
cd /path/to/your/vue/project
ls node_modules/typescript
```

If it doesn't exist:
```bash
npm install --save-dev typescript
# or
yarn add --dev typescript
```

### Restart the LSP
```vim
:LspRestart
```

### Check for Errors
```vim
:LspLog
```
Look for any errors related to Volar or ts_ls.

## Quick Test Script
Run this in your Vue project directory:
```bash
cd /path/to/your/vue/project
~/cs/dotfiles/nvim/check_vue_setup.sh
```

This will check if:
- TypeScript is installed
- Vue is installed
- tsconfig.json exists
- Volar is installed in Mason

## Architecture

### How Volar v2 Works:
```
┌─────────────┐
│  .vue file  │
└──────┬──────┘
       │
       ├──> ts_ls (TypeScript language server)
       │    ├─ Type checking
       │    ├─ Autocomplete
       │    └─ Diagnostics
       │
       └──> volar (Vue language features)
            ├─ Template parsing
            ├─ Component props
            ├─ Vue-specific features
            └─ Integrates with ts_ls
```

Both must be present for TypeScript to work in Vue!

## Files Changed
1. `lua/user/lsp/mason.lua` - Enabled Volar installation
2. `lua/user/lsp/lspconfig.lua` - Added Vue to ts_ls filetypes + enhanced Volar config
3. `lsp-test/vue.vue` - Updated with better test cases

## Need More Help?
Read the full troubleshooting guide:
```vim
:e ~/cs/dotfiles/nvim/VUE_TYPESCRIPT_TROUBLESHOOTING.md
```

