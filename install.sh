#!/usr/bin/env bash
# Sets up the terminal stack on macOS from the templates in this folder.
# Existing files are backed up with a timestamp before being replaced.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"

backup_and_copy() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -f "$dest" ]; then
    cp "$dest" "$dest.bak-$STAMP"
    echo "Backed up $dest -> $dest.bak-$STAMP"
  fi
  cp "$src" "$dest"
  echo "Installed $dest"
}

command -v brew >/dev/null || { echo "Install Homebrew first: https://brew.sh"; exit 1; }

echo "==> Installing tools"
brew install tmux starship zoxide fzf zsh-syntax-highlighting
# Optional terminal apps / font:
#   brew install --cask ghostty
#   brew install --cask font-jetbrains-mono-nerd-font

echo "==> oh-my-zsh and zsh-autosuggestions"
[ -d "$HOME/.oh-my-zsh" ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
AS="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
[ -d "$AS" ] || git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$AS"

echo "==> tmux plugin manager"
[ -d "$HOME/.tmux/plugins/tpm" ] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

echo "==> Config files"
backup_and_copy "$DIR/zshrc.template"          "$HOME/.zshrc"
backup_and_copy "$DIR/tmux.conf.template"      "$HOME/.tmux.conf"
backup_and_copy "$DIR/starship.toml.template"  "$HOME/.config/starship.toml"

echo "==> Installing tmux plugins"
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || true

echo "Done. Open a new terminal. Put secrets in ~/.secrets (chmod 600), never in .zshrc."
