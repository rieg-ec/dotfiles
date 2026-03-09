require('octo').setup({
  use_local_fs = false,
  enable_builtin = true,
  default_remote = { "upstream", "origin" },
  ssh_aliases = {},
  picker = "telescope",
  picker_config = {
    use_emojis = false,
    mappings = {
      open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
      copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
      checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
      merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
    },
  },
  comment_icon = "▎",
  outdated_icon = "󰅒 ",
  resolved_icon = " ",
  reaction_viewer_hint_icon = " ",
  user_icon = " ",
  timeline_marker = "",
  timeline_indent = 2,
  right_bubble_delimiter = "",
  left_bubble_delimiter = "",
  snippet_context_lines = 4,
  gh_cmd = "gh",
  gh_env = {},
  timeout = 5000,
  default_to_projects_v2 = false,
  suppress_missing_scope = {
    projects_v2 = true,
  },
  ui = {
    use_signcolumn = true,
    use_signstatus = true,
  },
  issues = {
    order_by = {
      field = "CREATED_AT",
      direction = "DESC",
    },
  },
  pull_requests = {
    order_by = {
      field = "CREATED_AT",
      direction = "DESC",
    },
    always_select_remote_on_create = false,
  },
  file_panel = {
    size = 10,
    use_icons = true,
  },
})
