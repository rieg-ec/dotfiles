#!/usr/bin/env bash
# cc-fork.sh — Fork a Claude Code session into a new tmux pane
# Usage: cc-fork.sh <split-flag>
#   split-flag: -v (top/bottom, like ") or -h (side by side, like %)

set -euo pipefail

split_flag="${1:--v}"
pane_id="${TMUX_PANE:?TMUX_PANE not set — must be run via tmux run-shell}"
pane_path="$(tmux display-message -t "$pane_id" -p '#{pane_current_path}')"
pane_pid="$(tmux display-message -t "$pane_id" -p '#{pane_pid}')"
pane_num="${pane_id#%}"

# Check if current pane is running Claude Code
claude_pid="$(ps -ax -o pid=,ppid=,comm= | awk -v ppid="$pane_pid" '$2 == ppid && $3 == "claude" {print $1; exit}')"

if [ -n "$claude_pid" ]; then
  # We're in a Claude Code session — get session ID from the hook-written file
  session_id=""
  id_file="/tmp/claude-session-pane-${pane_num}.id"
  if [ -f "$id_file" ]; then
    session_id="$(cat "$id_file")"
  fi

  # Fallback: try to parse --resume from process args
  if [ -z "$session_id" ]; then
    claude_args="$(ps -o args= -p "$claude_pid" 2>/dev/null || true)"
    session_id="$(echo "$claude_args" | grep -oE '\-\-resume[= ]+[0-9a-f-]{36}' | grep -oE '[0-9a-f-]{36}' || true)"
  fi

  if [ -n "$session_id" ]; then
    tmux split-window "$split_flag" -c "$pane_path" "claude --resume $session_id --fork-session"
  else
    tmux split-window "$split_flag" -c "$pane_path" "claude -c --fork-session"
  fi
else
  # Not in a Claude Code session — fork the last session
  tmux split-window "$split_flag" -c "$pane_path" "claude -c --fork-session"
fi
