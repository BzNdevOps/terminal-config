local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

-- Windows-native WezTerm config that hosts WSL Ubuntu.
-- All Zellij / Codex / Claude tools run inside WSL.

local home = wezterm.home_dir

-- WSL default shell
local wsl_shell = { 'wsl.exe', '~' }

-- Commands executed inside WSL via bash -lc
local clear_zellij_env = 'unset ZELLIJ ZELLIJ_SESSION_NAME ZELLIJ_PANE_ID ZELLIJ_SOCKET_DIR'
local ai_cmd = 'cd ~; source ~/.bashrc 2>/dev/null; ' .. clear_zellij_env .. '; ~/bin/terminal-ai || exec bash -li'
local codex_cmd = 'cd ~; source ~/.bashrc 2>/dev/null; ' .. clear_zellij_env .. '; zellij --session codex --new-session-with-layout codex || exec bash -li'
local claude_cmd = 'cd ~; source ~/.bashrc 2>/dev/null; ' .. clear_zellij_env .. '; zellij --session claude --new-session-with-layout claude || exec bash -li'

local function maximize_window(window)
  local gui_window = window:gui_window()
  if gui_window then
    local ok = pcall(function()
      gui_window:maximize()
    end)
    if not ok then
      gui_window:toggle_fullscreen()
    end
  end
end

wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  maximize_window(window)
end)

local function spawn_wsl_maximized(args)
  return wezterm.action_callback(function()
    local _, _, window = mux.spawn_window { args = args }
    maximize_window(window)
  end)
end

return {
  default_cwd = home,
  colors = {
    foreground = '#ffecd2',
    background = '#1e1428',
    cursor_bg = '#ff9a3c',
    cursor_fg = '#1e1428',
    cursor_border = '#ff9a3c',
    selection_fg = '#1e1428',
    selection_bg = '#ff9a3c',
    scrollbar_thumb = '#3d2b5e',
    split = '#ff9a3c',
    ansi = { '#1e1428', '#ff4d6d', '#80ffdb', '#ffd166', '#48cae4', '#c77dff', '#ff9a3c', '#ffecd2' },
    brights = { '#3d2b5e', '#ff6b9d', '#a0ffd6', '#ffe699', '#72d9f5', '#d9a0ff', '#ffb86c', '#ffffff' },
  },
  font_size = 13.0,
  line_height = 1.08,
  initial_cols = 100,
  initial_rows = 28,
  enable_tab_bar = false,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = 'RESIZE',
  adjust_window_size_when_changing_font_size = false,
  enable_scroll_bar = true,
  automatically_reload_config = true,
  window_padding = {
    left = 8,
    right = 8,
    top = 6,
    bottom = 6,
  },
  set_environment_variables = {
    COLORTERM = 'truecolor',
    CLAUDE_CODE_NO_FLICKER = '1',
    CLAUDE_CODE_DISABLE_TERMINAL_TITLE = '1',
  },
  scrollback_lines = 100000,
  default_prog = wsl_shell,
  launch_menu = {
    {
      label = 'AI cockpit',
      args = { 'wsl.exe', '~', '-e', 'bash', '-lc', ai_cmd },
    },
    {
      label = 'Codex only',
      args = { 'wsl.exe', '~', '-e', 'bash', '-lc', codex_cmd },
    },
    {
      label = 'Claude only',
      args = { 'wsl.exe', '~', '-e', 'bash', '-lc', claude_cmd },
    },
  },
  keys = {
    { key = 'F9',  mods = 'CTRL|SHIFT', action = spawn_wsl_maximized { 'wsl.exe', '~', '-e', 'bash', '-lc', ai_cmd } },
    { key = 'F10', mods = 'CTRL|SHIFT', action = spawn_wsl_maximized { 'wsl.exe', '~', '-e', 'bash', '-lc', codex_cmd } },
    { key = 'F11', mods = 'CTRL|SHIFT', action = spawn_wsl_maximized { 'wsl.exe', '~', '-e', 'bash', '-lc', claude_cmd } },
    { key = 'PageUp',   mods = 'CTRL|SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'CTRL|SHIFT', action = act.ScrollByPage(1) },
    { key = 'UpArrow',  mods = 'CTRL|SHIFT', action = act.ScrollByLine(-3) },
    { key = 'DownArrow',mods = 'CTRL|SHIFT', action = act.ScrollByLine(3) },
    { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
  },
}
