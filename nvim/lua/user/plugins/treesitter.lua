require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "phpdoc" },
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "vim", "vue" }  -- Disable for vim and vue files (vue parser is buggy)
  },
  indent = {
    enable = false,  -- Disabled - treesitter indent is buggy, use standard vim indent instead
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}
