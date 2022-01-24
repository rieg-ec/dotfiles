-- require'nvim-web-devicons'.setup { default = true; }
-- require'nvim-web-devicons'.get_icons()

require 'user.plugins.alpha'
require 'user.plugins.treesitter'

require('Comment').setup()
require 'user.plugins.gitsigns'

-- vim-move
vim.g.move_map_keys = 0

vim.g.coc_global_extensions = {
   'coc-json', 'coc-pyright', 'coc-tsserver', 'coc-html',
     'coc-vimlsp', 'coc-snippets', 'coc-clangd', 'coc-css',
    'coc-tailwindcss', 'coc-sql', 'coc-sh',
    'coc-yaml', 'coc-docker', 'coc-eslint', 'coc-prettier', 'coc-solargraph'
}

vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeIgnore = { '^__init__.py', '^__pycache__' }

vim.g.NERDTreeGitStatusIndicatorMapCustom = {
  Modified  = '✚',
  Untracked = '✭',
  Renamed   = '➜',
  Deleted   = '✖',
  Dirty     = '✗',
  Ignored   = '☒',
  Clean     = '✔︎',
  Unknown   = '?',
}

vim.g['airline#extensions#tabline#enabled'] = 1
vim.g.airline_section_z = "col:%v"

vim.g.fzf_buffers_jump = 1


vim.cmd([[
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --color=always --smart-case -- '.shellescape(<q-args>), 2,
    \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
]])

-- COC
vim.api.nvim_command([[
  autocmd CursorHold * silent call CocActionAsync('highlight')
]])

