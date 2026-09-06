# Personal Agent Instructions

## Git commits

- Do not add commit descriptions (bodies) — subject line only.
- Exception: add a body only when the "why" cannot be understood by looking
  at the code: fixing or changing something done in older commits,
  non-trivial bug fixes, non-trivial decisions.
- Never use a body to restate the diff.

## Code comments

- Add a comment only when the behaviour is really non-trivial to understand
  from the code alone.
- A comment must give the non-trivial reason — a subtle bug, a constraint the
  code cannot show, a change to an old decision. Never describe what the code
  does.

## Technical explanations

- Prefer concise visual forms over long prose.
- Pick the smallest form that makes the point clear: pseudocode, call tree,
  component tree, file tree, Mermaid diagram, type signature, or diff.
- Use the `show-me` skill when the user asks for a visual explanation or says
  **"show me"**.
- Do not run `calldiff`.
- Explain call changes with a call-tree diff. Show unchanged parent calls for
  context. Prefix removed calls with `-` and added calls with `+`.
- Build code-shape views only from code you inspected. State uncertainty and
  missing context.
- State when inspected changes have no call-tree change.
- Use a unified diff when exact source changes matter.

## Long-term memory

Basic Memory project `agent-memory` is the canonical long-term memory store.
Use it for durable knowledge that does not belong in always-on instructions or
a reusable skill.

- Search Basic Memory when a task may depend on earlier decisions, debugging
  findings, preferences, or research.
- Store durable decisions, useful discoveries, failed approaches, and context
  that will matter in a later session.
- Never store credentials, secrets, access tokens, raw customer data, or other
  sensitive production data.
- Prefer updating an existing note over creating a near-duplicate.
- Include dates, provenance, repository names, file paths, and confidence when
  they make a note easier to verify later.
- Promote stable, always-applicable rules to `AGENTS.md`. Promote repeatable
  procedures to a skill.
- Do not write to a harness's native persistent or automatic memory. Basic
  Memory is the only canonical long-term memory store.

### `update memory`

When the user says **"update memory"**, treat that exact phrase as a request to
capture the durable parts of the current work in Basic Memory:

1. Review the conversation and changes made during the session.
2. Search project `agent-memory` for related notes before writing.
3. Update an existing note when possible; otherwise create a concise note in
   an appropriate folder.
4. Record conclusions, rationale, failed approaches, and useful follow-ups.
   Omit transient status and information that is obvious from the repository.
5. Report which notes were created or updated.

If the Basic Memory tools are unavailable, say so. Do not silently fall back to
Claude auto memory, OpenCode state, or another harness-specific store.
