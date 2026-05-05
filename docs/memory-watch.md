# Memory Watch

`mem-watch` is a lightweight macOS memory watchdog for catching runaway apps,
terminal processes, and Chrome helpers before the system reaches the Force Quit
"out of application memory" state.

It does **not** kill anything automatically. It samples process memory, writes a
history, and sends macOS notifications when something crosses a threshold or
grows quickly between samples.

## Files

- `bin/mem-watch` — one-shot sampler and alert logic.
- `bin/mem-watch-launchd` — installs/uninstalls the LaunchAgent that runs on the
  interval configured in `.mem-watch`.
- `.mem-watch` — required local config file in the dotfiles root. It is
  gitignored and is the single source of truth for thresholds and interval.
- `~/.local/state/mem-watch/latest.txt` — latest human-readable snapshot.
- `~/.local/state/mem-watch/events.log` — alerts only.
- `~/.local/state/mem-watch/samples.tsv` — rolling top-process/top-group samples.

## Quick start

```bash
./setup.sh
$EDITOR .mem-watch
mem-watch --top --no-notify
mem-watch-launchd install
```

Check status:

```bash
mem-watch-launchd status
```

Run one sample manually:

```bash
mem-watch-launchd run-once
```

Uninstall the background monitor:

```bash
mem-watch-launchd uninstall
```

## Configuration

All thresholds live in one required local file:

```bash
~/cs/dotfiles/.mem-watch
```

Required keys:

| Key | Meaning |
| --- | --- |
| `MEM_WATCH_PROCESS_GB` | Per-PID alert threshold |
| `MEM_WATCH_GROUP_GB` | App/group aggregate alert threshold |
| `MEM_WATCH_GROWTH_GB` | Growth threshold between samples |
| `MEM_WATCH_INTERVAL_SECONDS` | LaunchAgent run interval; reinstall after changing this |
| `MEM_WATCH_SAMPLE_TOP_N` | Rows recorded in reports |
| `MEM_WATCH_ALERT_COOLDOWN_SECONDS` | Per-alert notification cooldown |
| `MEM_WATCH_STATE_DIR` | Log/state directory; reinstall after changing this |

After changing `MEM_WATCH_INTERVAL_SECONDS` or `MEM_WATCH_STATE_DIR`, reinstall
the LaunchAgent so launchd picks up the new interval/log paths:

```bash
mem-watch-launchd install
```

## Diagnosing iTerm2

The Force Quit window can show `iTerm2` consuming huge memory even when a child
process is the real offender, or when the iTerm2 app itself has grown from large
scrollback/output. `mem-watch` records both:

- the iTerm2 app process itself in the top process list
- terminal descendant processes with `terminal-child-of=<pid>` markers

Useful checks after an alert:

```bash
open ~/.local/state/mem-watch/latest.txt
grep terminal-child ~/.local/state/mem-watch/latest.txt
```

If the iTerm2 app process is the only huge entry, reduce scrollback or look for a
session producing massive output. In iTerm2, also check Preferences → Profiles →
Terminal → Scrollback Lines.

## Diagnosing Chrome

Chrome exposes many helper/renderer processes, but macOS does not reliably map a
renderer PID back to a tab title from the command line. `mem-watch` will still
show whether the browser, GPU, utility, extension renderer, or tab renderer is
large.

After a Chrome alert:

1. Open Chrome Task Manager from Window → Task Manager (`Shift-Esc` also works
   on many Chrome installs).
2. Sort by memory footprint.
3. Match the rough type from `latest.txt` (`Chrome tab/renderer`, `Chrome GPU`,
   `Chrome extension renderer`, etc.).
4. Close the offending tab/extension/window.

## Reading historical samples

`samples.tsv` is tab-separated, so it opens cleanly in spreadsheets and can be
filtered later.

Examples:

```bash
open ~/.local/state/mem-watch/samples.tsv
open ~/.local/state/mem-watch/events.log
```
