require'nvim-web-devicons'.setup {
 -- your personal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- set the light or dark variant manually, instead of relying on `background`
 -- (default to nil)
 variant = "light|dark";
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "שׁ",
    color = "#81e043",
    name = "Log"
  }
 };
 -- same as `override` but specifically for operating system
 -- takes effect when `strict` is true
 override_by_operating_system = {
  ["apple"] = {
    icon = "",
    color = "#A2AAAD",
    cterm_color = "248",
    name = "Apple",
  },
 };
}

require('user.plugins.chatgpt')

require 'user.plugins.onedark'
require 'onedark'.load()
require 'user.plugins.alpha'
require 'user.plugins.treesitter'

require 'Comment'.setup()
require 'user.plugins.gitsigns'

require 'user.plugins.cheatsheet'

require 'user.plugins.mrkdwn'

require 'user.plugins.diffview'

-- require 'user.plugins.gitlinker'

-- vim-move
vim.g.move_map_keys = 0

vim.g.coc_global_extensions = {
  'coc-pyright',  'coc-go', 'coc-tsserver', 'coc-html',
     'coc-vimlsp', 'coc-snippets', 'coc-clangd', 'coc-css',
    'coc-sql', 'coc-sh', 'coc-rust-analyzer',
    'coc-yaml', 'coc-docker', 'coc-eslint', 'coc-prettier',
  'coc-solargraph', '@yaegassy/coc-volar', 'coc-kotlin'
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

  autocmd FileType js UltiSnipsAddFiletypes javascript
  " autocmd FileType jsx UltiSnipsAddFiletypes javascriptreact.javascript.javascript-react.javascript_react
  " autocmd FileType jsx UltiSnipsAddFiletypes typescriptreact.javascript.typescript.javascriptreact.javascript-react.javascript_react
]])

-- COC
vim.api.nvim_command([[
  autocmd CursorHold * silent call CocActionAsync('highlight')
]])

vim.g.coc_user_config = {
  ["tsserver.log"] = "verbose"
}

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead", "BufEnter"}, {
  pattern = {"*.git/*", "fugitive://*", ".git/*"},
  callback = function()
    -- Disable coc
    vim.b.coc_enabled = 0
    -- Also disable specific language servers
    vim.b.coc_suggest_disable = 1
    vim.b.coc_diagnostic_disable = 1
  end
})
