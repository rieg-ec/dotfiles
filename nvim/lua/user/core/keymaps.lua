-- ╭─────────────────────────────────────────────────────────╮
-- │ Centralized Keymaps Configuration                      │
-- │ All keybindings in one organized place                 │
-- ╰─────────────────────────────────────────────────────────╯

local M = {}

-- Helper functions
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ╭─────────────────────────────────────────────────────────╮
-- │ General Mappings                                       │
-- ╰─────────────────────────────────────────────────────────╯

function M.setup_general()
  -- File operations
  map('n', '<Leader>w', ':w<CR>', { desc = 'Save current buffer' })
  map('n', '<Leader>c', ':bp<BAR>bd#<CR>', { silent = true, desc = 'Close current buffer' })

  -- Better deletion (don't yank)
  map({ 'n', 'v' }, 'd', '"_d', { desc = 'Delete without yanking' })
  map('n', 'x', '"_x', { desc = 'Delete char without yanking' })
  map('n', 's', '"_s', { desc = 'Delete and insert without yanking' })
  map('n', '<S-c>', '"_<S-c>', { desc = 'Change to end of line without yanking' })

  -- Quick rename word
  map('n', 'r', 'ciw', { desc = 'Rename word' })

  -- Swap { and }
  map({ 'n', 'v' }, '{', '}', { desc = 'Jump to next paragraph' })
  map({ 'n', 'v' }, '}', '{', { desc = 'Jump to previous paragraph' })

  -- Better scrolling
  map('n', '<C-j>', '100<C-d>', { desc = 'Scroll down' })
  map('n', '<C-k>', '100<C-u>', { desc = 'Scroll up' })

  -- Line navigation
  map('n', '<S-b>', '^', { desc = 'Go to beginning of line' })
  map('n', '<S-e>', '$', { desc = 'Go to end of line' })
  map('v', '<S-b>', '^', { desc = 'Go to beginning of line' })
  map('v', '<S-e>', '$h', { desc = 'Go to end of line' })
  map('i', '<C-e>', '<Esc>A', { desc = 'Go to end of line in insert mode' })
  map('i', '<C-a>', '<Esc>I', { desc = 'Go to beginning of line in insert mode' })

  -- Search in buffer
  map('n', '<Leader>/', ':BLines<CR>', { desc = 'Search lines in buffer' })

  -- Paste in insert mode
  map('i', '<C-v>', '<Left><C-o>p', { desc = 'Paste in insert mode' })

  -- Move lines
  map('i', '<C-Down>', '<Esc>:m .+1<CR>gi', { desc = 'Move line down' })
  map('i', '<C-Up>', '<Esc>:m .-2<CR>gi', { desc = 'Move line up' })
  map('v', '<C-j>', '<Plug>MoveBlockDown', { desc = 'Move block down' })
  map('v', '<C-k>', '<Plug>MoveBlockUp', { desc = 'Move block up' })

  -- Buffer navigation
  map('n', '<Tab>', ':bn<CR>', { desc = 'Next buffer' })
  map('n', '<S-Tab>', ':bp<CR>', { desc = 'Previous buffer' })

  -- Window management
  map('n', '<Leader>z', '<C-w>m', { desc = 'Zoom window' })

  -- Tab navigation
  map('n', 'gt', ':tabnext<CR>', { desc = 'Next tab' })
  map('n', 'gT', ':tabprevious<CR>', { desc = 'Previous tab' })

  -- Go to file
  map('n', '<Leader>gf', 'gf<CR>', { desc = 'Go to file under cursor' })

  -- Indentation
  map('v', '<Tab>', '>gv', { desc = 'Indent selection' })
  map('v', '<S-Tab>', '<gv', { desc = 'Outdent selection' })

  -- Split navigation
  map('n', '<C-h>', '<C-w>h', { desc = 'Navigate to left split' })
  map('n', '<C-l>', '<C-w>l', { desc = 'Navigate to right split' })

  -- Resize splits
  map('n', '<A-Left>', '<C-w><', { desc = 'Decrease split width' })
  map('n', '<A-Right>', '<C-w>>', { desc = 'Increase split width' })
  map('n', '<M-Down>', ':resize +1<CR>', { desc = 'Increase split height' })
  map('n', '<M-Up>', ':resize -1<CR>', { desc = 'Decrease split height' })

  -- Disable highlight when entering insert mode
  map('n', 'i', ':noh<CR>i', { desc = 'Clear highlight and insert' })
  map('n', 'a', ':noh<CR>a', { desc = 'Clear highlight and append' })

  -- Highlight word/selection with Enter
  vim.cmd([[
    xnoremap <silent> <cr> "*y:silent! let searchTerm = '\V'.substitute(escape(@*, '\/'), "\n", '\\n', "g") <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
    nnoremap <silent> <cr> :let searchTerm = '\v<'.expand("<cword>").'>' <bar> let @/ = searchTerm <bar> echo '/'.@/ <bar> call histadd("search", searchTerm) <bar> set hls<cr>
  ]])

  -- Replace highlighted text
  map('n', '<Leader>f', ':%s///gc<Left><Left><Left><Left>', { desc = 'Replace highlighted text' })

  -- Copy full path of current file
  map('n', '<Leader>yp', function()
    local path = vim.fn.expand('%:p')
    vim.fn.setreg('+', path)
    print('Copied: ' .. path)
  end, { desc = 'Copy full path of current file' })

  -- Git navigation (for git-diff)
  map('n', ']c', ':lua get_next_commit("next")<CR>', { desc = 'Next commit' })
  map('n', '[c', ':lua get_next_commit("prev")<CR>', { desc = 'Previous commit' })
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ Plugin Mappings                                        │
-- ╰─────────────────────────────────────────────────────────╯

function M.setup_plugins()
  -- NERDTree
  map('n', '<C-t>', ':NERDTreeToggle<CR>', { desc = 'Toggle NERDTree' })
  map('n', '<C-f>', ':NERDTreeFind<CR>', { desc = 'Find in NERDTree' })

  -- FZF
  map('n', 'ff', '<cmd>Files<CR>', { desc = 'Find files' })
  map('n', 'fg', '<cmd>Rg<CR>', { desc = 'Grep files' })

  -- Copilot
  vim.g.UltiSnipsExpandTrigger = '<nop>'
  vim.g.copilot_no_tab_map = true
  vim.cmd([[
    imap <C-n> <Plug>(copilot-next)
    imap <C-p> <Plug>(copilot-previous)
    imap <silent><script><expr> <C-y> copilot#Accept("\<CR>")
  ]])
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ Diagnostic Mappings (always available)                 │
-- ╰─────────────────────────────────────────────────────────╯

function M.setup_diagnostics()
  -- Navigation
  map('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
  map('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

  -- Show diagnostics
  map('n', '<Leader>e', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = lnum })

    if #diagnostics > 0 then
      -- Show diagnostics on current line
      vim.diagnostic.open_float({
        focusable = true,
        focus = true,
        bufnr = bufnr,
        scope = 'line',
        border = 'rounded',
      })
    else
      -- Check if there are any diagnostics in the entire buffer
      local all_diagnostics = vim.diagnostic.get(bufnr)
      if #all_diagnostics > 0 then
        -- Jump to next diagnostic and show it
        vim.diagnostic.goto_next({ float = { border = 'rounded' } })
      else
        local ft = vim.bo.filetype
        if ft == "ruby" then
          vim.notify("No Ruby diagnostics found. Check if LSP is running.", vim.log.levels.WARN)
          local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
          if #clients > 0 then
            local names = {}
            for _, client in ipairs(clients) do
              table.insert(names, client.name)
            end
            vim.notify("Active LSP clients: " .. table.concat(names, ", "), vim.log.levels.INFO)
          end
        else
          vim.notify("No diagnostics in current buffer", vim.log.levels.INFO)
        end
      end
    end
  end, { desc = 'Show diagnostics on current line or jump to next' })
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ LSP Mappings (only when LSP is attached)              │
-- ╰─────────────────────────────────────────────────────────╯

function M.setup_lsp(bufnr)
  local buf_opts = { noremap = true, silent = true, buffer = bufnr }

  -- Navigation
  map('n', '<Leader>gd', vim.lsp.buf.definition, buf_opts)
  map('n', '<Leader>gD', vim.lsp.buf.type_definition, buf_opts)
  map('n', '<Leader>gdc', vim.lsp.buf.declaration, buf_opts)
  map('n', '<Leader>gi', vim.lsp.buf.implementation, buf_opts)
  map('n', '<Leader>gr', vim.lsp.buf.references, buf_opts)

  -- Documentation
  map('n', 'K', vim.lsp.buf.hover, buf_opts)

  -- Code actions
  map('n', '<Leader>rn', vim.lsp.buf.rename, buf_opts)
  map('n', '<Leader>ac', vim.lsp.buf.code_action, buf_opts)
  -- Formatting is handled by conform.nvim, not LSP
  -- map('n', '<Leader>F', function() vim.lsp.buf.format({ async = true }) end, buf_opts)
end

-- ╭─────────────────────────────────────────────────────────╮
-- │ Initialize all keymaps                                 │
-- ╰─────────────────────────────────────────────────────────╯

function M.init()
  M.setup_general()
  M.setup_plugins()
  M.setup_diagnostics()

  -- LSP keymaps are set up via the on_attach function
  -- in lspconfig.lua
end

return M
