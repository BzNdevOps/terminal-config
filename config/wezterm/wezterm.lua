local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

local home = wezterm.home_dir
local ai_cmd = 'zellij attach ai || zellij --session ai --new-session-with-layout ai || exec bash -li'
local codex_cmd = 'zellij attach codex || zellij --session codex --new-session-with-layout codex || exec bash -li'
local claude_cmd = 'zellij attach claude || zellij --session claude --new-session-with-layout claude || exec bash -li'

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

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
    background = '#fbf1c7',
    cursor_bg = '#3c3836',
    cursor_fg = '#fbf1c7',
    cursor_border = '#3c3836',
    selection_fg = '#1d2021',
    selection_bg = '#fe8019',
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
    { key = 'F9', mods = 'CTRL|SHIFT', action = act.SpawnCommandInNewWindow { args = { 'bash', '-lc', ai_cmd } } },
    { key = 'F10', mods = 'CTRL|SHIFT', action = act.SpawnCommandInNewWindow { args = { 'bash', '-lc', codex_cmd } } },
    { key = 'F11', mods = 'CTRL|SHIFT', action = act.SpawnCommandInNewWindow { args = { 'bash', '-lc', claude_cmd } } },
    { key = 'PageUp', mods = 'CTRL|SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'CTRL|SHIFT', action = act.ScrollByPage(1) },
    { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(-3) },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(3) },
    { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
  },
}
