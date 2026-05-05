#!/bin/bash
set -euo pipefail

# Personal local skill sync for the Grupalia dev workspace.
#
# This is intentionally outside the ai-kool-aid repo. It pulls the latest
# ai-kool-aid changes, then symlinks every skill from ai-kool-aid/.claude/skills
# into both .claude/skills and .agents/skills at the workspace root.
#
# Usage:
#   /Users/rieg/cs/dotfiles/ai-kool-aid-skills/sync-skills.sh
#   /Users/rieg/cs/dotfiles/ai-kool-aid-skills/sync-skills.sh --no-pull

AI_KOOL_AID_DIR="${AI_KOOL_AID_DIR:-/Users/rieg/cs/grupalia/dev/ai-kool-aid}"
WORKSPACE_DIR="${GRUPALIA_WORKSPACE_DIR:-/Users/rieg/cs/grupalia/dev}"
SKILLS_DIR="$AI_KOOL_AID_DIR/.claude/skills"
DO_PULL=true

BOLD=$'\033[1m'
DIM=$'\033[2m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
BLUE=$'\033[34m'
CYAN=$'\033[36m'
RED=$'\033[31m'
RESET=$'\033[0m'

usage() {
  cat <<USAGE
${BOLD}${BLUE}Personal AI Kit Skill Sync${RESET}

Usage: $0 [options]

Options:
  ${CYAN}--no-pull${RESET}  Skip git pull and only refresh symlinks
  ${CYAN}-h, --help${RESET} Show this help

Environment overrides:
  AI_KOOL_AID_DIR=$AI_KOOL_AID_DIR
  GRUPALIA_WORKSPACE_DIR=$WORKSPACE_DIR
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --no-pull)
      DO_PULL=false
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

if [ ! -d "$AI_KOOL_AID_DIR" ]; then
  echo "${RED}Error: AI Kit directory not found: $AI_KOOL_AID_DIR${RESET}" >&2
  exit 1
fi

if [ ! -d "$SKILLS_DIR" ]; then
  echo "${RED}Error: skills source not found: $SKILLS_DIR${RESET}" >&2
  exit 1
fi

if [ ! -d "$WORKSPACE_DIR" ]; then
  echo "${RED}Error: workspace directory not found: $WORKSPACE_DIR${RESET}" >&2
  exit 1
fi

AI_KOOL_AID_DIR="$(cd "$AI_KOOL_AID_DIR" && pwd)"
WORKSPACE_DIR="$(cd "$WORKSPACE_DIR" && pwd)"
SKILLS_DIR="$AI_KOOL_AID_DIR/.claude/skills"

all_skills() {
  local skill_dir
  for skill_dir in "$SKILLS_DIR"/*/; do
    [ -d "$skill_dir" ] || continue
    basename "$skill_dir"
  done
}

skill_source_exists() {
  local skill="$1"
  [ -d "$SKILLS_DIR/$skill" ]
}

sync_skill() {
  local target_skills_dir="$1"
  local skill="$2"
  local source="$SKILLS_DIR/$skill"
  local target="$target_skills_dir/$skill"

  if [ -L "$target" ]; then
    local current_target
    current_target="$(readlink "$target")"

    if [ "$current_target" = "$source" ]; then
      echo "    ${GREEN}✓${RESET} $skill ${DIM}(ok)${RESET}"
      return 0
    fi

    rm "$target"
    ln -s "$source" "$target"
    echo "    ${GREEN}✓${RESET} $skill ${DIM}(relinked)${RESET}"
    return 0
  fi

  if [ -e "$target" ]; then
    echo "    ${YELLOW}⚠${RESET} ${YELLOW}$skill${RESET} exists but is not a symlink, left untouched"
    return 1
  fi

  ln -s "$source" "$target"
  echo "    ${GREEN}✓${RESET} $skill ${DIM}(added)${RESET}"
}

cleanup_stale_symlinks() {
  local target_skills_dir="$1"
  local target

  for target in "$target_skills_dir"/*; do
    [ -L "$target" ] || continue

    local skill
    skill="$(basename "$target")"

    if ! skill_source_exists "$skill"; then
      rm "$target"
      echo "    ${YELLOW}−${RESET} $skill ${DIM}(removed stale symlink)${RESET}"
    fi
  done
}

sync_container() {
  local repo_dir="$1"
  local container="$2"
  local target_skills_dir="$repo_dir/$container/skills"
  local skills=("${ALL_SKILLS[@]}")

  mkdir -p "$target_skills_dir"

  echo "  ${CYAN}$container/skills${RESET}"
  cleanup_stale_symlinks "$target_skills_dir"

  local skill
  for skill in "${skills[@]}"; do
    sync_skill "$target_skills_dir" "$skill" || true
  done
}

ensure_local_git_exclude() {
  local repo_dir="$1"
  local exclude_file="$repo_dir/.git/info/exclude"

  [ -f "$exclude_file" ] || return 0

  if ! grep -qxF ".agents/" "$exclude_file"; then
    printf '\n.agents/\n' >> "$exclude_file"
    echo "  ${GREEN}✓${RESET} .agents/ ${DIM}(added to .git/info/exclude)${RESET}"
  fi
}

sync_workspace() {
  echo ""
  echo "${BOLD}${BLUE}$(basename "$WORKSPACE_DIR")${RESET} ${DIM}(${#ALL_SKILLS[@]} skills)${RESET}"
  ensure_local_git_exclude "$WORKSPACE_DIR"
  sync_container "$WORKSPACE_DIR" ".claude"
  sync_container "$WORKSPACE_DIR" ".agents"
}

echo "=== AI Kit skill sync: $(date '+%Y-%m-%d %H:%M:%S %Z') ==="
echo "${DIM}AI Kit:${RESET}    $AI_KOOL_AID_DIR"
echo "${DIM}Workspace:${RESET} $WORKSPACE_DIR"
echo "${DIM}Source:${RESET}    $SKILLS_DIR"

if [ "$DO_PULL" = true ]; then
  echo ""
  echo "${BOLD}${BLUE}Pulling ai-kool-aid${RESET}"
  git -C "$AI_KOOL_AID_DIR" pull --ff-only
fi

ALL_SKILLS=()
while IFS= read -r skill; do
  [ -n "$skill" ] && ALL_SKILLS+=("$skill")
done < <(all_skills)

if [ ${#ALL_SKILLS[@]} -eq 0 ]; then
  echo "${RED}Error: no skills found in $SKILLS_DIR${RESET}" >&2
  exit 1
fi

echo ""
echo "${BOLD}${BLUE}Syncing all skills to workspace root${RESET}"
sync_workspace

echo ""
echo "${GREEN}Done.${RESET} Synced ${#ALL_SKILLS[@]} skills to $WORKSPACE_DIR/.claude and $WORKSPACE_DIR/.agents."
