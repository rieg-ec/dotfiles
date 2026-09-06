# Unified Agent Instructions and Memory Implementation Plan

> **For agentic workers:** Implement this plan task-by-task and verify every generated configuration before using it.

**Goal:** Create a Ruler-managed global instruction and skill source, connect Claude Code and OpenCode to a private Basic Memory repository, and disable Claude Code's native auto memory.

**Architecture:** `agent-config/.ruler/` is the canonical source for portable instructions, the `debug-production` skill, and the Basic Memory MCP declaration. Ruler generates harness-native project artifacts, while an installer links the global instruction and skill files into each harness. Basic Memory owns durable Markdown in the separate local Git repository `~/cs/agent-memory`.

**Tech Stack:** Ruler, Agent Skills, Basic Memory, MCP, Bash, Claude Code, OpenCode, Git.

---

### Task 1: Create the canonical Ruler source

**Files:**
- Create: `agent-config/.ruler/AGENTS.md`
- Create: `agent-config/.ruler/ruler.toml`
- Create: `agent-config/.ruler/skills/debug-production/SKILL.md`

- [x] Write portable memory rules, including the literal `update memory` workflow.
- [x] Declare Claude Code, Codex, OpenCode, and `AGENTS.md` as Ruler targets.
- [x] Declare `bm mcp --project agent-memory` as the shared MCP server.
- [x] Write the production-debugging workflow with local Rails-first diagnosis and an explicit confirmation gate before any production access.

### Task 2: Add installation and documentation

**Files:**
- Create: `agent-config/install.sh`
- Create: `agent-config/README.md`
- Modify: `README.md`
- Modify: `setup.sh`

- [x] Make installation idempotently generate Ruler outputs and link global instructions and skills.
- [x] Document setup, memory scope, the `update memory` phrase, and Ruler's project-local generation model.
- [x] Wire the agent configuration installer into the main dotfiles setup.

### Task 3: Configure the active harnesses

**Files:**
- Modify: `opencode.json`
- Modify: `claude-settings.json`
- Modify: `~/.claude/settings.json`

- [x] Add the local Basic Memory MCP server to OpenCode without changing existing servers.
- [x] Add `autoMemoryEnabled: false` to both the tracked and active Claude Code settings.
- [x] Register Basic Memory as a user-scoped Claude Code MCP server.

### Task 4: Initialize and validate Basic Memory

**Files:**
- Create: `~/cs/agent-memory/.gitignore`
- Create: `~/cs/agent-memory/README.md`

- [x] Install Ruler, uv, and Basic Memory.
- [x] Initialize `~/cs/agent-memory` as a local Git repository without a remote.
- [x] Register it as Basic Memory project `agent-memory` and make it the default.
- [x] Run Ruler, Basic Memory, JSON, TOML, symlink, and MCP smoke checks.
