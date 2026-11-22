# my-local-setup

A clean, fast macOS terminal setup: **zsh + oh-my-zsh + Starship prompt + autocomplete + tmux (with persistence)**.
Everything here is a template with no secrets and no personal info.

## What's in the box

| File | Goes to | Purpose |
|---|---|---|
| `zshrc.template` | `~/.zshrc` | Shell config: lazy-loaded nvm/pyenv, autosuggestions, syntax highlighting, Starship, zoxide, fzf |
| `tmux.conf.template` | `~/.tmux.conf` | Sensible tmux defaults plus resurrect and continuum plugins |
| `starship.toml.template` | `~/.config/starship.toml` | Compact prompt config |
| `warp-settings.md` | n/a | Checklist for Warp (its settings live in the app) |
| `install.sh` | n/a | One-shot installer, backs up existing files first |

## Quick start

```bash
cd ~/personal/my-local-setup
./install.sh
```

Then open a new terminal tab. For prompt icons, install a Nerd Font and select it in your terminal:

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

## The tools, in one line each

- **Starship**: a prompt that shows the git branch, language versions and last-command status.
- **zsh-autosuggestions**: gray ghost text from your history; press `→` to accept.
- **zsh-syntax-highlighting**: valid commands turn green, typos turn red.
- **fzf**: `Ctrl+R` fuzzy history search, `Ctrl+T` file search.
- **zoxide**: `z <name>` jumps to a folder you've used before.
- **tmux**: sessions that outlive the terminal window (see below).

## tmux cheat sheet

Prefix is `Ctrl+b`, then:

| Keys | Action |
|---|---|
| `|` / `-` | Split side by side / stacked |
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
| SSH connection drops (tmux on the server) | Everything keeps running |
| Mac restarts | Layout restored by resurrect and continuum; running processes are not |

## Secrets

Never put tokens, passwords or API keys in `.zshrc`, or in anything you commit.
The template loads an untracked file instead:

```bash
touch ~/.secrets && chmod 600 ~/.secrets
echo 'export MY_TOKEN="..."' >> ~/.secrets
```

If a secret was ever pasted into a dotfile, rotate it.

## Customizing

- Add project aliases and SDK paths where the `TODO` comments are in `zshrc.template`.
- Re-run `./install.sh` after editing templates. It backs up the current files first (`*.bak-<timestamp>`).

## Undo

Restore a backup, for example `cp ~/.zshrc.bak-<timestamp> ~/.zshrc`, and delete `~/.tmux.conf`.
