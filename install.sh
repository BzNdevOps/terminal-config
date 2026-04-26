#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for cmd in zellij wezterm tmux python3 ssh; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "install: $cmd not found in PATH" >&2; exit 1; }
done

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
backup() {
    local src="$1"
    [[ -f "$src" ]] && cp "$src" "${src}.bak.${TIMESTAMP}" && echo "backed up: ${src}.bak.${TIMESTAMP}" || true
}
backup "$HOME/.config/wezterm/wezterm.lua"
backup "$HOME/.config/zellij/config.kdl"
backup "$HOME/.tmux.conf"

mkdir -p "$HOME/.config/wezterm" "$HOME/.config/zellij/layouts" "$HOME/bin"
cp "$REPO_DIR/config/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
cp "$REPO_DIR/config/zellij/config.kdl" "$HOME/.config/zellij/config.kdl"
cp "$REPO_DIR/config/zellij/layouts/ai.kdl" "$HOME/.config/zellij/layouts/ai.kdl"
cp "$REPO_DIR/config/zellij/layouts/codex.kdl" "$HOME/.config/zellij/layouts/codex.kdl"
cp "$REPO_DIR/config/zellij/layouts/claude.kdl" "$HOME/.config/zellij/layouts/claude.kdl"
cp "$REPO_DIR/config/zellij/layouts/help.kdl" "$HOME/.config/zellij/layouts/help.kdl"
cp "$REPO_DIR/config/zellij/layouts/llm.kdl" "$HOME/.config/zellij/layouts/llm.kdl"
cp "$REPO_DIR/config/zellij/layouts/main.kdl" "$HOME/.config/zellij/layouts/main.kdl"
cp "$REPO_DIR/config/zellij/layouts/sec.kdl" "$HOME/.config/zellij/layouts/sec.kdl"
cp "$REPO_DIR/config/tmux/tmux.conf" "$HOME/.tmux.conf"
cp -p "$REPO_DIR/bin/zcodex" "$HOME/bin/zcodex"
cp -p "$REPO_DIR/bin/zclaude" "$HOME/bin/zclaude"
cp -p "$REPO_DIR/bin/zj" "$HOME/bin/zj"
cp -p "$REPO_DIR/bin/terminal-theme" "$HOME/bin/terminal-theme"
cp -p "$REPO_DIR/bin/bzserv-llm-monitor" "$HOME/bin/bzserv-llm-monitor"
cp -p "$REPO_DIR/bin/bzserv-security-monitor" "$HOME/bin/bzserv-security-monitor"

echo "Installed terminal-config into $HOME"
