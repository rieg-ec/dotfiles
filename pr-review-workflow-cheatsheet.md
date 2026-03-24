# PR Review Workflow

Tools: **gh-dash** (TUI dashboard) + **octo.nvim** (nvim PR interface) + **diffview.nvim** (commit/diff viewer)

Run `gh dash` from any terminal. In nvim, `:Cheatsheet` shows all keybindings.
In gh-dash, press `?` for the help menu (all custom keybindings are listed there).

---

## 1. Viewing open PRs across pinned repos

gh-dash opens to the **"Pinned Repos"** tab by default. This shows all open PRs across
grupalia-rails, grupalia-rn, promoters, rn-ui-kit, and ai-kool-aid.

```
gh dash
```

- `j/k` to navigate PRs
- `l/h` or arrow keys to switch between tabs (Pinned Repos / Needs My Review / My PRs / Grupalia Org)
- `p` toggles the preview pane (PR description + checks)
- `r` refreshes the current section, `R` refreshes all
- `/` to search/filter within the current section

The "Grupalia Org" tab shows all open PRs across the entire org (minus dependabot).

---

## 2. Viewing PRs by author within a repo/org

From gh-dash, press `/` to open search, then type GitHub search syntax:

```
# PRs by a specific author in a specific repo
author:jdoe repo:grupalia/grupalia-rails

# PRs by author across the org
author:jdoe org:grupalia

# PRs by author that are review-requested to you
author:jdoe review-requested:@me
```

From nvim (octo.nvim):

```
:Octo pr search
```

This opens a telescope picker. Type to filter by author, title, etc.
You can also use:

```
:Octo pr list grupalia/grupalia-rails author:jdoe
```

---

## 3. Reading PR description, comments, and conversation

**From gh-dash:**
- Select a PR and press `p` to toggle the preview pane (shows description + status)
- Press `e` to expand a truncated description
- Press `O` to open the PR in octo.nvim for full read/write access (opens a new tmux window)

**From octo.nvim:**
- `;op` lists PRs for the current repo, select one to open it
- Or `:Octo pr edit <number>` to open a specific PR
- The PR buffer shows: title, description, labels, checks, and the full conversation thread
- Scroll through the buffer to read all comments
- Comments show inline with the timeline, including review comments on specific code lines

---

## 4. Commit-by-commit review with file navigation

This is a two-step workflow: start from gh-dash, deep-dive in nvim.

**Option A: gh-dash -> diffview (recommended for commit-by-commit)**

1. In gh-dash, select a PR and press `D`. This checks out the PR branch and opens
   diffview in nvim comparing the PR branch against its base. You get a file tree on the
   left and side-by-side diff on the right.

2. In diffview:
   - `]c` / `[c` to jump to the next/previous commit
   - `<Tab>` / `<S-Tab>` to navigate between changed files within a commit
   - `<Leader>b` to toggle the file panel (tree view of all changed files)
   - `<Leader>E` to focus the file panel
   - `L` to open the commit log (shows commit title + description)
   - `gf` to jump to the actual file (pre-PR state) from within the diff
   - `h` / `zo` to collapse/expand folders in the file panel
   - `i` to toggle between tree and list view in the file panel

3. To see the repository tree alongside the diff (the pre-PR state of the codebase):
   - Press `gf` on any file in the diff to open it in a previous tab
   - Or open NERDTree (`<C-t>`) in a split -- it shows the working tree of the checked-out branch

**Option B: gh-dash -> octo.nvim (for description + comments + files overview)**

1. In gh-dash, press `O` to open the PR in octo.nvim
2. In the octo PR buffer:
   - `;oc` to list the PR's commits (select one to view its changes)
   - `;od` to view the PR diff (all changes, not per-commit)
   - The file panel at the bottom shows changed files, navigate with `j/k` and `<CR>`

**Option C: Pure diffview (when you already have the repo open in nvim)**

```vim
" Compare current branch (PR) against main
:DiffviewOpen origin/main...HEAD

" View a specific commit's changes
:DiffviewOpen <commit>^!
```

---

## 5. Leaving comments on code blocks

**From octo.nvim (full review workflow):**

1. Open the PR: `;op` or `:Octo pr edit <number>`
2. Start a review: `;or` (or `:Octo review start`)
3. Navigate to the changed files -- the diff is shown inline
4. Place your cursor on the line(s) you want to comment on
5. In visual mode, select the code block you want to comment on
6. `:Octo comment add` to add a standalone comment, or add a review comment
7. Write your comment in the buffer that opens
8. When done with all comments: `;oR` (or `:Octo review submit`)
   - Choose: approve / request_changes / comment

**Quick single comment (no full review):**

```vim
:Octo comment add
```

This adds a comment at the cursor position.

**From gh-dash:**
- Press `c` on a selected PR to add a general comment (not on specific code)

---

## 6. Filter PRs by GitHub Project

Once the GH Action is tagging PRs with project labels, use gh-dash search:

```
# In gh-dash, press / then type:
project:PROJECT_NAME repo:grupalia/grupalia-rails

# Or filter by label if the action adds labels
label:project-name
```

You can also add a dedicated section in `gh-dash/config.yml`:

```yaml
prSections:
  - title: "Project X"
    filters: >-
      is:open
      project:PROJECT_NAME
      org:grupalia
```

From octo.nvim:

```vim
:Octo pr search
" Then type: project:PROJECT_NAME
```

---

## 7. File commit history

Two commands, pick based on what you need:

**`:GitFileLog`** -- Telescope picker. Fast, filterable. Scroll through commits in the
results list, diff appears in the preview pane on the right. Good for quickly finding
a specific commit or skimming history.

**`:GitFileLogDiff`** -- Diffview UI. Full side-by-side diff. Commit list at the bottom,
diff above. Use `j/k` to navigate commits, `<CR>` to select, `L` to see the commit
message. Better for deep inspection of how a file evolved.

Both commands show history for the current buffer's file.

Other useful git history commands (already available):

```vim
:Git log -p -- %         " fugitive: raw git log for current file
:Git blame               " fugitive: line-by-line blame
:Gitsigns toggle_current_line_blame  " toggle inline blame (already on by default)
```

---

## 8. Seeing commit title and description during review

**In diffview:**
- Press `L` in the file panel or file history panel to open the commit log popup.
  This shows the full commit message (title + description + author + date).

**In octo.nvim:**
- The PR buffer header shows the PR title and full description
- `;oc` (`:Octo pr commits`) lists commits with their titles
- Select a commit to see its full message and changes

**In gh-dash:**
- The preview pane (`p`) shows the PR title and description
- Press `e` to expand a truncated description

---

## 9. gh-dash <-> octo.nvim integration

The tools complement each other. gh-dash is the **dashboard** (quick triage across repos),
octo.nvim is the **deep review tool** (read/write comments, approve, review code).

**gh-dash -> octo.nvim:**
- Press `O` on any PR in gh-dash. This opens a new tmux window with nvim and the PR
  loaded in octo.nvim. You're now in a full nvim session where you can review, comment,
  approve, etc. When you `:q` nvim, you're back in gh-dash.

**gh-dash -> diffview:**
- Press `D` on any PR. This checks out the branch and opens diffview for commit-by-commit
  review. When done, `:DiffviewClose` and quit nvim to return to gh-dash.

**octo.nvim -> diffview:**
- While in an octo PR buffer, you can run `:DiffviewOpen origin/main...HEAD` to open
  diffview for the same PR. This gives you the side-by-side diff view that octo doesn't
  provide natively.

**Typical flow:**

```
gh dash                         # triage: scan PRs across all repos
  -> O                          # open interesting PR in octo.nvim
    -> read description/comments
    -> ;or                      # start review
    -> add comments on code
    -> ;oR                      # submit review
    -> :q                       # back to gh-dash
```

Or for thorough commit-by-commit review:

```
gh dash                         # find the PR
  -> D                          # checkout + open diffview
    -> ]c / [c                  # step through commits
    -> <Tab> / <S-Tab>          # step through files per commit
    -> L                        # read commit message
    -> :DiffviewClose
    -> :Octo pr edit <number>   # switch to octo for commenting
    -> ;or -> comment -> ;oR    # leave review
    -> :q                       # back to gh-dash
```

---

## 10. Cheatsheet reference

**In nvim:** `:Cheatsheet` opens a telescope picker with all keybindings.
Search for `git`, `octo`, `diffview`, `pr` to find relevant entries.

**In gh-dash:** `?` opens the built-in help menu showing all keybindings
including custom ones (open in octo, diffview, etc).

### Quick reference

#### gh-dash
```
j/k                 navigate PRs
l/h                 switch sections/tabs
p                   toggle preview pane
e                   expand description
/                   search (GitHub search syntax)
O                   open PR in octo.nvim (tmux)
D                   checkout + diffview (tmux)
C                   checkout PR locally
d                   view diff (delta pager)
b                   open in browser
c                   comment on PR
v                   approve PR
m                   merge PR
r / R               refresh section / all
?                   help
q                   quit
```

#### octo.nvim
```
;op                 list PRs
;os                 search PRs
;oc                 PR commits
;od                 PR diff
;or                 start review
;oR                 submit review
:Octo pr edit N     open PR #N
:Octo comment add   comment at cursor
:Octo review start  begin review
:Octo review submit submit review
<C-b>               open in browser (telescope)
<C-y>               copy URL (telescope)
<C-o>               checkout PR (telescope)
```

#### diffview
```
]c / [c             next/prev commit
<Tab> / <S-Tab>     next/prev file
<Leader>b           toggle file panel
<Leader>E           focus file panel
L                   open commit log (title + description)
gf                  go to actual file
i                   toggle tree/list view
g<C-x>              cycle layout
g?                  help
:DiffviewClose      close diffview
```

#### git file history
```
:GitFileLog         telescope: file commits + diff preview
:GitFileLogDiff     diffview: file commits + side-by-side diff
:Git blame          fugitive: line blame
:Git log -p -- %    fugitive: raw commit log for file
```
