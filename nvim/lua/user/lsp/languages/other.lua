-- Other LSP Configurations
-- YAML, Lua

-- YAML
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      format = {
        enable = true,
        singleQuote = false,
      },
    },
  },
})

-- Lua (for Neovim configuration)
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
