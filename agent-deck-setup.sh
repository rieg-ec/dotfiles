#!/usr/bin/env bash
# Agent Deck group setup for Grupalia and Dotfiles workspaces
# Run once: bash ~/cs/dotfiles/agent-deck-setup.sh
# Or with yolo OpenCode sessions: AGENT_DECK_OPENCODE_CMD=yolocode bash ~/cs/dotfiles/agent-deck-setup.sh
# Then launch with: agent-deck -g features  or  agent-deck -g product  or  agent-deck -g devresearch  or  agent-deck -g tmp  or  agent-deck -g debug  or  agent-deck -g dotfiles

set -euo pipefail

GRUPALIA_ROOT="$HOME/cs/grupalia/dev"
AGENT_DECK_OPENCODE_CMD="${AGENT_DECK_OPENCODE_CMD:-opencode}"

echo "=== Setting up Features group ==="
agent-deck group create features --default-path "$GRUPALIA_ROOT" 2>/dev/null || echo "  (features group already exists)"

agent-deck add -t "Rails"        -g features -c "$AGENT_DECK_OPENCODE_CMD" "$GRUPALIA_ROOT/grupalia-rails"
agent-deck add -t "Consumer App" -g features -c "$AGENT_DECK_OPENCODE_CMD" "$GRUPALIA_ROOT/grupalia-rn"
agent-deck add -t "Promoters"    -g features -c "$AGENT_DECK_OPENCODE_CMD" "$GRUPALIA_ROOT/promoters"
agent-deck add -t "UI Kit"       -g features -c "$AGENT_DECK_OPENCODE_CMD" "$GRUPALIA_ROOT/rn-ui-kit"
agent-deck add -t "Global"       -g features -c "$AGENT_DECK_OPENCODE_CMD" "$GRUPALIA_ROOT/"

echo ""
echo "=== Setting up Product group ==="
agent-deck group create product --default-path "$GRUPALIA_ROOT" 2>/dev/null || echo "  (product group already exists)"
echo "  (no default product sessions configured yet)"

echo ""
echo "=== Setting up Devresearch group ==="
agent-deck group create devresearch --default-path "$GRUPALIA_ROOT" 2>/dev/null || echo "  (devresearch group already exists)"
echo "  (no default devresearch sessions configured yet)"

echo ""
echo "=== Setting up Tmp group ==="
agent-deck group create tmp --default-path "$GRUPALIA_ROOT" 2>/dev/null || echo "  (tmp group already exists)"
echo "  (no default tmp sessions configured yet)"

echo ""
echo "=== Setting up Debug group ==="
agent-deck group create debug --default-path "$GRUPALIA_ROOT" 2>/dev/null || echo "  (debug group already exists)"
echo "  (no default debug sessions configured yet)"

echo ""
echo "=== Setting up Dotfiles group ==="
agent-deck group create dotfiles --default-path "$HOME/cs/dotfiles" 2>/dev/null || echo "  (dotfiles group already exists)"

agent-deck add -t "Dotfiles" -g dotfiles -c claude "$HOME/cs/dotfiles"

echo ""
echo "Done. Launch with:"
echo "  agent-deck -g features"
echo "  agent-deck -g product"
echo "  agent-deck -g devresearch"
echo "  agent-deck -g tmp"
echo "  agent-deck -g debug"
echo "  agent-deck -g dotfiles"
echo "  agent-deck              # shows all groups"
