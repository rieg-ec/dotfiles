-- Formatting with conform.nvim
-- This provides better formatting than LSP built-in formatters

require("conform").setup({
  formatters_by_ft = {
    -- Ruby - handled by RuboCop LSP (see languages/ruby.lua)
    -- ruby = {},
    
    -- Python - use black
    python = { "black" },
    
    -- JavaScript/TypeScript/Vue - ESLint handles formatting via LSP
    -- (formatting is done by ESLint LSP on save, see lspconfig.lua)
    -- javascript = {},
    -- javascriptreact = {},
    -- typescript = {},
    -- typescriptreact = {},
    -- vue = {},
    
    -- JSON/YAML - no formatter (let LSP handle it)
    -- json = {},
    -- yaml = {},
    
    -- Go
    go = { "gofmt" },
    
    -- Rust
    rust = { "rustfmt" },
    
    -- C/C++
    c = { "clang_format" },
    cpp = { "clang_format" },
    
    -- Shell
    sh = { "shfmt" },
    bash = { "shfmt" },
    
    -- Lua
    lua = { "stylua" },
  },
  
  -- Format on save
  format_on_save = function(bufnr)
    -- Disable format on save for large files
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > max_filesize then
      return
    end
    
    return {
      timeout_ms = 3000,  -- Increased timeout for RuboCop on Rails files
      lsp_fallback = true,
    }
  end,
  
  -- Customize formatters
  formatters = {
    black = {
      command = "/Users/rieg/.pyenv/shims/black",
    },
  },
})

-- Keymap to format manually with better error handling
vim.keymap.set({ "n", "v" }, "<leader>F", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  
  -- For Ruby files, use LSP formatting (RuboCop LSP)
  if filetype == "ruby" then
    vim.notify("Formatting Ruby file with RuboCop LSP...", vim.log.levels.INFO)
    vim.lsp.buf.format({
      async = false,
      timeout_ms = 5000,  -- Give RuboCop enough time for large Rails files
      bufnr = bufnr,
      filter = function(client)
        -- Use only RuboCop LSP for formatting Ruby files
        return client.name == "rubocop"
      end,
    })
    vim.notify("Formatting completed", vim.log.levels.INFO)
  else
    -- For other files, use conform.nvim
    vim.notify("Formatting " .. filetype .. " file...", vim.log.levels.INFO)
    require("conform").format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 5000,
      bufnr = bufnr,
    }, function(err)
      if err then
        vim.notify("Formatting failed: " .. err, vim.log.levels.ERROR)
      else
        vim.notify("Formatting completed", vim.log.levels.INFO)
      end
    end)
  end
end, { desc = "Format file or range (in visual mode)" })

