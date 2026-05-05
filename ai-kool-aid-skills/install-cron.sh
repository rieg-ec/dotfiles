#!/bin/bash
set -euo pipefail

# Installs/updates a personal daily cron job for sync-skills.sh.
# Existing crontab entries are preserved; only the tagged ai-kool-aid skill sync
# entry is replaced.
#
# Usage:
#   /Users/rieg/cs/dotfiles/ai-kool-aid-skills/install-cron.sh
#   /Users/rieg/cs/dotfiles/ai-kool-aid-skills/install-cron.sh --schedule "17 9 * * *"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYNC_SCRIPT="$SCRIPT_DIR/sync-skills.sh"
SCHEDULE="17 9 * * *"
CRON_TAG="# ai-kool-aid personal skills sync"
LOG_DIR="$HOME/Library/Logs/ai-kool-aid"
LOG_FILE="$LOG_DIR/skills-sync.log"

BOLD=$'\033[1m'
DIM=$'\033[2m'
GREEN=$'\033[32m'
BLUE=$'\033[34m'
CYAN=$'\033[36m'
RED=$'\033[31m'
RESET=$'\033[0m'

usage() {
  cat <<USAGE
${BOLD}${BLUE}Install Personal Skills Cron${RESET}

Usage: $0 [options]

Options:
  ${CYAN}--schedule CRON${RESET} Cron schedule ${DIM}(default: "$SCHEDULE")${RESET}
  ${CYAN}-h, --help${RESET}      Show this help

Log file:
  $LOG_FILE
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --schedule)
      SCHEDULE="$2"
      shift 2
      ;;
    --schedule=*)
      SCHEDULE="${1#*=}"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "${RED}Unknown option: $1${RESET}" >&2
      usage
      exit 1
      ;;
  esac
done

mkdir -p "$LOG_DIR"

CRON_LINE="$SCHEDULE '$SYNC_SCRIPT' >> '$LOG_FILE' 2>&1 $CRON_TAG"
TMP_CRON="$(mktemp)"
TMP_NEW="$(mktemp)"
trap 'rm -f "$TMP_CRON" "$TMP_NEW"' EXIT

crontab -l > "$TMP_CRON" 2>/dev/null || true
grep -vF "$CRON_TAG" "$TMP_CRON" > "$TMP_NEW" || true
printf '%s\n' "$CRON_LINE" >> "$TMP_NEW"
crontab "$TMP_NEW"

echo ""
echo "${GREEN}✓${RESET} Installed personal AI Kit skill sync cron"
echo "${DIM}Schedule:${RESET} $SCHEDULE"
echo "${DIM}Script:${RESET}   $SYNC_SCRIPT"
echo "${DIM}Log:${RESET}      $LOG_FILE"
