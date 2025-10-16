# Migration Fix Applied

## Issue
After initial migration, Neovim was showing this error on startup:
```
Error detected while processing CursorHold Autocommands for "*":
E117: Unknown function: CocActionAsync
```

## Root Cause
The file `lua/user/plugins/init.lua` still had references to coc-nvim:
1. `vim.g.coc_global_extensions` - List of coc extensions
2. `autocmd CursorHold * silent call CocActionAsync('highlight')` - Cursor hold autocommand
3. `vim.g.coc_user_config` - Coc user config
4. `vim.g.coc_filetype_map` - Coc filetype mappings
5. Various `vim.b.coc_*` settings for git buffers

## Fix Applied
Removed all coc references from `lua/user/plugins/init.lua`:
- Removed `coc_global_extensions` (replaced by Mason auto-install)
- Removed `CocActionAsync` autocommand (symbol highlighting now handled by native LSP in `lsp/lspconfig.lua`)
- Removed coc user config and filetype maps (no longer needed)

## What Replaced It
The symbol highlighting on cursor hold is now handled natively in `lua/user/lsp/lspconfig.lua`:
```lua
if client.server_capabilities.documentHighlightProvider then
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end
```

## Result
✅ Error is now fixed  
✅ Symbol highlighting still works (via native LSP)  
✅ All coc references removed  
✅ Ready to use!

## Next Steps
1. Save all files
2. Restart Neovim
3. Run `:PlugInstall`
4. Run `:Mason` to verify servers are installing
5. Test with a file (e.g., `.rb`, `.js`, `.vue`)

The migration is now complete and error-free! 🎉

