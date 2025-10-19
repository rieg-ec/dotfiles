# Common Vue + TypeScript LSP Errors & Solutions

## Error 1: "Could not find 'ts_ls' lsp client required by 'volar'"

**Cause**: Volar needs `ts_ls` to also attach to Vue files, but `ts_ls` wasn't configured for `.vue` filetype.

**Solution**: Add `"vue"` to `ts_ls` filetypes:
```lua
lspconfig.ts_ls.setup({
  filetypes = {
    "javascript", "typescript", "vue"  -- Add "vue" here
  },
})
```

**Status**: ✅ FIXED in your config

---

## Error 2: "Request textDocument/documentHighlight failed with message: The document should be opened first"

**Cause**: Both `ts_ls` and `volar` trying to provide document highlighting, causing race conditions.

**Solution**: 
1. Disable `ts_ls` document highlighting for Vue files (let Volar handle it)
2. Add error handling with `pcall()`

```lua
lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    if vim.bo[bufnr].filetype == "vue" then
      client.server_capabilities.documentHighlightProvider = false
    end
    on_attach(client, bufnr)
  end,
})
```

**Status**: ✅ FIXED in your config

---

## Error 3: No TypeScript suggestions or diagnostics in Vue files

**Possible Causes**:
1. TypeScript not installed in your project
2. No `tsconfig.json` 
3. Volar can't find TypeScript SDK
4. LSP servers not attached

**Diagnosis**:
```vim
:LspInfo  " Check if both ts_ls and volar are attached
:LspLog   " Check for errors
```

**Solutions**:

### Solution A: Install TypeScript in your project
```bash
cd /path/to/your/vue/project
npm install --save-dev typescript
```

### Solution B: Create tsconfig.json
```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "jsx": "preserve",
    "lib": ["ES2020", "DOM"]
  },
  "include": ["src/**/*.ts", "src/**/*.vue"]
}
```

### Solution C: Verify LSP attachment
```vim
:LspInfo
```
You should see BOTH:
- ts_ls
- volar

If missing, restart LSP:
```vim
:LspRestart
```

---

## Error 4: Multiple conflicting formatters

**Cause**: Multiple LSP servers trying to format the same file.

**Solution**: Disable formatters you don't want:
```lua
on_attach = function(client, bufnr)
  if vim.bo[bufnr].filetype == "vue" then
    client.server_capabilities.documentFormattingProvider = false
  end
end
```

**Status**: ✅ FIXED - ts_ls formatting disabled for Vue files

---

## Error 5: Volar is too slow / high CPU usage

**Possible Causes**:
1. Large project with many files
2. TypeScript checking too many files
3. Insufficient memory

**Solutions**:

### Solution A: Exclude unnecessary files in tsconfig.json
```json
{
  "exclude": ["node_modules", "dist", "build"]
}
```

### Solution B: Disable unused Volar features
```lua
lspconfig.volar.setup({
  settings = {
    vue = {
      inlayHints = {
        -- Disable if you don't need them
        inlineHandlerLeading = false,
        missingProps = false,
      },
    },
  },
})
```

### Solution C: Use hybrid mode (if you have separate TS files)
```lua
init_options = {
  vue = {
    hybridMode = true,  -- Volar only for .vue, ts_ls for .ts
  },
}
```

---

## Error 6: "Cannot find module 'vue'" or import errors

**Cause**: TypeScript can't find Vue types.

**Solution**: Install Vue types:
```bash
npm install --save-dev @types/vue
# or for Vue 3
npm install --save-dev @vue/runtime-core
```

---

## Error 7: Template syntax not highlighted / no autocomplete

**Cause**: Volar not properly installed or not attached.

**Diagnosis**:
```vim
:Mason
```
Check if `volar` is installed (should have ✓)

**Solution**:
```vim
:MasonUninstall volar
:MasonInstall volar
:LspRestart
```

---

## Debugging Checklist

When something isn't working, run through this checklist:

### 1. Check LSP servers are attached
```vim
:LspInfo
```
Expected output for Vue files:
- ✓ ts_ls (attached)
- ✓ volar (attached)

### 2. Check for errors in logs
```vim
:LspLog
```
Look for red ERROR lines

### 3. Verify TypeScript is installed
```bash
ls node_modules/typescript
```

### 4. Check project has proper config
```bash
ls tsconfig.json package.json
```

### 5. Restart everything
```vim
:LspRestart
:e %  " Reload current file
```

### 6. Check Mason installation
```vim
:Mason
:checkhealth mason
```

### 7. Run diagnostic script
```bash
cd /path/to/your/vue/project
~/cs/dotfiles/nvim/check_vue_setup.sh
```

---

## Still Having Issues?

### Get detailed diagnostics:
```vim
:lua vim.lsp.set_log_level("debug")
:LspLog
```

### Check active clients:
```vim
:lua =vim.lsp.get_active_clients()
```

### Verify file type is correct:
```vim
:set filetype?
```
Should show: `filetype=vue`

### Check which LSP servers support your filetype:
```vim
:lua =require('lspconfig').util.available_servers()
```

---

## Quick Reference: What Each LSP Does

For `.vue` files, you should have:

| LSP Server | Purpose | What it provides |
|------------|---------|------------------|
| `ts_ls` | TypeScript analysis | Type checking, inference, diagnostics for `<script>` |
| `volar` | Vue language features | Template parsing, component props, Vue-specific features |
| `eslint` | Linting | Code quality checks, auto-fix |
| `tailwindcss` | CSS utility classes | Tailwind autocomplete (optional) |

**Both `ts_ls` and `volar` MUST be attached for TypeScript to work!**


