#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.config/wezterm" "$HOME/.config/zellij/layouts" "$HOME/bin"
cp config/wezterm/wezterm.lua "$HOME/.config/wezterm/wezterm.lua"
cp config/zellij/config.kdl "$HOME/.config/zellij/config.kdl"
cp config/zellij/layouts/ai.kdl "$HOME/.config/zellij/layouts/ai.kdl"
cp config/zellij/layouts/codex.kdl "$HOME/.config/zellij/layouts/codex.kdl"
cp config/zellij/layouts/claude.kdl "$HOME/.config/zellij/layouts/claude.kdl"
cp config/zellij/layouts/help.kdl "$HOME/.config/zellij/layouts/help.kdl"
cp config/zellij/layouts/llm.kdl "$HOME/.config/zellij/layouts/llm.kdl"
cp config/zellij/layouts/main.kdl "$HOME/.config/zellij/layouts/main.kdl"
cp config/zellij/layouts/sec.kdl "$HOME/.config/zellij/layouts/sec.kdl"
cp config/tmux/tmux.conf "$HOME/.tmux.conf"
cp bin/zcodex "$HOME/bin/zcodex"
cp bin/zclaude "$HOME/bin/zclaude"
cp bin/zj "$HOME/bin/zj"
cp bin/bzserv-llm-monitor "$HOME/bin/bzserv-llm-monitor"
cp bin/bzserv-security-monitor "$HOME/bin/bzserv-security-monitor"
chmod +x "$HOME/bin/zcodex" "$HOME/bin/zclaude" "$HOME/bin/zj" "$HOME/bin/bzserv-llm-monitor" "$HOME/bin/bzserv-security-monitor"

echo "Installed terminal-config into $HOME"
