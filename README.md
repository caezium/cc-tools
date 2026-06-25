# cc-tools

Small, dependency-light CLI utilities for power users of [Claude Code](https://docs.claude.com/en/docs/claude-code).

| Tool | What it does |
|------|--------------|
| [`cc-session`](bin/cc-session) | Run the Claude Code TUI in a persistent, detachable **tmux** session — survives disconnects, reattach anytime. Pairs with SSH to run Claude on a remote machine while you drive it from your laptop. |
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
cc-session                 # reattach the running session, or open ~/Desktop
cc-session myproject       # attach/create a session for ~/Desktop/myproject
cc-session /path/to/repo   # or an absolute path
cc-session .               # the current directory
cc-session ls              # list running sessions
cc-session kill myproject  # kill one
```
Detach a live session with `Ctrl-b` then `d`; it keeps running. Reattach with the same command.

**Run Claude on a remote box, drive it locally.** Because the TUI runs wherever you launch it, you can keep the agent + tool execution on a beefy remote machine and just render the TUI over SSH:
```sh
# on your laptop
ssh -t user@remote-host cc-session myproject
```
The agent, Bash, and file edits all happen on `remote-host`; closing your laptop doesn't interrupt it.

Config via env: `CC_BASE` (project root, default `~/Desktop`), `CLAUDE_BIN` (path to the `claude` binary if not on `PATH`).

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
