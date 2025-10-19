-- LSP server configurations
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Add additional capabilities supported by nvim-cmp
local capabilities = cmp_nvim_lsp.default_capabilities()

-- LSP keymaps (only active when LSP is attached)
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Navigation
  vim.keymap.set('n', '<Leader>gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<Leader>gD', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<Leader>gdc', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', '<Leader>gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<Leader>gr', vim.lsp.buf.references, opts)

  -- Documentation
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)

  -- Code actions
  vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<Leader>ac', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<Leader>F', function() vim.lsp.buf.format({ async = true }) end, opts)

  -- Diagnostics
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<Leader>e', function()
    vim.diagnostic.open_float({ focusable = true, focus = true })
  end, opts)

  -- Highlight references of symbol under cursor
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Format on save is now handled by conform.nvim (see lua/user/lsp/conform.lua)
  -- This provides better formatting with dedicated formatters like rubocop, prettier, etc.
end

-- Configure diagnostic signs
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    focusable = true,
  },
})

-- Language server specific configurations

-- TypeScript/JavaScript
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    javascript = {
      format = {
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
        insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = true,
      },
      preferences = {
        quoteStyle = "single",
      },
    },
    typescript = {
      preferences = {
        quoteStyle = "single",
      },
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
})

-- ESLint
lspconfig.eslint.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    -- Auto-fix on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
  settings = {
    workingDirectory = { mode = "auto" }, -- Uses project's eslint config
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "html",
  },
})

-- Vue (Volar) - DISABLED (too slow, use HTML LSP for Vue templates instead)
-- Uncomment if you need full Vue 3 TypeScript support
lspconfig.volar.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "vue" },
  init_options = {
    typescript = {
      tsdk = ""
    },
  },
  root_dir = require('lspconfig.util').root_pattern('package.json', 'vue.config.js'),
})

-- HTML
lspconfig.html.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "html", "handlebars", "htmldjango", "blade", "vue" },
})

-- CSS
lspconfig.cssls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "css", "scss", "less", "vue" },
})

-- Tailwind CSS
lspconfig.tailwindcss.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
  settings = {
    tailwindCSS = {
      classAttributes = { "class", "className", "classList", "ngClass" },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning",
      },
      validate = true,
    },
  },
})

-- JSON
lspconfig.jsonls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

-- Ruby (Solargraph)
lspconfig.solargraph.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Disable Solargraph's formatting (we use RuboCop via conform.nvim instead)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    -- Call the regular on_attach for other LSP features
    on_attach(client, bufnr)
  end,
  cmd = { "/Users/rieg/.rbenv/shims/solargraph", "stdio" },
  -- Detect project root by looking for these files (in order of priority)
  root_dir = require('lspconfig.util').root_pattern('Gemfile', '.git', '.rubocop.yml'),
  settings = {
    solargraph = {
      autoformat = false,
      formatting = false,
      -- DISABLE Solargraph's built-in diagnostics (they don't respect project config properly)
      diagnostics = false,
      hover = true,
      useBundler = false,
    }
  }
})

-- RuboCop LSP (for proper Ruby linting with project's .rubocop.yml)
lspconfig.rubocop.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "/Users/rieg/.rbenv/shims/rubocop", "--lsp" },
  root_dir = require('lspconfig.util').root_pattern('Gemfile', '.git', '.rubocop.yml'),
  filetypes = { "ruby" },
})

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
