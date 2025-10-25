-- Systems Programming LSP Configurations
-- C/C++, Go, Rust

local M = {}

function M.setup(lspconfig, capabilities, on_attach)
  -- C/C++ (Clangd)
  lspconfig.clangd.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = {
      "/opt/homebrew/opt/llvm/bin/clangd",
      "--background-index",
      "--completion-style=detailed",
    },
  })

  -- Go
  lspconfig.gopls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  })

  -- Rust
  lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      ['rust-analyzer'] = {
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  })
end

return M

