-- Web Development LSP Configurations
-- JavaScript, TypeScript, Vue, HTML, CSS, Tailwind

local M = {}

function M.setup(lspconfig, capabilities, on_attach)
  -- Get Mason path for vue-language-server
  local vue_language_server_path = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
  
  -- TypeScript plugin configuration for Vue
  local vue_plugin = {
    name = '@vue/typescript-plugin',
    location = vue_language_server_path,
    languages = { 'vue' },
  }

  -- TypeScript/JavaScript (ts_ls)
  lspconfig.ts_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
      plugins = {
        vue_plugin,
      },
    },
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
      "vue",  -- Required for Vue support
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
      workingDirectory = { mode = "auto" },
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

  -- Vue (vue_ls - renamed from volar)
  -- Official config: https://github.com/vuejs/language-tools
  lspconfig.vue_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "vue" },
    init_options = {
      vue = {
        hybridMode = false,
      },
    },
    settings = {
      typescript = {
        inlayHints = {
          enumMemberValues = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
        },
      },
    },
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
end

return M

