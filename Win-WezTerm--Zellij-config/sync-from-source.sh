#!/usr/bin/env bash
set -euo pipefail

# Synchronize common files from the parent terminal-config repo
# into this Win-WezTerm--Zellij-config/ sub-project.
# Run this whenever you update the source project.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Source: $SOURCE_DIR"
echo "Target: $SCRIPT_DIR"

mkdir -p "$SCRIPT_DIR/config/zellij/layouts"
mkdir -p "$SCRIPT_DIR/config/tmux"
mkdir -p "$SCRIPT_DIR/bin"

# Copy Zellij configs
cp "$SOURCE_DIR/config/zellij/config.kdl"    "$SCRIPT_DIR/config/zellij/config.kdl"
cp "$SOURCE_DIR/config/zellij/layouts/ai.kdl"      "$SCRIPT_DIR/config/zellij/layouts/ai.kdl"
cp "$SOURCE_DIR/config/zellij/layouts/codex.kdl"   "$SCRIPT_DIR/config/zellij/layouts/codex.kdl"
cp "$SOURCE_DIR/config/zellij/layouts/claude.kdl"  "$SCRIPT_DIR/config/zellij/layouts/claude.kdl"
cp "$SOURCE_DIR/config/zellij/layouts/help.kdl"    "$SCRIPT_DIR/config/zellij/layouts/help.kdl"
cp "$SOURCE_DIR/config/zellij/layouts/llm.kdl"     "$SCRIPT_DIR/config/zellij/layouts/llm.kdl"
cp "$SOURCE_DIR/config/zellij/layouts/main.kdl"    "$SCRIPT_DIR/config/zellij/layouts/main.kdl"
cp "$SOURCE_DIR/config/zellij/layouts/sec.kdl"     "$SCRIPT_DIR/config/zellij/layouts/sec.kdl"

# Copy tmux
cp "$SOURCE_DIR/config/tmux/tmux.conf" "$SCRIPT_DIR/config/tmux/tmux.conf"

# Copy scripts
cp -p "$SOURCE_DIR/bin/bzserv-llm-monitor"       "$SCRIPT_DIR/bin/bzserv-llm-monitor"
cp -p "$SOURCE_DIR/bin/bzserv-security-monitor"  "$SCRIPT_DIR/bin/bzserv-security-monitor"
cp -p "$SOURCE_DIR/bin/terminal-ai"              "$SCRIPT_DIR/bin/terminal-ai"
cp -p "$SOURCE_DIR/bin/terminal-help"            "$SCRIPT_DIR/bin/terminal-help"
cp -p "$SOURCE_DIR/bin/terminal-theme"           "$SCRIPT_DIR/bin/terminal-theme"
cp -p "$SOURCE_DIR/bin/zcodex"                   "$SCRIPT_DIR/bin/zcodex"
cp -p "$SOURCE_DIR/bin/zclaude"                  "$SCRIPT_DIR/bin/zclaude"
cp -p "$SOURCE_DIR/bin/zj"                       "$SCRIPT_DIR/bin/zj"

echo "Synced from source. Next: review wezterm.lua colors/paths, then run install-wsl.sh inside WSL."
