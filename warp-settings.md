# Warp settings (reference)

Warp keeps its settings in the app, not in a dotfile you can copy, so this is a checklist.
Check Warp's docs for current option names.

- **Session restoration:** Settings > Features > "Restore windows, tabs, and panes on startup" (on by default).
  Restores layout and recent blocks after a restart. It does not keep running processes alive.
- **Font:** use a Nerd Font (for example JetBrains Mono Nerd Font) so Starship icons render.
- **Shell:** zsh. Starship, zoxide and fzf from `zshrc.template` work in Warp.
- **tmux:** works inside Warp, but Warp's block and input features mostly stop applying inside tmux.
  Best used for remote servers; use Warp's own tabs and panes for local work.
- **Saved layouts:** Warp's Launch Configurations / Tab Configs recreate a window and pane layout on demand.
