-- Main LSP Configuration
-- Language-specific configs are in lua/user/lsp/languages/

local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

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

-- Load language-specific configurations
require('user.lsp.languages.web').setup(lspconfig, capabilities, on_attach)
require('user.lsp.languages.ruby').setup(lspconfig, capabilities, on_attach)
require('user.lsp.languages.python').setup(lspconfig, capabilities, on_attach)
require('user.lsp.languages.systems').setup(lspconfig, capabilities, on_attach)
require('user.lsp.languages.other').setup(lspconfig, capabilities, on_attach)
