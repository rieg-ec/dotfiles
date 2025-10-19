-- Mason setup for easy LSP server installation
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  -- Automatically install these language servers
  ensure_installed = {
    -- Web Development
    "ts_ls",               -- TypeScript/JavaScript
    "eslint",              -- ESLint
    "vue-language-server", -- Vue (TypeScript support in Vue files)
    "tailwindcss",         -- Tailwind CSS
    "html",                -- HTML
    "cssls",               -- CSS
    "jsonls",              -- JSON

    -- Ruby
    "solargraph", -- Ruby (code navigation, hover, etc)
    "rubocop",    -- Ruby linting (respects project's .rubocop.yml)

    -- Python
    "pyright", -- Python

    -- C/C++
    "clangd", -- C/C++

    -- Go (uncomment if you write Go code)
    -- "gopls",           -- Go

    -- Rust
    "rust_analyzer", -- Rust

    -- YAML
    "yamlls", -- YAML

    -- Lua (for Neovim config)
    "lua_ls", -- Lua
  },

  -- Auto-install configured servers (with lspconfig)
  automatic_installation = true,
})
