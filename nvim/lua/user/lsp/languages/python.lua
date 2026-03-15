-- Python LSP Configurations

-- Python (Pyright)
vim.lsp.config('pyright', {
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
