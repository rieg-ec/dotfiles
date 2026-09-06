# Agent Deck 1.5.1 → 1.9.73 — Upgrade Digest

Generated 2026-07-17 from upstream CHANGELOG.md (asheshgoplani/agent-deck), versions 1.5.2–1.9.73.

## PART A — Session status tracking reliability (exhaustive)

### Core status detection (busy / idle / waiting / error classification)
- **1.9.0** — Inotify queue overflow left hook-derived status stale until restart (the v1.8 "flickering red dots"); the status-file watcher now re-walks the hooks dir and atomically swaps in a fresh map on overflow.
- **1.9.0** — Hook file read/parse failures were silently swallowed (UI showed stale status with no trace); all sites now log WARNs, and 8 silent error swallows in the hook handler's status writes were surfaced too.
- **1.9.0** — New `internal/sessionstatus` package unified the duplicated hook→status decision tree that had diverged between CLI and web (e.g. web stuck forever on acknowledged `waiting`, codex freshness windows disagreeing); a new flicker detector WARNs on rapid status oscillation.
- **1.7.82 / 1.8.0** — Web `/api/sessions` reported `error` while the hook file said `waiting` (dropped inotify events left the TUI's in-memory snapshot stale); the web layer now re-applies the hook fast-path status mapping on every read (live fix: waiting count went 0 → 21).
- **1.9.9** — Web event renderer had no `waiting` case in its badge switch, so waiting sessions rendered as red errors.
- **1.9.21** — Manually stopped sessions flipped back out of `StatusStopped` on the next state reload; the stop now persists. **1.9.24** — Status-line counter then also stopped lumping stopped sessions into the active count.
- **1.9.65** — A session that was added but never started was classified `error`; now shows `idle` (a started-then-lost-tmux session still shows error).
- **1.9.66** — Honest Status v2: statuses gain a `substate` (model-unavailable, auth-401, idle-at-empty-prompt) so three failure modes that all looked like a live "running" session are now distinguishable in the TUI and `--json` outputs.
- **1.9.58** — Sessions showing a rendered error banner (`API Error: 401`, `Please run /login`, `socket connection closed`) were classified `waiting` because Claude redraws its prompt below the banner; banner-shaped lines now classify as sticky `error`.
- **1.9.58** — Opt-in shell-session running indicator (`[status] shell_running_indicator`) with staleness guards so a stale pane-info cache can't mislabel a freshly started session.
- **1.9.25** — Remote (SSH) sessions' waiting-status indicator never updated; waiting detection is now wired through the remote codepath.
- **1.9.2** — A session exited with `/q` took 2–3s to show the `X` marker; status is now reconciled synchronously on attach-return, stale hook fast-path state is cleared, and pane caches are refreshed.
- **1.7.70** — Sessions on isolated tmux sockets (`[tmux].socket_name`) were permanently reported as `error` because the liveness cache only queried the default socket (even manual DB fixes got overwritten each poll); non-default-socket sessions now fall through to a socket-aware probe.
- **1.9.47** — Live sessions are no longer marked dead on transient tmux stalls.

### Hooks pipeline and notify-daemon correctness
- **1.9.72** — Status/daemon hardening batch: a foreign `claude -p` child inheriting `AGENTDECK_INSTANCE_ID` could fire hooks under the parent's ID and flip the parent's status (bind rejection now restores pre-event hook fields); transient tmux-inferred flips away from `running` (long tool call, capture failure) are held for one confirming sample before firing a completion event; notify-daemon status probes are time-bounded (6s/instance, 30s/pass) so one hung tmux call can't mute the whole delivery loop; `conductor setup` no longer evicts the live notify-daemon via a macOS launchd cross-domain reload.
- **1.9.58** — A DB row frozen at `running` (missed update, or session created after daemon load) could veto a fresh terminal Stop hook and drop the completion entirely; a non-terminal row can no longer override a fresh terminal hook status.
- **1.9.58** — Done-sentinel detection had drifted from Claude Code's current transcript format, so real completions were missed; detection now matches current formats and won't report a previous turn's sentinel.
- **1.9.53** — A late-arriving stale `SessionEnd` hook could re-bind an already stopped/removed session, causing session-id collisions (wrong pane output, dropped completion notifications, misdelivered input); stale rebinds are now ignored.
- **1.9.43** — The notify-daemon could silently keep running stale code after upgrades (why notification fixes "didn't take"); it now self-recycles and version-checks. Also adds opt-in kernel-exact task-worker completion (exact exit catch instead of poll-inference).
- **1.9.69** — Cursor CLI lifecycle hooks wired for reliable running→waiting transitions; hook event names from all tools are now normalized case-insensitively (camelCase/snake_case/PascalCase all resolve).
- **1.9.46** — Hook handler no longer FATALs on every call when `PROJECT_DIR` is missing; also made post-send verification tool-aware so non-Claude sends aren't reported as false drops.
- **1.7.73** — Hook config in `settings.json` went stale on binary upgrade (only command presence was checked); the full hook record is now verified and updated on mismatch.
- **1.9.6** — Clearing a session's Claude session id left a stale hook sidecar on disk that made the session look still hook-bound; it's now deleted with the id.

### tmux control pipes, pane caches, pane tracking
- **1.9.71** — Control pipes are now kept live only for cursor-focused/attached/recently-viewed sessions (LRU ≤4) instead of one per session at startup — eliminates attach-storm freezes and tmux server backpressure when multiple deck instances share sessions.
- **1.9.2** — Two TUIs on one profile SIGTERMed each other's control pipes indefinitely, oscillating every session to `error` within ~20s; orphan detection now checks the client's parent process before sweeping. **1.9.46** additionally made single-instance-per-profile the default (`allow_multiple=false`) so concurrent instances stop tearing each other down.
- **1.9.51** — SIGHUP (terminal window close) now closes control pipes before exit so control-mode clients detach cleanly instead of orphaning and piling up against the tmux server.
- **1.7.68 / 1.7.72 / 1.8.2** — Control-pipe and stale-client teardown progressively softened (SIGTERM+grace, then stdin-EOF fast path) to stop triggering an upstream tmux NULL-deref SIGSEGV that crashed the tmux server (killing sessions) on macOS.
- **1.7.43** — Control-pipe readers, MCP proxies, and triage spawns never reaped children that exited on their own — unbounded zombie accumulation (43 observed) eventually caused fork failures; reaping now fires on natural EOF too.
- **1.8.3** — A stale tmux pane-info cache blanked the inline pane title (task description) between refreshes; render now falls back to the previous snapshot on cache miss.
- **1.9.55** — TUI at scale: capture-pane no longer fires for unrendered previews, and the 2s status sweep backs off adaptively (to 10s) when overrunning instead of piling up on the tmux server. Also stopped the Codex detector re-walking the entire sessions tree on every poll once the session id is bound.
- **1.7.56** — Socket isolation was ignored by attach/resize/pipe-pane and the pane-info cache fallback, which all hit the default tmux server (stale/empty pane titles and tool detection on isolated installs); all six sites now route through the socket-aware factory.

### Sessions wrongly killed, vanishing, or lost
- **1.5.4** — tmux servers now survive SSH logout on Linux+systemd via user-scope launch. **1.9.10** extended this: `agent-deck launch` detaches the tmux server from the SSH login cgroup, so sessions no longer launch fine and then die minutes after disconnect under `KillUserProcesses=yes`.
- **1.9.48** — The `revive` path clobbered sessions added concurrently, making sessions disappear from the TUI; it now reconciles safely.
- **1.9.32** — Federated remote sessions flickered out on a single transient SSH error (one slow remote also starved the rest); remotes now fetch in parallel with last-good data kept per remote.
- **1.9.60** — Stale SSH ControlMaster sockets hung remote fetches indefinitely, making all remote sessions vanish until restart; dead sockets are now probed and swept before each fetch.
- **1.9.15** — Concurrent `launch` calls silently dropped N−1 of N session inserts (phantom tmux panes with no DB row); inserts are now verified with retry and fail loudly.
- **1.9.1** — Parallel `agent-deck rm` resurrected rows other processes just deleted while printing success; targeted delete-and-verify fixes it, and removal now also sweeps notifier inboxes/state for the removed child.
- **1.9.56** — A primary instance killed by SIGKILL/OOM blocked restart with "already running" until the heartbeat window expired; the recorded primary's PID is now liveness-checked.

### Completion/transition event delivery (idle watchers, conductor signalling)
- **1.7.45** — The transition notifier silently lost 53% of child events: deferred "target busy" events were never retried (state overwritten each poll) and one slow pane head-of-line-blocked all sends; adds a persistent deferred-retry queue with age-out and async per-target dispatch with a missed-events log.
- **1.7.74** — The notify-daemon leaked one SQLite connection per dispatch (~34/min) until it wedged — the true root cause of "events stop arriving after a while"; also fixed duplicate inbox fingerprints (13× writes) and exhausted busy-retries re-firing forever.
- **1.9.8 / 1.9.10 / 1.9.11** — Three variants of deferred-queue replay spam fixed: events replayed for sessions removed via `rm`, target-busy inbox entries accumulating without cleanup/TTL, and the `NoTransitionNotify` mute flag ignored on replay — all unified behind a single `eventDeliverable` gate.
- **1.9.29 / 1.9.36** — Duplicate `[EVENT]` storms killed: a status flap could fan out 47 duplicates (dedup now keyed on child+status+output-hash), and idle-but-animating panes re-fired the same event 10–40× (dedup key now derived from transcript content, not the redraw clock).
- **1.9.36** — Workers now print a completion sentinel and agent-deck emits a real `[DONE] Child finished` event on the Stop-hook edge, replacing the ambiguous `waiting` status conductors had to poll around.
- **1.9.44 / 1.9.45** — Durable per-parent outbox replaces push-into-tmux delivery (completions were silently lost to always-busy conductors): at-least-once delivery with exactly-once effects, surviving busy-ness/restart/compaction; a wake-nudge then collapsed idle-conductor delivery latency from ~14min worst case to sub-second.
- **1.9.20** — Routed watcher events now actually reach the conductor's tmux pane instead of stopping at the event bus.

### Restart / resume correctness
- **1.9.19** — The `claude --resume` "Resume from summary" picker froze unattended conductors past ~250k tokens on `waiting` forever; it's now auto-confirmed after restart. Same release: a Claude exit could trigger a thundering herd of concurrent restart attempts; restarts are now single-flight per session.
- **1.7.27** — A restart racing the SessionEnd JSONL flush fell back from `--resume` to `--session-id`, handing the user a blank conversation despite history on disk; a bounded retry closes the race.
- **1.7.35** — Concurrent restarts accumulated duplicate tmux sessions for shell/placeholder sessions (guard only keyed on tool session ids); a second sweep keyed on `AGENTDECK_INSTANCE_ID` makes it tool-agnostic. **1.7.25** had already added the duplicate-session sweep to the respawn-pane restart branches.
- **1.7.39** — A watchdog double-fire made `session restart` tear down a just-started healthy tmux scope; a 60s freshness guard (with `--force` bypass) skips redundant restarts.
- **1.7.70** — A stale Codex session-id caused an infinite `codex resume` death loop on restart; the id is now verified against rollout files and cleared to self-heal.
- **1.9.5** — An empty configured Claude command made restart respawn a bare shell that looked `attached` but was a dead pane; it now falls through to the default claude invocation.
- **1.9.10** — Conductor restart threw away the chat scrollback; the prior history file is now re-bound so the conversation survives restart.
- **1.9.14** — Custom-command sessions false-errored on restart ("missing session id") because they never get a `claude_session_id`; null is now treated as "not yet emitted".
- **1.9.59 / 1.9.62** — Model selection lost on restart: `[claude].default_model` is now honored at spawn and restart (children previously booted silently on an unavailable default while still showing `running`), a persisted per-session `model` field survives restart, and a malformed `--extra-arg "--model opus"` now fails fast instead of leaving a dead pane reported as running.
- **1.9.57** — Forks silently dropped inherited `extra_args` on their first restart (and forks-of-forks never got them); they're now persisted on the fork.
- **1.9.69** — Cursor sessions became restartable (`R`, `--continue`), and the launch readiness loop no longer waits forever when tmux reports "starting" while the prompt is already visible.
- **1.9.9** — A slash-command sent right after restart was delivered as literal text (slash registration race); sends now wait for registration.
- **1.9.47** — Built-in Pi sessions resume correctly.

### Session-id binding / transcript identity
- **1.9.28 / 1.9.29** — Claude (after `/clear`), Codex, and Gemini session-id rebinds updated memory but never SQLite, so anything joining on `tool_data` followed stale UUIDs forever; rebinds now persist at rebind time.
- **1.8.2** — The rebind size-guard rejected the legitimately smaller post-`/clear` JSONL, leaving the TUI stuck on the old session; an mtime-newer escape hatch allows it while keeping flap protection.
- **1.9.30** — With two sessions in one cwd, the second's explicit `--session-id` was silently overwritten by the first's, hijacking JSONL transcripts between unrelated agents; the caller's id is now preserved.
- **1.9.58** — When multiple live sessions collided on one `claude_session_id`, `session output` could hand a conductor another child's reply; the collision-checked resolver now refuses instead of returning a colliding transcript.
- **1.7.13** — Cross-session output transfer (`x`) used a stale stored session id and shipped text from a prior conversation; the live tmux env id is now preferred.

## PART B — Headline new features (daily-user digest)

- **1.9.68** — Command Center: a live two-way fleet dashboard tab in `agent-deck web` — cross-project status via SSE, completion toasts, decisions-waiting list, and an input box to instruct any conductor.
- **1.9.66** — Honest Status v2: TUI glyphs and `--json` `substate` field tell you *why* a session is stuck (model-unavailable / auth-401 / idle-at-empty-prompt).
- **1.9.58** — `Ctrl+S` session switcher: MRU picker to hop between sessions without detaching (made unbound-by-default in 1.9.72 — set `[hotkeys].switch_session`).
- **1.9.60** — `Y` extracts and copies fenced code blocks from a session's output (OSC52, works over SSH), with a picker when there are several.
- **1.9.62** — `o` sends a one-line prompt to the highlighted session straight from the list, no attach.
- **1.9.55** — Archive/unarchive sessions (`A` / `Shift+U` / `^` toggle view) and `session switch-account` to move a session — conversation included — to another Claude account.
- **1.9.50** — Comprehensive quick fork (`f`): new worktree + branch carrying uncommitted state, Docker parity, and launch options, configurable via `[fork]`; works across Claude/OpenCode/Pi/Codex and jj.
- **1.9.49** — XDG base-directory support with `agent-deck migrate-paths`; new installs use `~/.config` / `~/.local/share` / `~/.cache`.
- **1.9.14–1.9.20 / 1.9.69** — New first-class agents: crush, Cursor, Hermes, Copilot detection+resume, Cursor status hooks + restart; uniform `[tool].command` / `env_file` overrides for all builtins (1.9.19).
- **1.9.25 / 1.9.26 / 1.8.0** — Web UI grew up: five-zone responsive redesign (1.8.0), then Skills + MCP management tabs, conductor children panel, close + undo-delete, and full edit-dialog parity.
- **1.9.2** — Per-session Claude plugin management (`--plugin`, `l` Plugin Manager dialog) and cross-profile migration (`session/conductor/group move --to-profile`).
- **1.9.29** — `--idle-timeout 30m` auto-stops dormant child sessions (per-session settable at any time).
- **1.7.50** — Tmux socket isolation: run agent-deck on its own tmux server via `[tmux].socket_name` so your personal tmux is never touched.
- **1.7.48** — `session send --stream`: structured JSONL streaming of a reply (text/tool_use/tool_result events) while it's being produced; plus `send --draft` to pre-fill without submitting (1.9.2).
- **1.9.56 / 1.9.7 / 1.9.58** — List organization: pin sessions top/bottom of group, "most actionable first" sorting, and `t` to cycle group view modes.
- **1.9.73 area (PR #1514)** — Tracked shell split: press `h` on a session to open a shell in its worktree as a tmux or native iTerm2 split (`[ui] shell_split = "iterm" | "tmux"`, auto-detects).

## PART C — Breaking changes & migration notes (1.5.1 → 1.9.73)

- **1.6.0 (BREAKING)** — Watcher data dir renamed `~/.agent-deck/watchers/` → `~/.agent-deck/watcher/` (singular); the compat symlink was removed in v1.7.0, so any hardcoded 1.5.x-era paths must be updated.
- **1.9.48/1.9.49** — New installs use the XDG layout; an existing `~/.agent-deck` keeps working via legacy fallback, with optional `agent-deck migrate-paths [--dry-run]` to move over.
- **SQLite schema migrations v6→v13** are all additive and run automatically — no action needed.
- **1.9.46** — `allow_multiple` now defaults to **false**: one agent-deck instance per profile (this is what stops instances killing each other's sessions). Set it back if you deliberately run several.
- **1.9.1** — Newly created groups default to **serial execution** (`max_concurrent=1`); over-cap launches sit in a new `queued` status instead of starting. Pre-existing groups keep unlimited behavior.
- **1.9.55** — New-session dialog: **Enter now advances fields** instead of submitting; `Ctrl+S` creates. Restore with `[ui].new_session_enter_advances = false`.
- **1.9.50** — The `Shift+F` fork dialog pre-seeds from `[fork]` defaults instead of honoring `[worktree].default_enabled` / `[docker].default_enabled`.
- **1.9.64** — `[conductor].enabled` flag removed; the conductor system is active exactly when a conductor exists on disk.
- **1.9.72** — Within-group session ordering default changed to **creation order** (set `group_sort = "actionable"` to keep recency sorting); the `Ctrl+S` switcher hotkey became opt-in.
- **1.9.41** — `agent-deck web` now refuses unauthenticated non-loopback binds (token required; explicit `--insecure-bind` to override).
- **1.8.0** — The pre-redesign web UI was removed with no `?legacy` toggle.
- Minor: **1.9.32** — hosts touched by earlier broken `remote update` runs may have a harmless stray `~/agent-deck` file to delete.
