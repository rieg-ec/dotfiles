-- Python LSP Configurations

local M = {}

function M.setup(lspconfig, capabilities, on_attach)
  -- Python (Pyright)
  lspconfig.pyright.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      python = {
        pythonPath = "/Users/rieg/.pyenv/shims/python3",
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        },
      },
    },
  })
end

return M





