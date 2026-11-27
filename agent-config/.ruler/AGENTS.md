# Personal Agent Instructions

The words MUST, MUST NOT, SHOULD and MAY have the meaning of RFC 2119.

## Commits

- The subject MUST be a Conventional Commit: `type(scope): summary`, in the
  imperative mood, with no final period. The scope is optional. Types:
  `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`, `build`, `perf`,
  `style`, `revert`.
- A commit MUST NOT have a body, unless the body gives a fact that the diff
  cannot show: the reason for a decision that looks wrong, a change to an
  old decision, or history. A body MUST NOT restate the diff.
- A fix to a commit that is not merged MUST be a fixup, squashed into that
  commit:

  ```bash
  git commit --fixup <sha-of-original-commit>
  git fetch
  GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash origin/main
  ```

  You MUST rebase onto the default branch of the remote after a fetch
  (`origin/main`, or `origin/master` where the repository uses it), never
  onto the local branch. A new commit is correct only when the change is a
  separate step, or when the original commit is on the default branch.
- A pull request SHOULD be small commits, one step each, in an order that a
  reviewer can read. A commit MAY fail to build alone. The pull request MUST
  work.

### One kind of change in each commit

The title is a promise: the diff MUST have what the title says, and nothing
more. If a hunk needs a reason that the title does not give, it MUST go in a
different commit.

- A commit MUST change behaviour or keep it, not the two.
- A commit that keeps behaviour MUST do one thing: change a technique, or
  rename, or move, or remove code that nothing uses. It MUST NOT do two of
  these. `refactor` is its type.
- A removal MUST have its own commit, before the commit that changes the
  technique.
- A commit that changes behaviour MUST change the tests of that behaviour in
  the same commit.
- A commit that keeps behaviour MUST keep the same tests, with the same
  names and the same checks. Compare the list of test names before and
  after it.
- A commit that adds, removes, or weakens a test for a different reason MUST
  say so in its title.
- You MUST NOT add work that the title does not name, even useful work.

```text
Bad:   test(modal): use WebMock in the client specs
       The diff converts the stubs, drops the timeout check, and adds
       three tests.

Good:  test(modal): remove the check of the default timeout
       test(modal): stub HTTP with WebMock           same tests
       test(modal): test the call through KeyBroker  only new tests
```

## Code design

- Be pragmatic. Write code for the callers that exist today.
- Do not add optional parameters, default values, branches, or extension
  points for a caller that does not exist yet. Add them when that caller
  arrives.
- Do not justify a design with "a future caller could need this".

  ```text
  Bad:  submit(lastStepValues?: Partial<FormData>) with a default of {},
        "so a future step without fields can call submit()".
        Both callers pass their values.
  Good: submit(lastStepValues: Partial<FormData>)
  ```

## Comments

The default is no comment. A comment MAY exist only where the code needs a
clarification that the code cannot give.

- A comment MUST NOT narrate. It MUST NOT say what the code does. It MUST
  NOT say again in words what a reader can read in the code, in the data, or
  in a different file.
- Before you write a comment, you MUST try these steps in sequence:
  1. Give the reason a name: a method, a variable, or a constant.
  2. Change the design. Code that needs a comment is possibly too tricky, or
     it uses the wrong abstraction.
- A comment MUST give a reason that stays true while the code exists.
  History MUST go in the commit body: incidents, dates, metrics, rejected
  options, earlier versions, and plans.
- Code that a later change removes MUST NOT have a comment: a fallback, a
  second write, an old name. Its reason is a plan. Put the reason in the
  commit body, and name the change that removes the code. First try a
  sequence of steps that does not need such code.
- A comment MUST NOT refer to what the reader cannot see: the chat, the PR,
  the review, "now", "no longer", "the old approach".
- A comment MUST name the thing that it means ("the rule above", "the Role
  tag"). Write it as you would say it to a teammate: plain words, whole
  sentences, and "we" for our decisions.
- Test each comment: "Does a reader who knows our conventions make a mistake
  without it?" If not, you MUST remove it. A true reason is not sufficient.

```text
Narration:  # Some verifications have no identifier of their own. Their
            # consent has it.
            def identifier
              super || income_bureau_consent.identifier
            end

            The comment says the line again in words. The reader asks why a
            verification can have no identifier. The answer is a plan: the
            column is new, and the next release fills it and removes this
            method. A plan goes in the commit body.

A name:     headers := relayedHeaders(response.Header)
            if p.Credential.Query != "" {
                // A redirect can repeat the query of the request in its
                // Location, and that query holds the secret. So the caller
                // does not get this header.
                delete(headers, "location")
            }

            becomes

            headers := relayedHeaders(response.Header)
            if p.Credential.inQuery() {
                delete(headers, headerThatCanRepeatRequestURL)
            }
```

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
