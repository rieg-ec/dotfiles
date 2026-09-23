#!/usr/bin/env bash

set -euo pipefail

config_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
memory_root="${AGENT_MEMORY_ROOT:-$HOME/cs/agent-memory}"

install_prerequisites() {
  if ! command -v uv >/dev/null 2>&1; then
    brew install uv
  fi

  if ! command -v ruler >/dev/null 2>&1; then
    npm install -g @intellectronica/ruler
  fi

  if ! command -v bm >/dev/null 2>&1; then
    local python_path="/opt/homebrew/bin/python3.12"
    if [[ ! -x "$python_path" ]]; then
      brew install python@3.12
    fi

    # Basic Memory needs a Python build whose sqlite3 supports loadable
    # extensions. pyenv's default macOS builds commonly omit that support.
    if ! uv tool install --python "$python_path" basic-memory; then
      uv tool uninstall basic-memory >/dev/null 2>&1 || true

      if [[ ! -x "$HOME/.cargo/bin/rustup" ]]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
          | sh -s -- -y --profile minimal
      fi
      "$HOME/.cargo/bin/rustup" update stable
      PATH="$HOME/.cargo/bin:$PATH" \
        uv tool install --python "$python_path" basic-memory
    fi
  fi
}

link_managed_file() {
  local source_path="$1"
  local target_path="$2"

  mkdir -p "$(dirname "$target_path")"

  if [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]; then
    return
  fi

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    local backup_path="${target_path}.before-agent-config"
    if [[ ! -e "$backup_path" && ! -L "$backup_path" ]]; then
      mv "$target_path" "$backup_path"
      printf 'Backed up %s to %s\n' "$target_path" "$backup_path"
    else
      printf 'Refusing to replace %s because backup %s already exists\n' "$target_path" "$backup_path" >&2
      return 1
    fi
  fi

  ln -s "$source_path" "$target_path"
}

disable_claude_auto_memory() {
  local settings_path="$HOME/.claude/settings.json"
  mkdir -p "$(dirname "$settings_path")"

  python3 - "$settings_path" <<'PY'
import json
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
data = json.loads(path.read_text()) if path.exists() else {}
data["autoMemoryEnabled"] = False
path.write_text(json.dumps(data, indent=2) + "\n")
PY
}

register_codex_mcp() {
  local codex_bin=""
  if command -v codex >/dev/null 2>&1; then
    codex_bin="$(command -v codex)"
  elif [[ -x "/Applications/ChatGPT.app/Contents/Resources/codex" ]]; then
    codex_bin="/Applications/ChatGPT.app/Contents/Resources/codex"
  fi

  if [[ -n "$codex_bin" ]] && ! "$codex_bin" mcp get basic-memory >/dev/null 2>&1; then
    "$codex_bin" mcp add basic-memory -- bm mcp --project agent-memory
  fi
}

install_prerequisites

mkdir -p "$memory_root"
if [[ ! -d "$memory_root/.git" ]]; then
  git init "$memory_root"
fi

if ! bm project info agent-memory >/dev/null 2>&1; then
  bm project add agent-memory "$memory_root" --default
else
  bm project default agent-memory
fi

ruler apply \
  --project-root "$config_root" \
  --agents agentsmd,claude,codex,opencode \
  --no-gitignore

link_managed_file "$config_root/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link_managed_file "$config_root/AGENTS.md" "$HOME/.codex/AGENTS.md"
link_managed_file "$config_root/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"
link_managed_file "$config_root/.ruler" "$HOME/.config/ruler"


disable_claude_auto_memory

if command -v claude >/dev/null 2>&1; then
  if ! claude mcp get basic-memory >/dev/null 2>&1; then
    claude mcp add --scope user basic-memory -- bm mcp --project agent-memory
  fi
fi

register_codex_mcp

printf 'Agent configuration installed from %s\n' "$config_root"
printf 'Basic Memory project: agent-memory (%s)\n' "$memory_root"
printf 'Restart active harness sessions to load the new configuration.\n'
