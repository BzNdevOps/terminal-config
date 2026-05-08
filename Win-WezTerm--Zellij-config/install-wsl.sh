#!/usr/bin/env bash
set -euo pipefail

# Install the Win-WezTerm--Zellij-config into WSL Ubuntu + Windows WezTerm.
# Run this INSIDE WSL.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Detect Windows username via WSL ───────────────────────────────────────
WIN_HOME="$(wslpath "$USERPROFILE" 2>/dev/null || echo '')"
WIN_USER=""
if [[ -n "$WIN_HOME" ]]; then
    WIN_USER="$(basename "$WIN_HOME")"
fi

if [[ -z "$WIN_HOME" || ! -d "$WIN_HOME" ]]; then
    echo "ERROR: Cannot detect Windows user profile from WSL." >&2
    echo "Make sure WSL interop is enabled and %USERPROFILE% is set." >&2
    exit 1
fi

echo "Windows user: $WIN_USER"
echo "Windows home: $WIN_HOME"
echo "WSL home:     $HOME"

# ── Ensure dependencies ─────────────────────────────────────────────────
for cmd in zellij tmux python3 ssh; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Installing missing dependency: $cmd ..."
        sudo apt-get update -qq
        sudo apt-get install -y -qq zellij tmux python3 openssh-client
        break
    fi
done

# ── Backup existing configs ─────────────────────────────────────────────
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
backup() {
    local src="$1"
    [[ -f "$src" ]] && cp "$src" "${src}.bak.${TIMESTAMP}" && echo "backed up: ${src}.bak.${TIMESTAMP}" || true
}

backup "$HOME/.config/zellij/config.kdl"
backup "$HOME/.tmux.conf"
backup "$WIN_HOME/.config/wezterm/wezterm.lua"

# ── Install WSL-side configs ────────────────────────────────────────────
mkdir -p "$HOME/.config/zellij/layouts" "$HOME/bin"

cp "$SCRIPT_DIR/config/zellij/config.kdl"         "$HOME/.config/zellij/config.kdl"
cp "$SCRIPT_DIR/config/zellij/layouts/ai.kdl"     "$HOME/.config/zellij/layouts/ai.kdl"
cp "$SCRIPT_DIR/config/zellij/layouts/codex.kdl"  "$HOME/.config/zellij/layouts/codex.kdl"
cp "$SCRIPT_DIR/config/zellij/layouts/claude.kdl" "$HOME/.config/zellij/layouts/claude.kdl"
cp "$SCRIPT_DIR/config/zellij/layouts/help.kdl"   "$HOME/.config/zellij/layouts/help.kdl"
cp "$SCRIPT_DIR/config/zellij/layouts/llm.kdl"    "$HOME/.config/zellij/layouts/llm.kdl"
cp "$SCRIPT_DIR/config/zellij/layouts/main.kdl"   "$HOME/.config/zellij/layouts/main.kdl"
cp "$SCRIPT_DIR/config/zellij/layouts/sec.kdl"    "$HOME/.config/zellij/layouts/sec.kdl"
cp "$SCRIPT_DIR/config/tmux/tmux.conf"            "$HOME/.tmux.conf"

# ── Install scripts into ~/bin, fixing /home/bz paths ──────────────────
cp -p "$SCRIPT_DIR/bin/bzserv-llm-monitor"       "$HOME/bin/bzserv-llm-monitor"
cp -p "$SCRIPT_DIR/bin/bzserv-security-monitor"  "$HOME/bin/bzserv-security-monitor"
cp -p "$SCRIPT_DIR/bin/terminal-ai"              "$HOME/bin/terminal-ai"
cp -p "$SCRIPT_DIR/bin/terminal-help"            "$HOME/bin/terminal-help"
cp -p "$SCRIPT_DIR/bin/terminal-theme"           "$HOME/bin/terminal-theme"
cp -p "$SCRIPT_DIR/bin/zcodex"                   "$HOME/bin/zcodex"
cp -p "$SCRIPT_DIR/bin/zclaude"                  "$HOME/bin/zclaude"
cp -p "$SCRIPT_DIR/bin/zj"                       "$HOME/bin/zj"

chmod +x \
    "$HOME/bin/bzserv-llm-monitor" \
    "$HOME/bin/bzserv-security-monitor" \
    "$HOME/bin/terminal-ai" \
    "$HOME/bin/terminal-help" \
    "$HOME/bin/terminal-theme" \
    "$HOME/bin/zcodex" \
    "$HOME/bin/zclaude" \
    "$HOME/bin/zj"

# Replace hardcoded /home/bz with the actual WSL home
sed -i "s|/home/bz|$HOME|g" "$HOME/.config/zellij/layouts/"*.kdl
sed -i "s|/home/bz|$HOME|g" "$HOME/bin/terminal-help"
sed -i "s|/home/bz|$HOME|g" "$HOME/bin/bzserv-llm-monitor"
sed -i "s|/home/bz|$HOME|g" "$HOME/bin/bzserv-security-monitor"

# ── Install Windows-side WezTerm config ─────────────────────────────────
mkdir -p "$WIN_HOME/.config/wezterm"
cp "$SCRIPT_DIR/wezterm.lua" "$WIN_HOME/.config/wezterm/wezterm.lua"

echo ""
echo "=============================="
echo "Installation complete!"
echo "=============================="
echo ""
echo "WSL configs installed to:  $HOME/.config/zellij/  and  $HOME/.tmux.conf"
echo "Scripts installed to:      $HOME/bin/"
echo "WezTerm config copied to:  $WIN_HOME/.config/wezterm/wezterm.lua"
echo ""
echo "Next steps:"
echo "  1. Make sure $HOME/bin is in your PATH inside WSL"
echo "  2. Open WezTerm from Windows Start Menu"
echo "  3. Inside WSL, run:  terminal-ai"
echo ""
echo "If you install bzserv SSH keys later, update BZSERV_SSH_HOST in your shell profile."
