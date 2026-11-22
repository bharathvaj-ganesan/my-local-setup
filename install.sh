#!/usr/bin/env bash
# Recreates the terminal setup on macOS.
#   ./install.sh                  full install
#   SKIP_PACKAGES=1 ./install.sh  only copy config files (no brew/git/network)
# Existing files are backed up (*.bak-<timestamp>) before being replaced.
# Private files (~/.secrets, ~/.zshrc.local) are created from the examples ONLY
# if missing, and are never overwritten.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

backup_and_copy() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -f "$dest" ] && ! cmp -s "$src" "$dest"; then
    cp "$dest" "$dest.bak-$STAMP"
    echo "  backed up $dest -> $dest.bak-$STAMP"
  fi
  cp "$src" "$dest"
  echo "  installed $dest"
}

create_private_if_missing() {
  local src="$1" dest="$2"
  if [ -f "$dest" ]; then
    echo "  kept existing $dest"
  else
    cp "$src" "$dest" && chmod 600 "$dest"
    echo "  created $dest from example (fill in real values)"
  fi
}

if [ "${SKIP_PACKAGES:-0}" != "1" ]; then
  command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }

  echo "==> Installing tools"
  brew install tmux starship zoxide fzf zsh-syntax-highlighting
  # Optional: brew install --cask ghostty font-jetbrains-mono-nerd-font

  echo "==> oh-my-zsh and zsh-autosuggestions"
  [ -d "$HOME/.oh-my-zsh" ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
  AS="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  [ -d "$AS" ] || git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$AS"

  echo "==> tmux plugin manager"
  [ -d "$HOME/.tmux/plugins/tpm" ] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "==> Config files"
backup_and_copy "$DIR/config/zsh/zshrc"             "$HOME/.zshrc"
backup_and_copy "$DIR/config/tmux/tmux.conf"        "$HOME/.tmux.conf"
backup_and_copy "$DIR/config/starship/starship.toml" "$HOME/.config/starship.toml"

echo "==> Private files"
create_private_if_missing "$DIR/secrets/secrets.example"      "$HOME/.secrets"
create_private_if_missing "$DIR/secrets/zshrc.local.example"  "$HOME/.zshrc.local"

if [ "${SKIP_PACKAGES:-0}" != "1" ] && [ -x "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
  echo "==> tmux plugins"
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true
fi

echo "Done. Fill in ~/.secrets and ~/.zshrc.local, open a new terminal, then run ./verify.sh"
