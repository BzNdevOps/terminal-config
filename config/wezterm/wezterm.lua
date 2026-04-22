local wezterm = require 'wezterm'
local act = wezterm.action

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
  color_scheme = 'Gruvbox Dark',
  colors = {
    scrollbar_thumb = '#504945',
    split = '#3c3836',
  },
  font_size = 13.0,
  line_height = 1.08,
  initial_cols = 100,
  initial_rows = 28,
  window_startup_state = 'Maximized',
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
    CLAUDE_CODE_NO_FLICKER = '1',
  },
  scrollback_lines = 100000,
  default_prog = { 'bash', '-lc', 'zellij attach -c main' },
  keys = {
    { key = 'v', mods = 'ALT|SHIFT', action = wezterm.action_callback(paste_latest_screenshot) },
    { key = 'PageUp', mods = 'CTRL|SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageDown', mods = 'CTRL|SHIFT', action = act.ScrollByPage(1) },
    { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(-3) },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(3) },
    { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
  },
}
