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

local function open_in_browser(url)
  local job = vim.fn.jobstart({ 'open', url }, { detach = true })
  if job <= 0 then
    vim.notify('Failed to open URL: ' .. url, vim.log.levels.ERROR)
    return false
  end

  return true
end

local function extract_urls_from_line(line)
  local urls = {}
  local search_start = 1
  while true do
    local s, e = line:find('https?://[%S]+', search_start)
    if not s then break end
    local raw = line:sub(s, e)
    local url = raw:gsub('[>%)%]"\',;]+$', '')
    table.insert(urls, { url = url, s = s, e = s + #url - 1 })
    search_start = e + 1
  end
  return urls
end

_G.open_url_under_cursor = function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  local urls = extract_urls_from_line(line)

  if #urls == 0 then
    vim.notify('No URL found on current line', vim.log.levels.WARN)
    return
  end

  -- Pick URL under cursor, or nearest one on the line
  local best = urls[1]
  local best_dist = math.huge
  for _, entry in ipairs(urls) do
    if col >= entry.s and col <= entry.e then
      best = entry
      break
    end
    local dist = math.min(math.abs(col - entry.s), math.abs(col - entry.e))
    if dist < best_dist then
      best_dist = dist
      best = entry
    end
  end

  open_in_browser(best.url)
end

_G.open_urls_in_selection = function()
  local s_line = vim.fn.line("'<")
  local e_line = vim.fn.line("'>")
  local lines = vim.api.nvim_buf_get_lines(0, s_line - 1, e_line, false)

  local seen = {}
  local unique_urls = {}
  for _, line in ipairs(lines) do
    for _, entry in ipairs(extract_urls_from_line(line)) do
      if not seen[entry.url] then
        seen[entry.url] = true
        table.insert(unique_urls, entry.url)
      end
    end
  end

  if #unique_urls == 0 then
    vim.notify('No URLs found in selection', vim.log.levels.WARN)
    return
  end

  for _, url in ipairs(unique_urls) do
    open_in_browser(url)
  end
  vim.notify('Opened ' .. #unique_urls .. ' URL(s)', vim.log.levels.INFO)
end

local function git_repo_root_for_file(file)
  local dir = vim.fn.fnamemodify(file, ':h')
  local root = vim.trim(vim.fn.system({ 'git', '-C', dir, 'rev-parse', '--show-toplevel' }))
  if vim.v.shell_error ~= 0 or root == '' then
    return nil
  end

  return root
end

local function github_repo_info(repo_root)
  local remote = vim.trim(vim.fn.system({ 'git', '-C', repo_root, 'remote', 'get-url', 'origin' }))
  if vim.v.shell_error ~= 0 or remote == '' then
    return nil
  end

  remote = remote:gsub('%.git$', '')

  local host, path = remote:match('^git@([^:]+):(.+)$')
  if not host then
    host, path = remote:match('^ssh://git@([^/]+)/(.+)$')
  end
  if not host then
    host, path = remote:match('^https?://([^/]+)/(.+)$')
  end
  if not host or not path then
    return nil
  end

  path = path:gsub('^/', '')

  return {
    host = host,
    path = path,
    url = string.format('https://%s/%s', host, path),
  }
end

local function pr_url_for_commit(sha, repo_root)
  local repo = github_repo_info(repo_root)
  if not repo then
    return nil
  end

  local cmd = { 'gh', 'api' }
  if repo.host ~= 'github.com' then
    vim.list_extend(cmd, { '--hostname', repo.host })
  end

  vim.list_extend(cmd, {
    string.format('repos/%s/commits/%s/pulls', repo.path, sha),
    '--jq',
    '.[0].html_url',
  })

  local result = vim.trim(vim.fn.system(cmd))
  if vim.v.shell_error ~= 0 or result == '' or result == 'null' then
    return nil
  end

  return result
end

local function commit_url_for_commit(sha, repo_root)
  local repo = github_repo_info(repo_root)
  if not repo then
    return nil
  end

  return string.format('%s/commit/%s', repo.url, sha)
end

local function github_url_for_commit(sha, repo_root)
  local pr_url = pr_url_for_commit(sha, repo_root)
  if pr_url then
    return pr_url, 'PR'
  end

  local commit_url = commit_url_for_commit(sha, repo_root)
  if commit_url then
    return commit_url, 'commit'
  end

  return nil, nil
end

local function make_git_file_log_entry(opts)
  local entry_display = require('telescope.pickers.entry_display')
  local make_entry = require('telescope.make_entry')

  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 8 },
      { width = 18 },
      { width = 12 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      { entry.value, 'TelescopeResultsIdentifier' },
      entry.author,
      { entry.date, 'TelescopePreviewDate' },
      entry.msg,
    })
  end

  return function(line)
    if line == '' then
      return nil
    end

    local parts = vim.split(line, '\t', { plain = true })
    local sha = parts[1] or ''
    local author = parts[2] or ''
    local date = parts[3] or ''
    local msg = #parts > 3 and table.concat(vim.list_slice(parts, 4), '\t') or ''

    if msg == '' then
      msg = '<empty commit message>'
    end

    return make_entry.set_default_entry_mt({
      value = sha,
      ordinal = table.concat({ sha, author, date, msg }, ' '),
      author = author,
      date = date,
      msg = msg,
      display = make_display,
      current_file = opts.current_file,
    }, opts)
  end
end

-- Git file history commands
vim.api.nvim_create_user_command('GitFileLog', function()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local conf = require('telescope.config').values
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')
  local previewers = require('telescope.previewers')
  local utils = require('telescope.utils')
  local Path = require('plenary.path')
  local current_file = vim.api.nvim_buf_get_name(0)
  local repo_root = git_repo_root_for_file(current_file)

  if current_file == '' then
    vim.notify('Current buffer has no file path', vim.log.levels.WARN)
    return
  end

  if not repo_root then
    vim.notify('Could not determine git repo for current file', vim.log.levels.ERROR)
    return
  end

  local relative_file = Path:new(current_file):make_relative(repo_root)
  local results = vim.fn.systemlist({
    'git',
    '-C', repo_root,
    '--no-pager',
    'log',
    '--pretty=format:%h%x09%an%x09%ad%x09%s',
    '--date=short',
    '--abbrev-commit',
    '--follow',
    '--',
    relative_file,
  })

  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to load git history for current file', vim.log.levels.ERROR)
    return
  end

  local picker_opts = {
    cwd = repo_root,
    current_file = current_file,
  }

  pickers.new(picker_opts, {
    prompt_title = 'Git File Log',
    finder = finders.new_table({
      results = results,
      entry_maker = make_git_file_log_entry({ current_file = current_file }),
    }),
    previewer = {
      previewers.git_commit_diff_to_parent.new(picker_opts),
      previewers.git_commit_diff_to_head.new(picker_opts),
      previewers.git_commit_diff_as_was.new(picker_opts),
      previewers.git_commit_message.new(picker_opts),
    },
    sorter = conf.file_sorter(picker_opts),
    attach_mappings = function(prompt_bufnr, map)
      local function get_buffer_of_orig(selection)
        local value = selection.value .. ':' .. relative_file
        local content = utils.get_os_command_output({ 'git', '-C', repo_root, '--no-pager', 'show', value })

        local bufnr = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
        vim.api.nvim_buf_set_name(bufnr, 'Original')
        return bufnr
      end

      local function vimdiff(selection, command)
        local ft = vim.bo.filetype
        vim.cmd('diffthis')

        local bufnr = get_buffer_of_orig(selection)
        vim.cmd(string.format('%s %s', command, bufnr))
        vim.bo.filetype = ft
        vim.cmd('diffthis')

        vim.api.nvim_create_autocmd('WinClosed', {
          buffer = bufnr,
          nested = true,
          once = true,
          callback = function()
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end,
        })
      end

      actions.select_default:replace(function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        if not entry then
          return
        end

        actions.close(prompt_bufnr)

        local url, kind = github_url_for_commit(entry.value, repo_root)
        if not url then
          vim.notify('Could not determine GitHub URL for ' .. entry.value:sub(1, 7), vim.log.levels.ERROR)
          return
        end

        if open_in_browser(url) then
          vim.notify('Opened ' .. kind .. ': ' .. url)
        end
      end)

      actions.select_vertical:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vimdiff(selection, 'leftabove vert sbuffer')
      end)

      actions.select_horizontal:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vimdiff(selection, 'belowright sbuffer')
      end)

      actions.select_tab:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd('tabedit ' .. current_file)
        vimdiff(selection, 'leftabove vert sbuffer')
      end)

      map('n', ';pr', function()
        local entry = action_state.get_selected_entry()
        if not entry then return end
        local url, kind = github_url_for_commit(entry.value, repo_root)
        if not url then
          vim.notify('Could not determine GitHub URL for ' .. entry.value:sub(1, 7), vim.log.levels.ERROR)
          return
        end

        vim.fn.setreg('+', url)
        vim.notify('Copied ' .. kind .. ' URL: ' .. url)
      end)
      return true
    end,
  }):find()
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
