# Simple and Clean local setup

A clean, fast macOS terminal setup: **zsh + oh-my-zsh + Starship prompt + autocomplete + tmux (with persistence)**.
The repo is safe to publish: it holds no secrets and no personal info. Anything private lives in two
untracked files on your machine (see [Secrets and local overrides](#secrets-and-local-overrides)).

## Features and advantages

**Features**

- **One-command install**: `./install.sh` sets up Homebrew tools, oh-my-zsh, plugins, tmux plugins and all config files.
- **Fast, readable terminal**: Starship prompt, autosuggestions, syntax highlighting, fuzzy search (fzf) and smart `cd` (zoxide).
- **Persistent sessions**: tmux with resurrect and continuum restores your layout after a restart.
- **Built-in health check**: `./verify.sh` confirms tools, config and private files are correct, and fails on any problem.
- **Split config**: three small files under `config/`, each mapped to one place in `$HOME`.

**Advantages**

- **Safe to publish**: no secrets or personal info in the repo. Tokens and machine-specific settings live in two untracked files (`~/.secrets`, `~/.zshrc.local`), with only `.example` templates committed.
- **Non-destructive**: existing files are backed up as `*.bak-<timestamp>`, and your private files are never overwritten.
- **Repeatable**: validated by rebuilding in an empty throwaway `HOME` and comparing it with a real machine.
- **Easy to undo**: restore a backup and delete `~/.tmux.conf`.
- **Small and understandable**: plain shell scripts and dotfiles, with no framework or hidden state to learn.

## Layout

```
my-local-setup/
├── install.sh                  # recreate the setup on a Mac
├── verify.sh                   # check everything is installed and healthy
├── config/
│   ├── zsh/zshrc               -> ~/.zshrc
│   ├── tmux/tmux.conf          -> ~/.tmux.conf
│   └── starship/starship.toml  -> ~/.config/starship.toml
├── secrets/                    # examples only; real files are never committed
│   ├── secrets.example         -> ~/.secrets       (tokens, chmod 600)
│   └── zshrc.local.example     -> ~/.zshrc.local   (machine/employer-specific)
└── docs/warp.md                # Warp checklist (its settings live in the app)
```

## Recreate on a new Mac

```bash
git clone <this-repo> ~/personal/my-local-setup
cd ~/personal/my-local-setup
./install.sh            # installs tools, copies config, creates private files from examples
$EDITOR ~/.secrets ~/.zshrc.local   # fill in real values
./verify.sh             # should end with "All checks passed."
```

`SKIP_PACKAGES=1 ./install.sh` copies config files only (no brew, git or network).
Existing files are backed up as `*.bak-<timestamp>`. Existing `~/.secrets` and `~/.zshrc.local` are never overwritten.

For prompt icons, install a Nerd Font and select it in your terminal:
`brew install --cask font-jetbrains-mono-nerd-font`

## Secrets and local overrides

Two private files, sourced by `~/.zshrc`, keep the repo clean:

| File | Holds | Notes |
|---|---|---|
| `~/.secrets` | API tokens, credentials, usernames | `chmod 600`. Never commit. |
| `~/.zshrc.local` | SDK paths, extra `PATH` entries, project env vars and aliases, company tooling | Never commit. |

`.gitignore` blocks both, and `verify.sh` fails if a token-like string is tracked or an inline secret is found in `~/.zshrc`.
If a secret was ever pasted into a dotfile or committed, rotate it.

**Back them up privately**, for example in a password manager or an encrypted vault. They are the part this repo deliberately does not store.

## How this was validated

The setup was rebuilt in an empty throwaway `HOME` from this repo plus private files, then compared with the real
machine's shell. Env vars, token hash, aliases, `PATH` entries, lazy-loaded functions and plugins matched exactly.
`verify.sh` passes on the rebuild, flags a fresh install that still has placeholder secrets, and catches an injected fake token.

## The tools, in one line each

- **Starship**: prompt showing git branch, language versions and last-command status.
- **zsh-autosuggestions**: gray ghost text from history; press `→` to accept.
- **zsh-syntax-highlighting**: valid commands turn green, typos turn red.
- **fzf**: `Ctrl+R` fuzzy history, `Ctrl+T` file search.
- **zoxide**: `z <name>` jumps to a folder you've used before.
- **tmux**: sessions that outlive the terminal window.

## tmux cheat sheet

Prefix is `Ctrl+b`, then:

| Keys | Action |
|---|---|
| `\|` or `-` | Split side by side or stacked |
| `c` | New window (tab) |
| `d` | Detach (session keeps running) |
| `s` | Switch session |
| `I` (capital i) | Install plugins (TPM) |
| `Ctrl+s` / `Ctrl+r` | Save / restore session (resurrect) |

```bash
tmux new -s work       # start a named session
tmux ls                # list sessions
tmux attach -t work    # reattach
```

### What persists

| Situation | Result |
|---|---|
| Close the terminal window | Everything keeps running |
| SSH drops (tmux on the server) | Everything keeps running |
| Mac restarts | Layout restored by resurrect and continuum; running processes are not |

## Notes

- `.zprofile` entries added by installers (JetBrains Toolbox, CLI tools) are not tracked here; those tools re-add them.
- Warp has no copyable config file; see `docs/warp.md`.

## Undo

Restore a backup, for example `cp ~/.zshrc.bak-<timestamp> ~/.zshrc`, and delete `~/.tmux.conf`.
