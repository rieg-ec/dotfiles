-- Ruby LSP Configurations

local M = {}

function M.setup(lspconfig, capabilities, on_attach)
  -- Ruby (Solargraph)
  lspconfig.solargraph.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- Disable Solargraph's formatting (we use RuboCop via conform.nvim instead)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      on_attach(client, bufnr)
    end,
    cmd = { "/Users/rieg/.rbenv/shims/solargraph", "stdio" },
    root_dir = require('lspconfig.util').root_pattern('Gemfile', '.git', '.rubocop.yml'),
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
  lspconfig.rubocop.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- Enable RuboCop's formatting capability
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentRangeFormattingProvider = true
      on_attach(client, bufnr)
    end,
    cmd = { "/Users/rieg/.rbenv/shims/rubocop", "--lsp" },
    root_dir = require('lspconfig.util').root_pattern('Gemfile', '.git', '.rubocop.yml'),
    filetypes = { "ruby" },
  })
end

return M



