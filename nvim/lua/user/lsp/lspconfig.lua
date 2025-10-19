-- LSP server configurations
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local util = require('lspconfig.util')
local path = util.path

local function path_exists(p)
  local stat = vim.loop.fs_stat(p)
  return stat and stat.type ~= nil
end

local function find_typescript_sdk(root_dir)
  local ts_path = util.search_ancestors(root_dir, function(dir)
    local ts_sdk = path.join(dir, 'node_modules', 'typescript', 'lib')
    if path_exists(ts_sdk) then
      return ts_sdk
    end
  end)
  if ts_path then
    return ts_path
  end

  local fallback_tsdk = vim.fn.expand('~/.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib')
  if path_exists(fallback_tsdk) then
    return fallback_tsdk
  end

  return ''
end

local function find_vue_typescript_plugin(root_dir)
  local plugin_path = util.search_ancestors(root_dir, function(dir)
    local direct = path.join(dir, 'node_modules', '@vue', 'typescript-plugin')
    if path_exists(direct) then
      return direct
    end

    local nested = path.join(dir, 'node_modules', '@vue', 'language-server', 'node_modules', '@vue', 'typescript-plugin')
    if path_exists(nested) then
      return nested
    end
  end)

  if plugin_path then
    return plugin_path
  end

  local mason_nested = vim.fn.expand('~/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin')
  if path_exists(mason_nested) then
    return mason_nested
  end

  local mason_direct = vim.fn.expand('~/.local/share/nvim/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin')
  if path_exists(mason_direct) then
    return mason_direct
  end

  return ''
end

local function ensure_typescript_plugin(new_config, root_dir)
  local plugin_path = find_vue_typescript_plugin(root_dir)
  if plugin_path == '' then
    return
  end

  new_config.init_options = new_config.init_options or {}
  new_config.init_options.plugins = new_config.init_options.plugins or {}

  for _, plugin in ipairs(new_config.init_options.plugins) do
    if plugin.name == '@vue/typescript-plugin' then
      plugin.location = plugin.location or plugin_path
      plugin.languages = plugin.languages or { 'vue' }
      return
    end
  end

  table.insert(new_config.init_options.plugins, {
    name = '@vue/typescript-plugin',
    location = plugin_path,
    languages = { 'vue' },
  })
end

local function ensure_volar_tsdk(new_config, root_dir)
  local tsdk = find_typescript_sdk(root_dir)
  if tsdk == '' then
    return
  end

  new_config.init_options = new_config.init_options or {}
  new_config.init_options.typescript = new_config.init_options.typescript or {}
  new_config.init_options.typescript.tsdk = tsdk
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = cmp_nvim_lsp.default_capabilities()

-- LSP keymaps (only active when LSP is attached)
local on_attach = function(client, bufnr)
  -- Set up LSP keymaps from centralized configuration
  require('user.core.keymaps').setup_lsp(bufnr)

  -- Highlight references of symbol under cursor
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      callback = function()
        -- Safely call document_highlight with error handling
        pcall(vim.lsp.buf.document_highlight)
      end,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      callback = function()
        pcall(vim.lsp.buf.clear_references)
      end,
    })
  end

  -- Format on save is now handled by conform.nvim (see lua/user/lsp/conform.lua)
  -- This provides better formatting with dedicated formatters like rubocop, prettier, etc.
end

-- Configure diagnostic signs
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
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
-- Note: ts_ls also needs to attach to Vue files for Volar to work properly
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_new_config = ensure_typescript_plugin,
  on_attach = function(client, bufnr)
    -- For Vue files, disable some ts_ls features that Volar handles better
    if vim.bo[bufnr].filetype == "vue" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.documentHighlightProvider = false
    end
    on_attach(client, bufnr)
  end,
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
    "vue",  -- Required for Volar to work
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

-- Vue (Volar) - provides TypeScript support in Vue files
-- Note: Volar requires TypeScript to be installed in your project: npm install --save-dev typescript
lspconfig.volar.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- Enable inlay hints if supported
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
    on_attach(client, bufnr)
  end,
  filetypes = { "vue" },
  init_options = {
    vue = {
      hybridMode = false,  -- false = Volar handles .vue files entirely
    },
  },
  settings = {
    vue = {
      inlayHints = {
        inlineHandlerLeading = true,
        missingProps = true,
        destructuredProps = true,
        optionsWrapper = true,
        vBindShorthand = true,
      },
    },
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
      suggest = {
        includeCompletionsForModuleExports = true,
        includeAutomaticOptionalChainCompletions = true,
      },
      preferences = {
        quoteStyle = "single",
      },
    },
  },
  root_dir = require('lspconfig.util').root_pattern(
    'package.json', 
    'vue.config.js', 
    'vite.config.js', 
    'vite.config.ts',
    'nuxt.config.js',
    'nuxt.config.ts'
  ),
})

-- HTML
lspconfig.html.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "html", "handlebars", "htmldjango", "blade" },
})

-- CSS
lspconfig.cssls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "css", "scss", "less" },
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
      -- Enable diagnostics for better error detection
      diagnostics = true,
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
