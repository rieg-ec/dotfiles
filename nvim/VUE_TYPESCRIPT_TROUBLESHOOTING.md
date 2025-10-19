# Vue + TypeScript Troubleshooting Guide

## What I Fixed

1. **Enabled Volar** in `lua/user/lsp/mason.lua`
2. **Enhanced Volar configuration** in `lua/user/lsp/lspconfig.lua` with proper TypeScript settings
3. **Added Vue to ts_ls filetypes** - This is CRITICAL! Volar requires `ts_ls` to be attached to Vue files
4. **Removed Vue from HTML/CSS LSP** to avoid conflicts
5. **Added TypeScript-specific settings** for type checking and suggestions

## IMPORTANT: How Volar Works

Volar v2+ uses a **plugin architecture** that requires the TypeScript language server (`ts_ls`) to also be attached to `.vue` files. Without this, you won't get TypeScript support.

The configuration now has:
- `ts_ls` handles: `.js`, `.ts`, `.jsx`, `.tsx`, **and `.vue`**
- `volar` acts as a plugin that enhances `ts_ls` for Vue-specific features

## Steps to Get TypeScript Working in Vue Files

### 1. Restart Neovim
Close and reopen Neovim to load the new configuration.

### 2. Install Volar
Run the following command in Neovim:
```vim
:Mason
```
- Search for "volar" (press `/` then type "volar")
- Press `i` to install it
- Wait for installation to complete
- Press `q` to close Mason

### 3. Verify Volar is Installed
```vim
:MasonInstalled
```
You should see `volar` in the list.

### 4. Open a Vue File
Open the test file:
```vim
:e lsp-test/vue.vue
```

### 5. Check LSP is Attached
```vim
:LspInfo
```
You should see **BOTH** of these attached clients:
- `ts_ls` (TypeScript language server)
- `volar` (Vue language features)
- Possibly `eslint` and `tailwindcss` too

**IMPORTANT**: If you only see `volar` but NOT `ts_ls`, that's why TypeScript isn't working!

### 6. Test TypeScript Features

#### Test Type Checking
In the Vue file, try adding this line in the `<script setup>` section:
```typescript
const wrong: string = 123  // Should show error: Type 'number' is not assignable to type 'string'
```

#### Test Autocomplete
- Type `count.` and you should see suggestions like `value`
- Type `user.` and you should see `name` and `age`

#### Test Type Inference
- Hover over `count` - should show `Ref<number>`
- Hover over `message` - should show `Ref<string>`

## Common Issues & Solutions

### Issue 1: Volar Not Attaching
**Problem**: `:LspInfo` doesn't show volar

**Solutions**:
1. Make sure you're in a project with `package.json`
2. Run `:LspRestart`
3. Check if volar is installed: `:Mason`

### Issue 2: No Type Errors or Suggestions
**Problem**: TypeScript not providing diagnostics

**Solutions**:
1. **Ensure TypeScript is installed in your project**:
   ```bash
   cd /path/to/your/vue/project
   npm install --save-dev typescript
   # or
   yarn add --dev typescript
   ```

2. **Create a `tsconfig.json`** in your Vue project root:
   ```json
   {
     "compilerOptions": {
       "target": "ES2020",
       "module": "ESNext",
       "moduleResolution": "bundler",
       "strict": true,
       "jsx": "preserve",
       "resolveJsonModule": true,
       "isolatedModules": true,
       "esModuleInterop": true,
       "lib": ["ES2020", "DOM", "DOM.Iterable"],
       "skipLibCheck": true
     },
     "include": ["src/**/*.ts", "src/**/*.d.ts", "src/**/*.tsx", "src/**/*.vue"]
   }
   ```

3. **Check Volar can find TypeScript**:
   ```vim
   :lua print(vim.fn.getcwd() .. "/node_modules/typescript/lib")
   ```
   Make sure this path exists in your project.

### Issue 3: Multiple Language Servers Conflicting
**Problem**: Too many LSP servers attaching to `.vue` files

**Solution**: Check `:LspInfo` - you should ONLY see:
- `volar` (for TypeScript/template/style)
- `eslint` (for linting)
- `tailwindcss` (if using Tailwind)

If you see `html` or `cssls` attaching to `.vue` files, they've been removed from the config.

### Issue 4: Volar is Slow
**Solutions**:
1. Use Vue 3 (Volar is optimized for Vue 3)
2. Disable unused features in the config
3. Make sure you have enough RAM (Volar needs ~500MB per project)

### Issue 5: TypeScript SDK Not Found
**Problem**: Volar can't find TypeScript

**Solution**: Update the `tsdk` path in `lua/user/lsp/lspconfig.lua`:
```lua
typescript = {
  tsdk = "/path/to/your/project/node_modules/typescript/lib"
}
```

Or if you have TypeScript globally:
```lua
typescript = {
  tsdk = vim.fn.expand("~/.npm-global/lib/node_modules/typescript/lib")
}
```

## Testing with the Sample File

The `lsp-test/vue.vue` file now includes:
- Type inference examples
- Interface definitions
- Proper Vue 3 Composition API usage
- A commented line that should show an error when uncommented

### What Should Work:
1. Hover over `count` → shows `Ref<number>`
2. Type `count.` → autocomplete shows `value` property
3. Type `user.` → autocomplete shows `name` and `age`
4. Uncomment `const wrong: string = 123` → red squiggle error
5. Press `gd` on `increment` → jumps to function definition
6. Press `K` on any Vue API → shows documentation

## Debugging Commands

```vim
" Check which LSP servers are running
:LspInfo

" Restart all LSP servers
:LspRestart

" Show LSP logs (for debugging)
:LspLog

" Show diagnostics for current file
:lua vim.diagnostic.setloclist()

" Manually trigger completion
<C-Space> (in insert mode)

" Show hover information
K (in normal mode)
```

## Project Requirements for Full TypeScript Support

Your Vue project should have:
```json
// package.json
{
  "devDependencies": {
    "typescript": "^5.0.0",
    "vue": "^3.0.0"
  }
}
```

## If Nothing Works

1. **Complete clean restart**:
   ```vim
   :MasonUninstall volar
   :q
   ```
   Then reopen Neovim and run `:MasonInstall volar`

2. **Check Mason logs**:
   ```vim
   :Mason
   " Press 'g?' to see keybindings
   " Press '4' to see logs
   ```

3. **Enable debug logging** (add to your config temporarily):
   ```lua
   vim.lsp.set_log_level("debug")
   ```
   Then check: `:LspLog`

4. **Verify the LSP server binary exists**:
   ```bash
   ls ~/.local/share/nvim/mason/bin/volar
   # or
   ls ~/.local/share/nvim/mason/packages/volar/
   ```

## Still Having Issues?

Run these diagnostic commands and check the output:
```vim
:checkhealth lsp
:checkhealth mason
:lua =vim.lsp.get_active_clients()
```

The output will show what's not working correctly.

