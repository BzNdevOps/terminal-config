local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

local home = wezterm.home_dir
local ai_cmd = '/home/bz/bin/terminal-ai || exec bash -li'
local codex_cmd = 'zellij attach codex || zellij --session codex --new-session-with-layout codex || exec bash -li'
local claude_cmd = 'zellij attach claude || zellij --session claude --new-session-with-layout claude || exec bash -li'

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

local function spawn_maximized(args)
  return wezterm.action_callback(function()
    local _, _, window = mux.spawn_window { args = args }
    maximize_window(window)
  end)
end

local function paste_latest_screenshot(window, pane)
  local success, stdout, stderr = wezterm.run_child_process {
    'bash',
    '-lc',
    "latest=$(find \"$HOME/Pictures/Screenshots\" -maxdepth 1 -type f | sort | tail -n 1) && [ -n \"$latest\" ] && printf '%q' \"$latest\"",
  }

  if not success then
    wezterm.log_error('latest screenshot failed: ' .. stderr)
    return
  end

  local path = stdout:gsub('%s+$', '')
  if path == '' then
    wezterm.log_info('no screenshot found')
    return
  end

  window:perform_action(act.SendString(path .. ' '), pane)
end

return {
  default_cwd = home,
  colors = {
    foreground = '#3c3836',
    background = '#f2e5bc',
    cursor_bg = '#3c3836',
    cursor_fg = '#f2e5bc',
    cursor_border = '#3c3836',
    selection_fg = '#ffffff',
    selection_bg = '#fabd2f',
    scrollbar_thumb = '#d5c4a1',
    split = '#d5c4a1',
    ansi = { '#f2e5bc', '#cc241d', '#4e9a06', '#7a5c00', '#004f6b', '#9d4f74', '#4f8a66', '#5f534a' },
    brights = { '#3c3836', '#fb4934', '#8ec07c', '#b38600', '#2f7a8a', '#d3869b', '#83a598', '#ffffff' },
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
  default_prog = { 'bash', '-lc', ai_cmd },
  launch_menu = {
    {
      label = 'AI cockpit',
      args = { 'bash', '-lc', ai_cmd },
    },
    {
      label = 'Codex only',
      args = { 'bash', '-lc', codex_cmd },
    },
    {
      label = 'Claude only',
      args = { 'bash', '-lc', claude_cmd },
    },
  },
  keys = {
    { key = 'v', mods = 'ALT|SHIFT', action = wezterm.action_callback(paste_latest_screenshot) },
    { key = 'F9', mods = 'CTRL|SHIFT', action = spawn_maximized { 'bash', '-lc', ai_cmd } },
    { key = 'F10', mods = 'CTRL|SHIFT', action = spawn_maximized { 'bash', '-lc', codex_cmd } },
    { key = 'F11', mods = 'CTRL|SHIFT', action = spawn_maximized { 'bash', '-lc', claude_cmd } },
    { key = 'PageUp', mods = 'CTRL|SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'CTRL|SHIFT', action = act.ScrollByPage(1) },
    { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(-3) },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(3) },
    { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
  },
}
