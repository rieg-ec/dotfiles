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

-- Ruby (ruby-lsp)
-- Installed per-ruby with `gem install ruby-lsp`, not Mason: its C extensions
-- are tied to the Ruby ABI, so one shared Mason install breaks across rubies.
-- Not Mason-managed, so mason-lspconfig will not auto-enable it; we enable it
-- explicitly below.
vim.lsp.config('ruby_lsp', {
  root_dir = ruby_root_dir,
  on_attach = ruby_on_attach(function(client, bufnr)
    -- Disable ruby-lsp's formatting (we use RuboCop via conform.nvim instead)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end),
  cmd = { "/Users/rieg/.rbenv/shims/ruby-lsp" },
  init_options = {
    formatter = 'none',
    -- Diagnostics come from the separate rubocop --lsp server below
    linters = {},
  },
})
vim.lsp.enable('ruby_lsp')

-- RuboCop LSP (diagnostics via bundle exec rubocop)
vim.lsp.config('rubocop', {
  root_dir = ruby_root_dir,
  on_attach = ruby_on_attach(function(client, bufnr)
    -- Formatting is handled by conform.nvim via bundled RuboCop CLI
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end),
  cmd = { "/Users/rieg/.rbenv/shims/bundle", "exec", "rubocop", "--lsp" },
  filetypes = { "ruby" },
})
