-- Formatting with conform.nvim
-- This provides better formatting than LSP built-in formatters

local M = {}

-- Track when saving-and-quitting so Ruby formatting runs synchronously
vim.g._conform_quitting = false

local function create_quit_save_cmd(cmd_name, vim_cmd)
  vim.api.nvim_create_user_command(cmd_name, function(opts)
    vim.g._conform_quitting = true
    local bang = opts.bang and "!" or ""
    local ok, err = pcall(vim.cmd, vim_cmd .. bang)
    vim.g._conform_quitting = false
    if not ok then error(err) end
  end, { bang = true })
end

create_quit_save_cmd("Wq", "wq")
create_quit_save_cmd("Wqa", "wqa")
create_quit_save_cmd("X", "x")
create_quit_save_cmd("Xa", "xa")

-- Redirect :wq, :wqa, :x, :xa to our commands that set the quitting flag
vim.cmd([[
  cnoreabbrev <expr> wq  (getcmdtype() == ':' && getcmdline() ==# 'wq')  ? 'Wq'  : 'wq'
  cnoreabbrev <expr> wqa (getcmdtype() == ':' && getcmdline() ==# 'wqa') ? 'Wqa' : 'wqa'
  cnoreabbrev <expr> x   (getcmdtype() == ':' && getcmdline() ==# 'x')   ? 'X'   : 'x'
  cnoreabbrev <expr> xa  (getcmdtype() == ':' && getcmdline() ==# 'xa')  ? 'Xa'  : 'xa'
]])

-- ZZ handler: save-and-quit with synchronous formatting
function M.save_and_quit()
  vim.g._conform_quitting = true
  vim.cmd('x')
  vim.g._conform_quitting = false
end

require("conform").setup({
  formatters_by_ft = {
    -- Ruby - formatted with bundled RuboCop CLI, diagnostics via RuboCop LSP
    ruby = { "rubocop_bundle" },

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

  -- Format on save (synchronous — blocks :w until done)
  format_on_save = function(bufnr)
    local filetype = vim.bo[bufnr].filetype

    -- Ruby: sync only when quitting (so file is formatted before exit)
    if filetype == "ruby" then
      if vim.g._conform_quitting then
        return { timeout_ms = 10000, lsp_format = "never" }
      end
      return -- defer to async format_after_save
    end

    -- Disable format on save for large files
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > max_filesize then
      return
    end

    return {
      timeout_ms = 3000,
      lsp_fallback = true,
    }
  end,

  -- Format after save (async — :w returns instantly, buffer updates when done)
  format_after_save = function(bufnr)
    local filetype = vim.bo[bufnr].filetype

    -- Ruby: async only when NOT quitting (quitting already handled sync above)
    if filetype ~= "ruby" or vim.g._conform_quitting then
      return
    end

    return {
      lsp_format = "never",
    }
  end,

  -- Customize formatters
  formatters = {
    black = {
      command = "/Users/rieg/.pyenv/shims/black",
    },
    rubocop_bundle = {
      command = "/Users/rieg/.rbenv/shims/bundle",
      args = {
        "exec",
        "rubocop",
        "--server",
        "-a",
        "-f",
        "quiet",
        "--stderr",
        "--stdin",
        "$FILENAME",
      },
      cwd = require("conform.util").root_file({ "Gemfile", ".rubocop.yml", ".git" }),
      require_cwd = true,
      stdin = true,
      exit_codes = { 0, 1 },
    },
  },
})

-- Format handler with Ruby/other distinction
function M.format_manually()
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype

  -- For Ruby files, use bundled RuboCop CLI via conform.nvim
  if filetype == "ruby" then
    vim.notify("Formatting Ruby file with bundled RuboCop...", vim.log.levels.INFO)
    require("conform").format({
      async = false,
      timeout_ms = 10000,
      bufnr = bufnr,
      formatters = { "rubocop_bundle" },
      lsp_format = "never",
    }, function(err)
      if err then
        vim.notify("Formatting failed: " .. err, vim.log.levels.ERROR)
      else
        vim.notify("Formatting completed", vim.log.levels.INFO)
      end
    end)
  else
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
end

return M
