-- Main LSP Configuration (vim.lsp.config API - Neovim 0.11+)
-- Language-specific configs are in lua/user/lsp/languages/

local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Set capabilities for all servers
vim.lsp.config('*', {
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

-- LSP keymaps and features (only active when LSP is attached)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    -- Set up LSP keymaps from centralized configuration
    require('user.core.keymaps').setup_lsp(bufnr)

    -- Highlight references of symbol under cursor
    if client and client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group,
        buffer = bufnr,
        callback = function()
          if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentHighlight" }) > 0 then
            vim.lsp.buf.document_highlight()
          end
        end,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = bufnr,
        callback = function()
          pcall(vim.lsp.buf.clear_references)
        end,
      })
    end
  end,
})

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

-- Override :LspRestart/:LspStop after nvim-lspconfig loads (its plugin/ dir
-- runs after init.lua). copilot.vim registers as "GitHub Copilot" which has
-- spaces, making vim.lsp.enable() fail on Neovim 0.11+.
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    local function lsp_client_names(exclude_copilot)
      return function()
        local names = {}
        for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
          if not exclude_copilot or c.name ~= 'GitHub Copilot' then
            table.insert(names, c.name)
          end
        end
        return names
      end
    end

    vim.api.nvim_create_user_command('LspRestart', function(opts)
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local filter = opts.fargs[1]
      for _, client in ipairs(clients) do
        if client.name ~= 'GitHub Copilot' and (not filter or client.name == filter) then
          vim.lsp.enable(client.name, false)
          client:stop()
        end
      end
      local timer = assert(vim.uv.new_timer())
      timer:start(500, 0, function()
        for _, client in ipairs(clients) do
          if client.name ~= 'GitHub Copilot' and (not filter or client.name == filter) then
            vim.schedule_wrap(vim.lsp.enable)(client.name)
          end
        end
      end)
    end, { force = true, nargs = '?', bang = true, complete = lsp_client_names(true),
      desc = 'Restart LSP servers (excluding Copilot)' })

    vim.api.nvim_create_user_command('LspStop', function(opts)
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      local filter = opts.fargs[1]
      for _, client in ipairs(clients) do
        if client.name ~= 'GitHub Copilot' and (not filter or client.name == filter) then
          vim.lsp.enable(client.name, false)
          if opts.bang then client:stop(true) end
        end
      end
    end, { force = true, nargs = '?', bang = true, complete = lsp_client_names(true),
      desc = 'Stop LSP servers (excluding Copilot)' })
  end,
})

-- Load language-specific configurations
require('user.lsp.languages.web')
require('user.lsp.languages.ruby')
require('user.lsp.languages.python')
require('user.lsp.languages.systems')
require('user.lsp.languages.other')
