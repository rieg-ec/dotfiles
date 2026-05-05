#!/usr/bin/env bash
# Agent Deck group setup for Grupalia and Dotfiles workspaces
# Run once: bash ~/cs/dotfiles/agent-deck-setup.sh
# Or with yolo OpenCode sessions: AGENT_DECK_OPENCODE_CMD=yolocode bash ~/cs/dotfiles/agent-deck-setup.sh
# Then launch with: agent-deck -g grupalia-dev  or  agent-deck -g grupalia-product  or  agent-deck -g dotfiles

set -euo pipefail

GRUPALIA_ROOT="$HOME/cs/grupalia/dev"
AGENT_DECK_OPENCODE_CMD="${AGENT_DECK_OPENCODE_CMD:-opencode}"

echo "=== Setting up Grupalia Dev group ==="
agent-deck group create grupalia-dev --default-path "$GRUPALIA_ROOT" 2>/dev/null || echo "  (grupalia-dev group already exists)"

agent-deck add -t "Rails"        -g grupalia-dev -c "$AGENT_DECK_OPENCODE_CMD" "$GRUPALIA_ROOT/grupalia-rails"
agent-deck add -t "Consumer App" -g grupalia-dev -c "$AGENT_DECK_OPENCODE_CMD" "$GRUPALIA_ROOT/grupalia-rn"
agent-deck add -t "Promoters"    -g grupalia-dev -c "$AGENT_DECK_OPENCODE_CMD" "$GRUPALIA_ROOT/promoters"
agent-deck add -t "UI Kit"       -g grupalia-dev -c "$AGENT_DECK_OPENCODE_CMD" "$GRUPALIA_ROOT/rn-ui-kit"
agent-deck add -t "Global"       -g grupalia-dev -c "$AGENT_DECK_OPENCODE_CMD" "$GRUPALIA_ROOT/"

echo ""
echo "=== Setting up Grupalia Product group ==="
agent-deck group create grupalia-product --default-path "$GRUPALIA_ROOT" 2>/dev/null || echo "  (grupalia-product group already exists)"
echo "  (no default product sessions configured yet)"

echo ""
echo "=== Setting up Dotfiles group ==="
agent-deck group create dotfiles --default-path "$HOME/cs/dotfiles" 2>/dev/null || echo "  (dotfiles group already exists)"

agent-deck add -t "Dotfiles" -g dotfiles -c claude "$HOME/cs/dotfiles"

echo ""
echo "Done. Launch with:"
echo "  agent-deck -g grupalia-dev"
echo "  agent-deck -g grupalia-product"
echo "  agent-deck -g dotfiles"
echo "  agent-deck              # shows all groups"
