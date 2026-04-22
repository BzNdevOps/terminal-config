#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.config/wezterm" "$HOME/.config/zellij/layouts" "$HOME/bin"
cp config/wezterm/wezterm.lua "$HOME/.config/wezterm/wezterm.lua"
cp config/zellij/config.kdl "$HOME/.config/zellij/config.kdl"
cp config/zellij/layouts/codex.kdl "$HOME/.config/zellij/layouts/codex.kdl"
cp config/zellij/layouts/claude.kdl "$HOME/.config/zellij/layouts/claude.kdl"
cp config/tmux/tmux.conf "$HOME/.tmux.conf"
cp bin/zcodex "$HOME/bin/zcodex"
cp bin/zclaude "$HOME/bin/zclaude"
cp bin/zj "$HOME/bin/zj"
chmod +x "$HOME/bin/zcodex" "$HOME/bin/zclaude" "$HOME/bin/zj"

echo "Installed terminal-config into $HOME"
