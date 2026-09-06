# Dotfiles security audit — 2026-09-06

## Scope and method

Reviewed tracked and untracked repository files, including hidden configuration.
Ran Gitleaks 8.24.3 against the working directory and all local Git refs.
The history scan covered 280 commits before this session's commits.
Reviewed credential-related matches manually. No credentials were tested against remote services.

## Findings

- `opencode.json` contained an uncommitted Excalidraw bearer token. Replaced it
  with `Bearer {env:EXCALIDRAW_API_KEY}`. Rotate the old token. Set the replacement
  outside this repository before enabling the Excalidraw MCP server.
- The sanitized working directory has no Gitleaks findings.
- History produced one false positive in `opencode/plugins/anthropic-auth.ts`
  at commit `63ddf09f82`: a public beta-header identifier, not a credential.
- AWS account IDs, role names, internal project names, local paths, and a Git
  author email remain. These disclose infrastructure and personal metadata;
  they do not provide authentication.
- Python bytecode was untracked. Ignore rules now exclude it and local `.env` files.
- Generated agent configuration remains ignored. Basic Memory data lives in a
  separate repository.

## Limits

This audit covers repository content and locally available history. It does not
cover remote-only refs, GitHub logs, other machines, or external credential stores.
A clean scan cannot prove that all secrets are absent.

## Configuration reference

OpenCode supports environment substitution in config values:
https://opencode.ai/docs/config/#env-vars
