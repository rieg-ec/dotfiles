-- Web Development LSP Configurations
-- JavaScript, TypeScript, Vue, HTML, CSS, Tailwind

-- Get Mason path for vue-language-server
local vue_language_server_path = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'

-- TypeScript plugin configuration for Vue
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
}

local tsserver_filetypes = {
  "javascript",
  "javascriptreact",
  "javascript.jsx",
  "typescript",
  "typescriptreact",
  "typescript.tsx",
  "vue",  -- Required for Vue support
}

-- TypeScript/JavaScript (vtsls)
vim.lsp.config('vtsls', {
  filetypes = tsserver_filetypes,
  settings = {
    vtsls = {
      -- Keep vtsls on its bundled TypeScript for now. Set this to true later
      -- if you want editor diagnostics to use the project's TypeScript version.
      autoUseWorkspaceTsdk = false,
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
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
      tsserver = {
        maxTsServerMemory = 4096,
      },
      preferences = {
        quoteStyle = "single",
      },
    },
  },
})

-- ESLint
vim.lsp.config('eslint', {
  on_attach = function(client, bufnr)
    -- Auto-fix on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        client:request_sync('workspace/executeCommand', {
          command = 'eslint.applyAllFixes',
          arguments = {
            {
              uri = vim.uri_from_bufnr(bufnr),
              version = vim.lsp.util.buf_versions[bufnr],
            },
          },
        }, 2000, bufnr)
      end,
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

-- Vue (vue_ls)
-- Official config: https://github.com/vuejs/language-tools
vim.lsp.config('vue_ls', {
  filetypes = { "vue" },
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
vim.lsp.config('html', {
  filetypes = { "html", "handlebars", "htmldjango", "blade" },
})

-- CSS
vim.lsp.config('cssls', {
  filetypes = { "css", "scss", "less" },
})

-- Tailwind CSS
vim.lsp.config('tailwindcss', {
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
vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})
