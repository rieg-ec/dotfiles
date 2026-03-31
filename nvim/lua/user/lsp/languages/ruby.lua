-- Ruby LSP Configurations

local root_markers = { 'Gemfile', '.git', '.rubocop.yml' }

local function ruby_root_dir(bufnr, on_dir)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name:match('^octo://') then
    return
  end

  local root = vim.fs.root(bufnr, root_markers)
  if root then
    on_dir(root)
  end
end

local function ruby_on_attach(setup_fn)
  return function(client, bufnr)
    if setup_fn then
      setup_fn(client, bufnr)
    end
  end
end

-- Ruby (Solargraph)
vim.lsp.config('solargraph', {
  root_dir = ruby_root_dir,
  on_attach = ruby_on_attach(function(client, bufnr)
    -- Disable Solargraph's formatting (we use RuboCop via conform.nvim instead)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end),
  cmd = { "/Users/rieg/.rbenv/shims/solargraph", "stdio" },
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
  root_dir = ruby_root_dir,
  on_attach = ruby_on_attach(function(client, bufnr)
    -- Enable RuboCop's formatting capability
    client.server_capabilities.documentFormattingProvider = true
    client.server_capabilities.documentRangeFormattingProvider = true
  end),
  cmd = { "/Users/rieg/.rbenv/shims/rubocop", "--lsp" },
  filetypes = { "ruby" },
})
