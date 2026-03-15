-- Ruby LSP Configurations

-- Ruby (Solargraph)
vim.lsp.config('solargraph', {
  on_attach = function(client, bufnr)
    -- Disable Solargraph's formatting (we use RuboCop via conform.nvim instead)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  cmd = { "/Users/rieg/.rbenv/shims/solargraph", "stdio" },
  root_markers = { 'Gemfile', '.git', '.rubocop.yml' },
  settings = {
    solargraph = {
      autoformat = false,
      formatting = false,
      diagnostics = true,
      hover = true,
      useBundler = false,
    }
  }
})

-- RuboCop LSP (for proper Ruby linting and formatting with project's .rubocop.yml)
vim.lsp.config('rubocop', {
  on_attach = function(client, bufnr)
    -- Enable RuboCop's formatting capability
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
  end,
  cmd = { "/Users/rieg/.rbenv/shims/rubocop", "--lsp" },
  root_markers = { 'Gemfile', '.git', '.rubocop.yml' },
  filetypes = { "ruby" },
})
