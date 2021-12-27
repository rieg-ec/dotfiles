
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
	smarttab = true, -- get bash-like tab completions
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
	cursorline = true,
	signcolumn = "yes",
	scrolloff = 8,
	sidescrolloff = 8,
  ts = 2,
  sw = 2,
  sts = 2,
}

vim.g.mapleader = ';'

vim.opt.completeopt:remove({ 'preview' })
vim.cmd "filetype plugin indent on"
vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]

vim.cmd([[
	autocmd WinEnter * setlocal cursorline
	autocmd WinLeave * setlocal nocursorline
	autocmd Filetype *.ruby setlocal ts=2 sw=2 sts=2
	autocmd Filetype javascript setlocal ts=2 sw=2
	autocmd Filetype *.html setlocal ts=2 sw=2 sts=2
	autocmd Filetype *.css setlocal ts=2 sw=2 sts=2 
	autocmd Filetype *.json setlocal ts=2 sw=2 sts=2
	autocmd Filetype *.vue setlocal ts=2 sw=2 sts=2
	autocmd Filetype *.cpp setlocal ts=2 sw=2 sts=2
	autocmd Filetype python setlocal ts=4 sw=4 sts=4
	augroup END 
]])

for k, v in pairs(options) do
  vim.opt[k] = v
end
