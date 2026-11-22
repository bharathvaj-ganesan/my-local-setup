#!/usr/bin/env bash
# Checks that the setup is installed and healthy. Exits non-zero on any failure.
#   ./verify.sh            check the real $HOME
#   HOME=/some/dir ./verify.sh   check another home (used for testing)
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FAIL=0
ok()   { echo "  ok    $1"; }
bad()  { echo "  FAIL  $1"; FAIL=1; }
check(){ if eval "$2" >/dev/null 2>&1; then ok "$1"; else bad "$1"; fi; }

echo "== Tools"
for t in zsh git tmux starship zoxide fzf; do check "$t installed" "command -v $t"; done
check "zsh-syntax-highlighting" "[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]"
check "oh-my-zsh" "[ -d '$HOME/.oh-my-zsh' ]"
check "zsh-autosuggestions" "[ -d '$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions' ]"
check "tmux plugin manager" "[ -d '$HOME/.tmux/plugins/tpm' ]"
check "tmux-resurrect" "[ -d '$HOME/.tmux/plugins/tmux-resurrect' ]"
check "tmux-continuum" "[ -d '$HOME/.tmux/plugins/tmux-continuum' ]"

echo "== Config matches repo"
check ".zshrc"        "cmp -s '$DIR/config/zsh/zshrc' '$HOME/.zshrc'"
check ".tmux.conf"    "cmp -s '$DIR/config/tmux/tmux.conf' '$HOME/.tmux.conf'"
check "starship.toml" "cmp -s '$DIR/config/starship/starship.toml' '$HOME/.config/starship.toml'"

echo "== Private files"
check "~/.secrets exists"     "[ -f '$HOME/.secrets' ]"
check "~/.secrets is chmod 600" "[ \"\$(stat -f %Lp '$HOME/.secrets')\" = 600 ]"
check "~/.zshrc.local exists" "[ -f '$HOME/.zshrc.local' ]"
check "no placeholder values left in ~/.secrets" "! grep -q '<your-' '$HOME/.secrets'"
check "no inline secrets in ~/.zshrc" "! grep -qiE '(token|secret|password|api_?key)=[\"'\\'']?[A-Za-z0-9_-]{16,}' '$HOME/.zshrc'"

echo "== Shell and tmux load"
# Ignore known-benign noise: zle warnings (no TTY) and macOS Terminal session messages.
check "zsh starts cleanly" "[ -z \"\$(zsh -ic 'exit' 2>&1 >/dev/null | grep -vE \"can't change option: zle|Saving session|Deleting expired sessions|Restored session|^\$\")\" ]"
check "starship prompt renders" "zsh -ic 'starship prompt' "
check "tmux.conf parses" "tmux -f '$HOME/.tmux.conf' -L verify-$$ start-server \\; kill-server"

echo "== Repo hygiene (tracked files)"
if git -C "$DIR" rev-parse >/dev/null 2>&1; then
  check "no private files tracked" "! git -C '$DIR' ls-files | grep -E '(^|/)(\\.secrets|\\.zshrc\\.local)$'"
  check "no token-like strings tracked" "! git -C '$DIR' grep -nIE 'npm_[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,}' -- ."
fi

echo
[ "$FAIL" = 0 ] && echo "All checks passed." || { echo "Some checks failed."; exit 1; }
