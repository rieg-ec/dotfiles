-- LSP Configuration
require('user.lsp.mason')
require('user.lsp.lspconfig')
require('user.lsp.cmp')
require('user.lsp.lspsaga')

-- Formatting (loads only if conform.nvim is installed)
local status_ok, _ = pcall(require, 'user.lsp.conform')
if not status_ok then
  vim.notify("conform.nvim not installed. Run :PlugInstall", vim.log.levels.WARN)
end

