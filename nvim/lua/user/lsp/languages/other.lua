-- Other LSP Configurations
-- YAML, Lua

local M = {}

function M.setup(lspconfig, capabilities, on_attach)
  -- YAML
  lspconfig.yamlls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
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
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
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
end

return M





