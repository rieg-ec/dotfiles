# Dotfiles audit and repair implementation plan

**Goal:** Repair Tree-sitter, audit repository content, group pending changes, and add Go executables to Bash.

**Architecture:** Keep the existing vim-plug and Bash setup. Keep credentials outside tracked files.

**Tech Stack:** Neovim Lua, vim-plug, Bash, Python, Gitleaks.

- [x] Inspect pending changes and repository instructions.
- [x] Reproduce the query error with `vim.treesitter.query.get("regex", "highlights")`.
- [x] Change the Tree-sitter update hook in `nvim/lua/user/plugins/plugins.vim` to `:TSUpdateSync`.
- [x] Replace the Excalidraw bearer token in `opencode.json` with `Bearer {env:EXCALIDRAW_API_KEY}`.
- [x] Scan the working tree and all local Git refs with Gitleaks and review each finding.
- [x] Update affected installed parsers and verify queries in a fresh Neovim process.
- [x] Check shell syntax, Python syntax, JSON, TOML, and Lua configuration.
- [x] Commit sanitized pending changes by feature after the user's audit decision.
- [x] Add `export PATH="$HOME/go/bin:$PATH"` in `bash/.bashrc`.
- [x] Verify Go executable discovery, then commit the Go path separately.

## Commit groups

Split shared files by hunk. Keep each setup link with the executable it installs.

1. `chore(security): document the credential audit and ignore local secrets`
   — `.gitignore`, `docs/security-audit.md`, and this plan.
2. `feat(agents): share Ruler instructions and Basic Memory configuration`
   — `agent-config/`, `claude-settings.json`, root README changes, the memory MCP
   section of `opencode.json`, installer invocation in `setup.sh`, the `memory`
   alias in Bash, and the July implementation plan.
3. `refactor(opencode): remove the retired multi-model review workflow`
   — deleted review agents, plugin, and command; plugin and task-permission
   changes in `opencode.json`.
4. `feat(opencode): configure model defaults and code simplification`
   — model and title-agent settings, new simplifier agent and command.
5. `feat(opencode): add MCP proxies and externalize Excalidraw credentials`
   — remaining MCP settings, both MCP proxy scripts, and the PostHog setup link.
6. `feat(agent-deck): add workspace groups and session launch helpers`
   — `agent-deck-setup.sh`, `bin/adg`, its setup link, and the Bash session helper.
7. `chore(agent-deck): default to Codex and update tool visibility`
   — `agent-deck/config.toml`, upgrade notes, and the August implementation plan.
8. `chore(git): use GitHub CLI credentials and update rebase refs`
   — `.gitconfig`.
9. `chore(bash): refresh toolchain initialization and branch completion`
   — `.bash_profile` and remaining Bash startup/completion changes.
10. `feat(bash): add an AWS account and role picker`
    — `awsl` and AWS completion in `.bashrc`.
11. `feat(media): add video optimization and temporary file sharing`
    — `optimize_video`, `bin/expose_files`, and its setup link.
12. `feat(raycast): format PR media into configurable table layouts`
    — `raycast-scripts/github-pr-media-layout.py`.
13. `feat(nvim): enable Go language server installation`
    — Mason config and Go README changes.
14. `fix(nvim): skip RuboCop formatting for generated Rails schemas`
    — `nvim/lua/user/lsp/conform.lua`.
15. `feat(nvim): add Diffview shortcuts and position the commit log`
    — Diffview config and core keymaps.
16. `feat(nvim): add session-local light and dark theme commands`
    — One Dark config and theme README changes.

Completed commits:

- `4a9ee59`: Tree-sitter parser update hook and repair documentation.
- `fb86ca0`: Go executable PATH entry only.

The user approved committing the sanitized changes. All groups are complete.
