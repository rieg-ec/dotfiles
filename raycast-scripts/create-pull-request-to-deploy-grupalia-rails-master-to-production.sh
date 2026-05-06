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

# Fetch merged PRs from compare. Supports both regular merge commits:
#   Merge pull request #123 ...
# and squash merge commits:
#   Some PR title (#123)
pr_numbers=$(
  gh api -X GET "repos/$org/$repo/compare/production...master" \
    --jq '.commits[].commit.message
      | split("\n")[0]
      | capture("(?:Merge pull request #|\\(#)(?<number>[0-9]+)")
      | .number'
)

merged_prs=""
while IFS= read -r pr_number; do
  [ -z "$pr_number" ] && continue

  pr_line=$(gh pr view "$pr_number" --repo "$org/$repo" --json number,author --jq '"* #\(.number) by @\(.author.login)"')

  if [ -z "$merged_prs" ]; then
    merged_prs="$pr_line"
  else
    merged_prs="$merged_prs"$'\n'"$pr_line"
  fi
done <<< "$pr_numbers"

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
