-- Main LSP Configuration (vim.lsp.config API - Neovim 0.11+)
-- Language-specific configs are in lua/user/lsp/languages/

local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Set capabilities for all servers
vim.lsp.config('*', {
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

-- LSP keymaps and features (only active when LSP is attached)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Set up LSP keymaps from centralized configuration
    require('user.core.keymaps').setup_lsp(bufnr)

    -- Highlight references of symbol under cursor
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        callback = function()
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
  end,
})

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

-- Load language-specific configurations
require('user.lsp.languages.web')
require('user.lsp.languages.ruby')
require('user.lsp.languages.python')
require('user.lsp.languages.systems')
require('user.lsp.languages.other')
