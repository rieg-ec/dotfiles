#!/bin/bash
set -euo pipefail

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Create Pull Request from production to master
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author Ramon Echeverria
# @raycast.description Requires GitHub CLI installed and authenticated. Creates a PR and opens it in the browser.

org="grupalia"
repo="grupalia-rails"

current_date=$(date +"%d/%m/%y")
current_time=$(date +"%H:%M")

# Construct PR title
title="Paso a producción $current_date $current_time"

# Fetch merged PRs from compare
merged_prs=$(
  gh api -X GET "repos/$org/$repo/compare/production...master" --jq '.commits[].commit.message' \
  | grep "^Merge pull request" \
  | grep -oE "#[0-9]+" \
  | xargs -I {} gh pr view {} --repo "$org/$repo" --json number,author --jq '"* #\(.number) by @\(.author.login)"'
)

if [ -z "$merged_prs" ]; then
  merged_prs="No PRs found"
fi

# Create the PR directly with gh and open it
gh pr create \
  --repo "$org/$repo" \
  --base production \
  --head master \
  --title "$title" \
  --body "$merged_prs" \
  --web

