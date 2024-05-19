---- SETUP
-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- This will hold the configuration.
local config = wezterm.config_builder()

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

---- Apply your config choices below

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Latte"

-- Option keys https://wezfurlong.org/wezterm/config/keyboard-concepts.html#macos-left-and-right-option-key
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

config.keys = {
    -- Add move forward/backword word and to start/end of line
    { mods = "OPT", key = "LeftArrow", action = wezterm.action.SendKey({ mods = "ALT", key = "b" }) },
    { mods = "OPT", key = "RightArrow", action = wezterm.action.SendKey({ mods = "ALT", key = "f" }) },
    { mods = 'CMD', key = 'LeftArrow', action = wezterm.action { SendString = "\x1bOH" }, },
    { mods = 'CMD', key = 'RightArrow', action = wezterm.action { SendString = "\x1bOF" }, },
    { mods = "CMD", key = "Backspace", action = wezterm.action.SendKey({ mods = "CTRL", key = "u" }) },

    -- Add shell integration navigation
    { key = 'UpArrow', mods = 'SHIFT', action = wezterm.action.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = wezterm.action.ScrollToPrompt(1) },
}

config.mouse_bindings = {
    -- Quadruple click to select the entire command output (semantic zone) at once
    {
        event = { Down = { streak = 4, button = 'Left' } },
        action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
        mods = 'NONE',
    },
}


-- and finally, return the configuration to wezterm
return config
