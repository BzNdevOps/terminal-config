# terminal-config

Personal terminal setup centered on `WezTerm + Zellij`, with an optional `tmux` fallback.

## Contents

### Linux native
- `config/wezterm/wezterm.lua`: active WezTerm config
- `config/zellij/config.kdl`: Zellij global config
- `config/zellij/layouts/*.kdl`: Zellij layout files (ai, codex, claude, help, llm, sec, main)
- `bin/`: helper scripts for AI cockpit, monitoring, and session management
- `config/tmux/tmux.conf`: tmux fallback config
- `previews/`: SVG/PNG theme preview assets

### Windows + WSL2 sub-project
- `Win-WezTerm--Zellij-config/`: ported setup for Windows WezTerm (native) + WSL Ubuntu Zellij
  - `wezterm.lua`: Windows-native WezTerm config launching WSL
  - `install-wsl.sh`: deploys WSL configs + copies WezTerm config to Windows
  - `sync-from-source.sh`: re-syncs common files from this repo into the sub-project



## Current Design

- Gruvbox-style light day theme, with separate preview templates for night and sunset palettes
- No dominant blue UI
- WezTerm starts maximized and new cockpit windows opened by shortcuts are maximized
- WezTerm starts through `terminal-ai`, which attaches to `ai` unless the installed layout/config changed
- Zellij defaults to the `ai` layout
- Zellij quits the visible session on Alt+F4/window close instead of leaving a detached or resurrectable session
- The `ai` layout has five tabs: `Agents`, `ops`, `llm`, `sec`, and `help`
- Codex and Claude share the `Agents` tab
- The `llm` tab monitors bzserv GPU, services, containers, Open WebUI logs, and Ollama logs
- The `sec` tab monitors bzserv security services, SSH/auth events, listening ports, UFW, and fail2ban
- The `help` tab shows the most useful Zellij and WezTerm shortcuts
- `Ctrl+Shift+F9` opens the AI cockpit in a new WezTerm window
- `Ctrl+Shift+F10` opens a Codex-only session in a new WezTerm window
- `Ctrl+Shift+F11` opens a Claude-only session in a new WezTerm window
- `Alt+Shift+v` pastes the path of the latest screenshot from `~/Pictures/Screenshots`
- `zcodex` opens a Codex tab/layout when inside Zellij, or starts a dedicated Codex session otherwise
- `zclaude` does the same for Claude

## Theme Switching

Use `terminal-theme` when changing templates. It updates all layers that affect readability:

- WezTerm window colors
- Zellij theme and layouts
- Codex TUI theme
- Active Codex pane foreground/background, when a Zellij session is running

`terminal-ai` avoids the usual stale-layout problem by keeping a checksum of the installed Zellij config, `ai` layout, help layout, and cockpit helper scripts. If those inputs change, it kills and recreates only the `ai` session. Other Zellij sessions are left alone.

Apply the light day template:

```bash
terminal-theme light
```

If an already-running Codex process still has cached input colors, restart that Codex pane:

```bash
codex resume --last
```

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
cp bin/terminal-ai ~/bin/terminal-ai
cp bin/terminal-theme ~/bin/terminal-theme
cp bin/terminal-help ~/bin/terminal-help
cp bin/zcodex ~/bin/zcodex
cp bin/zclaude ~/bin/zclaude
cp bin/zj ~/bin/zj
chmod +x ~/bin/terminal-ai ~/bin/terminal-theme ~/bin/terminal-help ~/bin/zcodex ~/bin/zclaude ~/bin/zj
```

Make sure `~/bin` is in `PATH`.

## Windows / WSL2 Setup

For Windows + WSL2 Ubuntu, use the sub-project instead:

```bash
cd Win-WezTerm--Zellij-config
../sync-from-source.sh   # re-sync if source changed
./install-wsl.sh          # run inside WSL
```

See [`Win-WezTerm--Zellij-config/README.md`](Win-WezTerm--Zellij-config/README.md) for details.

---

## Usage

In WezTerm:

```bash
zellij attach ai
terminal-ai
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
