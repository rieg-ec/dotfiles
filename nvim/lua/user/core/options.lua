
local options = {
	backup = false, -- creates a backup file
	hidden = true, -- move through buffer without saving
	clipboard = 'unnamedplus', -- always use system clipboard for copy/paste
	compatible = false, -- vim.lsp.buf.implementation()<CR>"
	showmatch = true, -- vim.lsp.buf.implementation()<CR>"
	ignorecase = true, -- case insensitive matching
	hlsearch = true, -- hlsearch
	number = true, -- hlsearch
	wildmode = { 'longest', 'list' }, -- get bash-like tab completions
	wrap = false,
  smarttab = true,
	smartindent = true,
	autoindent = true,
	numberwidth = 2,
	showmode = false,
	mouse = "a",
	expandtab = true,
	fileencoding = "utf-8",
	completeopt = { "menuone", "noselect" },
	swapfile = false,
	splitbelow = false, -- force all horizontal splits to go below current window
	splitright = false, -- force all vertical splits to go to the right of current window
	writebackup = false,
	cursorline = false,
	signcolumn = "yes",
	scrolloff = 8,
	sidescrolloff = 8,
  ts = 2,
  sw = 2,
  sts = 2,
}

vim.g.mapleader = ';'
vim.g.lsp_diagnostics_virtual_text_enabled = 1

vim.opt.completeopt:remove({ 'preview' })
vim.cmd "filetype plugin indent on"

vim.opt.whichwrap:append("<")
vim.opt.whichwrap:append(">")
vim.opt.whichwrap:append("[")
vim.opt.whichwrap:append("]")

-- not really sure what the next 2 lines do
-- vim.opt.iskeyword:append("-")
-- vim.opt.iskeyword:append("#")

vim.cmd([[
	autocmd Filetype *.ruby setlocal ts=2 sw=2 sts=2
	autocmd Filetype javascript setlocal ts=2 sw=2
	autocmd Filetype *.html setlocal ts=2 sw=2 sts=2
	autocmd Filetype *.css setlocal ts=2 sw=2 sts=2 
	autocmd Filetype *.json setlocal ts=2 sw=2 sts=2
	autocmd Filetype *.vue setlocal ts=2 sw=2 sts=2
	autocmd Filetype *.cpp setlocal ts=4 sw=4 sts=4
	autocmd Filetype python setlocal ts=4 sw=4 sts=4

  autocmd BufWritePre * :%s/\s\+$//e
  augroup END
]])

for k, v in pairs(options) do
  vim.opt[k] = v
end

local config = {
  virtual_text = true,
  signs = {
    active = signs,
  },
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    -- style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.diagnostic.config(config)

