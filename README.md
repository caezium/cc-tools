# cc-tools

Small, dependency-light CLI utilities for power users of [Claude Code](https://docs.claude.com/en/docs/claude-code).

| Tool | What it does |
|------|--------------|
| [`cc-tools`](bin/cc-tools) | Launcher — run with no args to pick a tool below, or `cc-tools <tool> [args]` to dispatch directly. |
| [`cc-session`](bin/cc-session) | Run the Claude Code TUI in a persistent, detachable **tmux** session — survives disconnects, reattach anytime. Run it with no args for an interactive **picker** (search running sessions + projects). |
| [`cc-remote`](bin/cc-remote) | Drive Claude Code on a **remote machine** over SSH from a simple host config — agent + tools run there, TUI renders locally. Picker included. |
| [`ccron`](bin/ccron) | Manage the **cron jobs Claude schedules for itself** (`scheduled_tasks.json`): list, inspect, pause, resume, delete — independent of any running session. The off-switch for "Claude woke up on its own." |

No secrets, no network calls — both tools only touch local files.

## Install

### Homebrew (macOS)
```sh
brew install caezium/tap/cc-tools
```

### Script
```sh
git clone https://github.com/caezium/cc-tools.git
cd cc-tools && ./install.sh        # symlinks into ~/.local/bin
```
Or one-liner:
```sh
curl -fsSL https://raw.githubusercontent.com/caezium/cc-tools/main/install.sh | bash -s -- || \
  { git clone https://github.com/caezium/cc-tools.git && cd cc-tools && ./install.sh; }
```

`cc-session` needs `tmux` (`brew install tmux`). `ccron` needs only Python 3 (preinstalled on macOS).

## cc-session

```sh
cc-session                 # interactive picker: search running sessions + projects
cc-session myproject       # attach/create a session for ~/Desktop/myproject
cc-session /path/to/repo   # or an absolute path
cc-session .               # the current directory
cc-session ls              # list running sessions
cc-session kill myproject  # kill one
```
Run with no argument and you get a **picker** — fuzzy-search your running sessions (shown with `●`)
and projects instead of remembering names. It uses [`fzf`](https://github.com/junegunn/fzf) if
installed, otherwise a numbered menu. The project list defaults to real repos (dirs with `.git`/`.claude`)
under `$CC_BASE`; set `CC_ALL_DIRS=1` to list every subdir.

Detach a live session with `Ctrl-b` then `d`; it keeps running. Reattach with the same command.

Config via env: `CC_BASE` (project root, default `~/Desktop`), `CLAUDE_BIN` (path to the `claude` binary if not on `PATH`).

## cc-remote

Keep the agent + tool execution on a beefy remote machine and drive it from your laptop — the TUI
renders locally over SSH. Configure hosts once, then launch by name (with the same picker):

```sh
cc-remote add studio user@100.64.0.10 -i ~/.ssh/studio -o IdentitiesOnly=yes
cc-remote                 # pick a host, then pick a session/project on it
cc-remote studio          # pick a session/project on "studio"
cc-remote studio myproj   # attach/create myproj on "studio"
cc-remote ls              # list configured remotes
```

Config lives at `~/.config/cc-tools/remotes` (override with `$CC_REMOTES`) — one host per line:
```
# name   ssh-target            [extra ssh options...]
studio    user@100.64.0.10    -i ~/.ssh/studio -o IdentitiesOnly=yes
```
See [`remotes.example`](remotes.example). **The remote host must have cc-tools installed too**
(`cc-remote` calls `cc-session` over there). The picker runs locally, so you only need `fzf` on your laptop.

## ccron

```sh
ccron ls                 # every scheduled job: id, schedule, next run, state, prompt
ccron show <id>          # full prompt + timing for one job
ccron pause <id>         # stop it firing (keeps it)
ccron resume <id>        # re-enable
ccron rm <id>            # delete one
ccron kill               # delete ALL jobs (confirms first); `--yes` to skip
ccron paths              # which scheduler files were found
```

It scans `~/.claude`, `./.claude`, and one level of project dirs under common workspace
roots (`~`, `~/Desktop`, `~/projects`, `~/code`, `~/src`). Point it at more locations with
`CCRON_EXTRA_ROOTS` (colon-separated):
```sh
CCRON_EXTRA_ROOTS="$HOME/work:$HOME/clients" ccron ls
```
Edits are written atomically with a `.bak` backup beside each file.

## License

MIT — see [LICENSE](LICENSE).
