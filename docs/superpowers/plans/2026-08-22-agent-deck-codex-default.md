# Agent Deck Codex Default Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Agent Deck launch Codex with `--yolo` by default and limit its tool picker to the harnesses explicitly configured in `agent-deck/config.toml`.

**Architecture:** Keep Codex on Agent Deck's built-in integration so status, resume, and hook behavior remain available. Configure picker visibility with Agent Deck's supported denylist while retaining its unhideable shell entry.

**Tech Stack:** TOML, Agent Deck 1.13.0, Python `tomllib`

---

### Task 1: Configure the Agent Deck tool picker

**Files:**

- Modify: `agent-deck/config.toml`

- [x] **Step 1: Run a failing assertion for the requested configuration**

```bash
python3 -c 'import tomllib; c=tomllib.load(open("agent-deck/config.toml", "rb")); assert c["default_tool"] == "codex"; assert c["codex"] == {"command": "codex", "yolo_mode": True}; assert set(c["ui"]["hidden_tools"]) == {"claude", "gemini", "opencode", "copilot", "crush", "cursor", "hermes", "pi", "aider"}'
```

Expected: FAIL because Codex is not yet the default and the Codex/UI sections do not exist.

- [x] **Step 2: Add the minimal configuration**

```toml
default_tool = "codex"

[codex]
  command = "codex"
  yolo_mode = true

[ui]
  hidden_tools = ["claude", "gemini", "opencode", "copilot", "crush", "cursor", "hermes", "pi", "aider"]
```

Keep the existing `claude-yolo` and `yolocode` custom tool definitions unchanged. Agent Deck always shows `shell`, which cannot be hidden.

- [x] **Step 3: Validate the parsed TOML values**

Run the Python assertion from Step 1 again.

Expected: PASS with exit status 0.

- [x] **Step 4: Verify Agent Deck accepts the live symlinked config**

```bash
/Users/rieg/.local/bin/agent-deck list --json
```

Expected: valid JSON and exit status 0 with no configuration parse warning.
