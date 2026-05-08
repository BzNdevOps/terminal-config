local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

-- Windows-native WezTerm config that hosts WSL Ubuntu.
-- All Zellij / Codex / Claude tools run inside WSL.

local home = wezterm.home_dir

-- WSL default shell
local wsl_shell = { 'wsl.exe', '~' }

-- Commands executed inside WSL via bash -lc
local ai_cmd = 'source ~/.bashrc 2>/dev/null; ~/bin/terminal-ai || exec bash -li'
local codex_cmd = 'zellij attach codex 2>/dev/null || zellij --session codex --new-session-with-layout codex || exec bash -li'
local claude_cmd = 'zellij attach claude 2>/dev/null || zellij --session claude --new-session-with-layout claude || exec bash -li'

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
    foreground = '#3c3836',
    background = '#fbf1c7',
    cursor_bg = '#3c3836',
    cursor_fg = '#fbf1c7',
    cursor_border = '#3c3836',
    selection_fg = '#1d2021',
    selection_bg = '#fabd2f',
    scrollbar_thumb = '#d5c4a1',
    split = '#d5c4a1',
    ansi = { '#fbf1c7', '#cc241d', '#98971a', '#d79921', '#458588', '#b16286', '#689d6a', '#d5c4a1' },
    brights = { '#3c3836', '#9d0006', '#79740e', '#b57614', '#458588', '#b16286', '#689d6a', '#ffffff' },
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
