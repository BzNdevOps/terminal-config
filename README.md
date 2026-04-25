# terminal-config

Personal terminal setup centered on `WezTerm + Zellij`, with an optional `tmux` fallback.

## Contents

- `config/wezterm/wezterm.lua`: active WezTerm config
- `config/zellij/config.kdl`: Zellij global config
- `config/zellij/layouts/ai.kdl`: default AI cockpit with Codex, Claude, ops, LLM monitoring, security, and help tabs
- `config/zellij/layouts/codex.kdl`: Codex tab layout
- `config/zellij/layouts/claude.kdl`: Claude tab layout
- `config/zellij/layouts/help.kdl`: shortcuts help tab layout
- `config/zellij/layouts/llm.kdl`: bzserv LLM monitoring tab layout
- `config/zellij/layouts/main.kdl`: legacy combined Codex/Claude layout
- `config/zellij/layouts/sec.kdl`: bzserv security and attack-surface tab layout
- `bin/bzserv-llm-monitor`: SSH-based GPU, service, and logs monitor for bzserv
- `bin/bzserv-security-monitor`: SSH-based security and attack-surface monitor for bzserv
- `config/tmux/tmux.conf`: tmux config
- `previews/terminal-theme-previews.png`: visual comparison of the three recommended terminal palettes
- `previews/terminal-theme-night.svg`: Night template preview based on Catppuccin Mocha
- `previews/terminal-theme-sunset.svg`: Sunset template preview based on a warm Gruvbox palette
- `previews/terminal-theme-light-day.svg`: Light day template preview based on Gruvbox Light
- `bin/zcodex`: open Codex layout/session
- `bin/zclaude`: open Claude layout/session
- `bin/zj`: attach/create a generic Zellij session

## Current Design

- Gruvbox-style light day theme, with separate preview templates for night and sunset palettes
- No dominant blue UI
- WezTerm starts maximized
- WezTerm starts in `zellij attach ai || zellij --session ai --new-session-with-layout ai`
- Zellij defaults to the `ai` layout
- The `ai` layout has six tabs: `codex`, `claude`, `ops`, `llm`, `sec`, and `help`
- Codex and Claude each get a large agent pane plus shell and git/status panes
- The `llm` tab monitors bzserv GPU, services, containers, Open WebUI logs, and Ollama logs
- The `sec` tab monitors bzserv security services, SSH/auth events, listening ports, UFW, and fail2ban
- The `help` tab shows the most useful Zellij and WezTerm shortcuts
- `Ctrl+Shift+F9` opens the AI cockpit in a new WezTerm window
- `Ctrl+Shift+F10` opens a Codex-only session in a new WezTerm window
- `Ctrl+Shift+F11` opens a Claude-only session in a new WezTerm window
- `Alt+Shift+v` pastes the path of the latest screenshot from `~/Pictures/Screenshots`
- `zcodex` opens a Codex tab/layout when inside Zellij, or starts a dedicated Codex session otherwise
- `zclaude` does the same for Claude

## Theme Previews

The `previews/` directory contains three visual templates for choosing a WezTerm + Zellij palette:

- **Night:** Catppuccin Mocha, for low-glare dark sessions.
- **Sunset:** Gruvbox Warm, for amber/orange evening work.
- **Light Day:** Gruvbox Light, for readable daytime work.

Open all three SVG previews in Chromium:

```bash
chromium-browser --new-window \
  previews/terminal-theme-night.svg \
  previews/terminal-theme-sunset.svg \
  previews/terminal-theme-light-day.svg
```

## Install

Copy the configs into place:

```bash
mkdir -p ~/.config/wezterm ~/.config/zellij/layouts ~/bin
cp config/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
cp config/zellij/config.kdl ~/.config/zellij/config.kdl
cp config/zellij/layouts/ai.kdl ~/.config/zellij/layouts/ai.kdl
cp config/zellij/layouts/codex.kdl ~/.config/zellij/layouts/codex.kdl
cp config/zellij/layouts/claude.kdl ~/.config/zellij/layouts/claude.kdl
cp config/zellij/layouts/help.kdl ~/.config/zellij/layouts/help.kdl
cp config/zellij/layouts/llm.kdl ~/.config/zellij/layouts/llm.kdl
cp config/zellij/layouts/main.kdl ~/.config/zellij/layouts/main.kdl
cp config/tmux/tmux.conf ~/.tmux.conf
cp bin/zcodex ~/bin/zcodex
cp bin/zclaude ~/bin/zclaude
cp bin/zj ~/bin/zj
chmod +x ~/bin/zcodex ~/bin/zclaude ~/bin/zj
```

Make sure `~/bin` is in `PATH`.

## Usage

In WezTerm:

```bash
zellij attach ai
zcodex
zclaude
```

Generic session attach/create:

```bash
zj
zj main
zj infra
```

## Notes

- The bundled `ai.kdl`, `codex.kdl`, and `claude.kdl` currently use user-specific binary paths:
  - `/home/bz/.npm-global/bin/codex`
  - `/home/bz/.local/bin/claude`
- If you use different install paths, update those layout files.
