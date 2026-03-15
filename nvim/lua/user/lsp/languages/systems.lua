-- Systems Programming LSP Configurations
-- C/C++, Go, Rust

-- C/C++ (Clangd)
vim.lsp.config('clangd', {
  cmd = {
    "/opt/homebrew/opt/llvm/bin/clangd",
    "--background-index",
    "--completion-style=detailed",
  },
})

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
