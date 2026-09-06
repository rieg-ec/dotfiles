# Unified agent configuration

This directory is the canonical source for personal instructions and portable
skills shared by Claude Code, Codex, OpenCode, and other Ruler targets.

## Layout

```text
.ruler/
├── AGENTS.md
├── ruler.toml
└── skills/
    ├── debug-production/
    │   └── SKILL.md
    └── show-me/
        └── SKILL.md
```

- `.ruler/AGENTS.md` defines the technical explanation style, Basic Memory
  policy, and the exact **"update memory"** workflow.
- `debug-production` investigates Rails issues locally first, uses a local
  sandboxed Rails console when useful, and allows necessary read-only
  production checks during an investigation. Production mutations require approval.
- `show-me` uses concise diagrams, code-shape sketches, and focused HTML files
  to explain technical topics. It comes from
  [`humanlayer/skills`](https://github.com/humanlayer/skills) under the MIT
  license.
- `.ruler/ruler.toml` exposes Basic Memory as `bm mcp --project agent-memory`.

Generated harness files are intentionally ignored. `install.sh` regenerates
them before linking the global instruction and skill locations.

## Install or refresh

```bash
./agent-config/install.sh
```

The installer:

1. Installs Ruler, uv, and Basic Memory when missing.
2. Registers `~/cs/agent-memory` as Basic Memory project `agent-memory`.
3. Runs Ruler for Claude Code, Codex, OpenCode, and `AGENTS.md`.
4. Links global instructions and the canonical skills into each harness.
5. Registers Basic Memory globally with installed Claude Code and Codex CLIs.
6. Disables Claude Code native auto memory while preserving other settings.

The main `setup.sh` invokes this installer.

## Daily use

Tell an agent:

```text
update memory
```

The global instructions require it to review the current session, search for
an existing Basic Memory note, and update or create only durable knowledge.
If Basic Memory is unavailable, the agent must report that instead of falling
back to native harness memory.

Search and inspect memory manually with:

```bash
bm tool search-notes "query" --project agent-memory
bm project ls --name agent-memory
bm status --project agent-memory
```

Memory Markdown lives in the separate local Git repository
`~/cs/agent-memory`. No remote is created automatically; add a private remote
separately if cross-machine synchronization is wanted.

## Apply to a repository

The global Ruler source is linked at `~/.config/ruler`. In a repository without
its own `.ruler/`, run:

```bash
ruler apply --agents agentsmd,claude,codex,opencode --no-gitignore
```

Ruler writes project-local instruction, skill, and MCP adapters. Review the
diff before committing generated project files.
