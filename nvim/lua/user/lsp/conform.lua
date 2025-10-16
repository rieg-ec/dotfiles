-- Formatting with conform.nvim
-- This provides better formatting than LSP built-in formatters

require("conform").setup({
  formatters_by_ft = {
    -- Ruby - use rubocop
    ruby = { "rubocop" },
    
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
      timeout_ms = 1000,  -- Reduced timeout
      lsp_fallback = true,
    }
  end,
  
  -- Customize formatters
  formatters = {
    rubocop = {
      command = "/Users/rieg/.rbenv/shims/rubocop",
      args = { 
        "--autocorrect-all",  -- Format even with errors
        "--format", "quiet",
        "--force-exclusion",  -- Respect .rubocop.yml excludes
        "--stderr",
        "--stdin", "$FILENAME",
      },
    },
    black = {
      command = "/Users/rieg/.pyenv/shims/black",
    },
  },
})

-- Optional: Add a keymap to format manually
vim.keymap.set({ "n", "v" }, "<leader>F", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = "Format file or range (in visual mode)" })

