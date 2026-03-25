local M = {}

local function get_current_review()
  local ok, reviews = pcall(require, "octo.reviews")
  if not ok then
    return nil
  end

  return reviews.get_current_review()
end

function M.is_review_buffer(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name:match("^octo://.*/review/") then
    return true
  end

  return vim.bo[bufnr].filetype == "octo_panel" and name:match("^OctoChangedFiles%-") ~= nil
end

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Octo" })
end

local function focus_pull_request(review)
  review:focus_commit(review.pull_request.right.commit, review.pull_request.left.commit)
  notify("Reviewing entire PR")
end

local function build_commit_entries(review, commits)
  local entries = {}

  for _, commit in ipairs(commits) do
    local message = ((commit.commit or {}).message) or ""
    local title = vim.split(message, "\n", { plain = true })[1] or commit.sha
    local parent = ((commit.parents or {})[1] or {}).sha or review.pull_request.left.commit

    table.insert(entries, {
      left = parent,
      right = commit.sha,
      title = title,
      message = message,
    })
  end

  return entries
end

local function fetch_commit_entries(review, callback)
  if review._octo_commit_entries then
    callback(review._octo_commit_entries)
    return
  end

  local gh = require("octo.gh")

  gh.api.get {
    "/repos/{repo}/pulls/{number}/commits",
    format = { repo = review.pull_request.repo, number = review.pull_request.number },
    paginate = true,
    opts = {
      cb = gh.create_callback {
        success = function(output)
          local commits = vim.json.decode(output)
          review._octo_commit_entries = build_commit_entries(review, commits)
          callback(review._octo_commit_entries)
        end,
      },
    },
  }
end

local function get_current_commit_index(review, entries)
  local current_left = review.layout.left.commit
  local current_right = review.layout.right.commit

  for idx, entry in ipairs(entries) do
    if entry.left == current_left and entry.right == current_right then
      return idx
    end
  end

  if review:get_level() == "PR" then
    return #entries + 1
  end

  return nil
end

local function set_commit_description(review, message)
  review._octo_commit_message = message
  -- Wait for the layout to re-render, then patch the file panel
  vim.defer_fn(function()
    if not review.layout or not review.layout.file_panel then
      return
    end
    local panel = review.layout.file_panel
    if not panel:buf_loaded() then
      return
    end
    local bufnr = panel.bufid
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Find "Showing changes for:" and replace it + the SHA range below
    local start_idx
    for i, line in ipairs(lines) do
      if line:match("^Showing changes for:") then
        start_idx = i
        break
      end
    end

    if not start_idx then
      return
    end

    -- Replace from "Showing changes for:" to end of buffer
    local replacement = {}
    if message then
      for _, msg_line in ipairs(vim.split(message, "\n", { plain = true })) do
        table.insert(replacement, msg_line)
      end
    end

    vim.bo[bufnr].modifiable = true
    vim.api.nvim_buf_set_lines(bufnr, start_idx - 1, #lines, false, replacement)
    vim.bo[bufnr].modifiable = false
  end, 200)
end

function M.move_commit(direction)
  local review = get_current_review()
  if not review then
    return
  end

  fetch_commit_entries(review, function(entries)
    if #entries == 0 then
      notify("No commits found for this PR", vim.log.levels.WARN)
      return
    end

    local current_idx = get_current_commit_index(review, entries)
    if not current_idx then
      notify("Couldn't determine the current review commit", vim.log.levels.WARN)
      return
    end

    if current_idx == #entries + 1 then
      local target = direction == "next" and entries[1] or entries[#entries]
      review:focus_commit(target.right, target.left)
      set_commit_description(review, target.message)
      notify(string.format("Reviewing %s (%s)", target.title, target.right:sub(1, 7)))
      return
    end

    local offset = direction == "next" and 1 or -1
    local target = entries[current_idx + offset]

    if target then
      review:focus_commit(target.right, target.left)
      set_commit_description(review, target.message)
      notify(string.format("Reviewing %s (%s)", target.title, target.right:sub(1, 7)))
      return
    end

    review._octo_commit_message = nil
    focus_pull_request(review)
  end)
end

function M.next_file()
  require("octo.mappings").select_next_entry()
end

function M.prev_file()
  require("octo.mappings").select_prev_entry()
end

return M
