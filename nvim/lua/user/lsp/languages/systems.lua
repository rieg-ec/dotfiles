-- Systems Programming LSP Configurations
-- Go, Rust

-- Go
vim.lsp.config('gopls', {
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
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
})
