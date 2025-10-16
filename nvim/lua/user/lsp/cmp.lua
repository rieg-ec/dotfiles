-- Autocompletion setup with nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  
  mapping = cmp.mapping.preset.insert({
    -- Tab to select next item (matching your coc config)
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    
    -- Shift-Tab to select previous item
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    
    -- Ctrl-j/k to scroll docs (matching your coc config)
    ['<C-j>'] = cmp.mapping.scroll_docs(4),
    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
    
    -- Ctrl-Space to trigger completion
    ['<C-Space>'] = cmp.mapping.complete(),
    
    -- Ctrl-e to abort
    ['<C-e>'] = cmp.mapping.abort(),
    
    -- Enter to confirm (matching your coc config)
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  
  sources = cmp.config.sources({
    { name = 'nvim_lsp', priority = 1000 },
    { name = 'luasnip', priority = 750 },
    { name = 'buffer', priority = 500 },
    { name = 'path', priority = 250 },
  }),
  
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
      
      -- Icons for different completion item kinds
      before = function(entry, vim_item)
        return vim_item
      end
    })
  },
  
  experimental = {
    ghost_text = false, -- Disable ghost text (copilot provides this)
  },
})

-- Use buffer source for `/` (search)
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (commands)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

