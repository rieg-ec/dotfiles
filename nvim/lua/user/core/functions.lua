-- Make the function global
_G.copy_files_to_clipboard = function(selected_files)
    local data = {}
    for _, filepath in ipairs(selected_files) do
        local file_content = vim.fn.readfile(filepath)
        for _, line in ipairs(file_content) do
            table.insert(data, line)
        end
        table.insert(data, "")  -- add a newline after each file
    end
    local clipboard_content = table.concat(data, "\n")
    vim.fn.setreg("+", clipboard_content)

    print("Copied " .. #selected_files .. " file(s) to clipboard")
end

-- Git file history commands
vim.api.nvim_create_user_command('GitFileLog', function()
  require('telescope.builtin').git_bcommits({
    attach_mappings = function(_, map)
      map('n', ';pr', function()
        local entry = require('telescope.actions.state').get_selected_entry()
        if not entry then return end
        local sha = entry.value
        local cmd = string.format(
          'gh api "repos/{owner}/{repo}/commits/%s/pulls" --jq ".[0].html_url" 2>/dev/null',
          sha
        )
        local result = vim.trim(vim.fn.system(cmd))
        if result == '' or result == 'null' then
          vim.notify('No PR found for ' .. sha:sub(1, 7), vim.log.levels.WARN)
        else
          vim.fn.setreg('+', result)
          vim.notify('Copied: ' .. result)
        end
      end)
      return true
    end,
  })
end, { desc = 'Telescope: commit history for current file with diff preview' })

vim.api.nvim_create_user_command('GitFileLogDiff', function()
  vim.cmd('DiffviewFileHistory %')
end, { desc = 'Diffview: commit history for current file with full side-by-side diff' })

-- Open image URL from current line (or buffer) in Preview.app
-- Useful for Octo PR descriptions/comments with <img> tags
local function download_and_preview(url)
  local tmp = vim.fn.tempname() .. '.png'
  vim.notify('Downloading image...', vim.log.levels.INFO)

  -- GitHub user-attachment URLs require auth; use gh token if available
  local curl_args = { 'curl', '-sL', '-o', tmp }
  if url:match('github%.com/') then
    local token = vim.fn.system('gh auth token'):gsub('%s+$', '')
    if token ~= '' then
      table.insert(curl_args, '-H')
      table.insert(curl_args, 'Authorization: token ' .. token)
      table.insert(curl_args, '-H')
      table.insert(curl_args, 'Accept: application/octet-stream')
    end
  end
  table.insert(curl_args, url)

  vim.fn.jobstart(curl_args, {
    on_exit = function(_, code)
      if code == 0 then
        vim.fn.jobstart({ 'open', tmp })
      else
        vim.notify('Failed to download image', vim.log.levels.ERROR)
      end
    end,
  })
end

local function extract_image_url(line)
  return line:match('src="(https?://[^"]+)"')
      or line:match('!%[.-%]%((https?://[^%)]+)%)')
end

_G.open_image_preview = function()
  local current_line = vim.api.nvim_get_current_line()
  local url = extract_image_url(current_line)

  if url then
    download_and_preview(url)
    return
  end

  -- No image on current line — scan entire buffer
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local urls = {}
  for _, line in ipairs(lines) do
    local u = extract_image_url(line)
    if u then table.insert(urls, u) end
  end

  if #urls == 0 then
    vim.notify('No image URLs found in buffer', vim.log.levels.WARN)
  elseif #urls == 1 then
    download_and_preview(urls[1])
  else
    vim.ui.select(urls, { prompt = 'Select image to preview:' }, function(choice)
      if choice then download_and_preview(choice) end
    end)
  end
end

-- Octo thread separators — add visible dividers between review threads
vim.api.nvim_set_hl(0, 'OctoThreadSeparator', { fg = '#565f89' })

_G.octo_add_thread_separators = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local sep_ns = vim.api.nvim_create_namespace('octo_thread_separators')
  vim.api.nvim_buf_clear_namespace(bufnr, sep_ns, 0, -1)

  local thread_ns = vim.api.nvim_get_namespaces()['octo_thread_header_vt']
  if not thread_ns then return end

  local marks = vim.api.nvim_buf_get_extmarks(bufnr, thread_ns, 0, -1, {})
  local sep = string.rep('─', 80)

  for _, mark in ipairs(marks) do
    local line = mark[2]
    if line > 1 then
      vim.api.nvim_buf_set_extmark(bufnr, sep_ns, line, 0, {
        virt_lines_above = true,
        virt_lines = {
          { { '' } },
          { { '  ' .. sep, 'OctoThreadSeparator' } },
          { { '' } },
        },
      })
    end
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'octo',
  callback = function()
    local timer = vim.uv.new_timer()
    timer:start(1000, 1000, vim.schedule_wrap(function()
      if vim.bo.filetype ~= 'octo' then
        timer:stop()
        timer:close()
        return
      end
      octo_add_thread_separators()
    end))
  end,
})

-- Create a Vim function to call the Lua function
vim.cmd([[
function! CopyFilesToClipboard(selected_files)
    call luaeval('_G.copy_files_to_clipboard(_A)', a:selected_files)
endfunction
]])

vim.cmd([[
command! FZFCopy call fzf#run(fzf#wrap({
    \ 'source': 'rg --files',
    \ 'sink*': function('CopyFilesToClipboard'),
    \ 'options': '+m --multi ' .
    \            '--header "Select multiple files with <tab>" ' .
    \            '--preview "bat --style=numbers --color=always {}" ' .
    \            '--preview-window right:50%'
    \ }))
]])
