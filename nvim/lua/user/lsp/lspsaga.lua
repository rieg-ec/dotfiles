-- LSP Saga for better UI (optional but recommended)
require('lspsaga').setup({
  ui = {
    border = 'rounded',
    code_action = '',
  },
  symbol_in_winbar = {
    enable = false,  -- Disable if you don't want breadcrumbs
  },
  lightbulb = {
    enable = false,  -- Disable lightbulb (can be distracting)
  },
})

