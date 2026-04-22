# terminal-config

Personal terminal setup centered on `WezTerm + Zellij`, with an optional `tmux` fallback.

## Contents

- `config/wezterm/wezterm.lua`: active WezTerm config
- `config/zellij/config.kdl`: Zellij global config
- `config/zellij/layouts/codex.kdl`: Codex tab layout
- `config/zellij/layouts/claude.kdl`: Claude tab layout
- `config/tmux/tmux.conf`: tmux config
- `bin/zcodex`: open Codex layout/session
- `bin/zclaude`: open Claude layout/session
- `bin/zj`: attach/create a generic Zellij session

## Current Design

- Warm dark theme
- No dominant blue UI
- WezTerm starts maximized
- WezTerm starts in `zellij attach -c main`
- `Alt+Shift+v` pastes the path of the latest screenshot from `~/Pictures/Screenshots`
- `zcodex` opens a Codex tab/layout when inside Zellij, or starts a dedicated Codex session otherwise
- `zclaude` does the same for Claude

## Install

Copy the configs into place:

```bash
mkdir -p ~/.config/wezterm ~/.config/zellij/layouts ~/bin
cp config/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
cp config/zellij/config.kdl ~/.config/zellij/config.kdl
cp config/zellij/layouts/codex.kdl ~/.config/zellij/layouts/codex.kdl
cp config/zellij/layouts/claude.kdl ~/.config/zellij/layouts/claude.kdl
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

- The bundled `codex.kdl` and `claude.kdl` currently use user-specific binary paths:
  - `/home/bz/.npm-global/bin/codex`
  - `/home/bz/.local/bin/claude`
- If you use different install paths, update those layout files.
