# terminal-config

Personal terminal setup centered on `WezTerm + Zellij`, with an optional `tmux` fallback.

## Contents

- `config/wezterm/wezterm.lua`: active WezTerm config
- `config/zellij/config.kdl`: Zellij global config
- `config/zellij/layouts/ai.kdl`: default AI cockpit with Codex, Claude, and ops tabs
- `config/zellij/layouts/codex.kdl`: Codex tab layout
- `config/zellij/layouts/claude.kdl`: Claude tab layout
- `config/zellij/layouts/help.kdl`: shortcuts help tab layout
- `config/zellij/layouts/main.kdl`: legacy combined Codex/Claude layout
- `config/tmux/tmux.conf`: tmux config
- `bin/zcodex`: open Codex layout/session
- `bin/zclaude`: open Claude layout/session
- `bin/zj`: attach/create a generic Zellij session

## Current Design

- Gruvbox-style dark theme
- No dominant blue UI
- WezTerm starts maximized
- WezTerm starts in `zellij attach ai || zellij --session ai --new-session-with-layout ai`
- Zellij defaults to the `ai` layout
- The `ai` layout has four tabs: `codex`, `claude`, `ops`, and `help`
- Codex and Claude each get a large agent pane plus shell and git/status panes
- The `help` tab shows the most useful Zellij and WezTerm shortcuts
- `Ctrl+Shift+F9` opens the AI cockpit in a new WezTerm window
- `Ctrl+Shift+F10` opens a Codex-only session in a new WezTerm window
- `Ctrl+Shift+F11` opens a Claude-only session in a new WezTerm window
- `Alt+Shift+v` pastes the path of the latest screenshot from `~/Pictures/Screenshots`
- `zcodex` opens a Codex tab/layout when inside Zellij, or starts a dedicated Codex session otherwise
- `zclaude` does the same for Claude

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
