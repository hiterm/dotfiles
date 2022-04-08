local wezterm = require("wezterm")

local key_table = {
	{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "Tab", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },

	{ key = "k", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "j", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "h", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "l", mods = "ALT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "1", mods = "ALT", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "ALT", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "ALT", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "ALT", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "ALT", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "ALT", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "ALT", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "ALT", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "ALT", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "-", mods = "ALT", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "=", mods = "ALT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "h", mods = "ALT|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 1 } }) },
	{ key = "l", mods = "ALT|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 1 } }) },
	{ key = "k", mods = "ALT|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 1 } }) },
	{ key = "j", mods = "ALT|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 1 } }) },

	{ key = "s", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x13" }) },
	{ key = " ", mods = "LEADER", action = "QuickSelect" },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "mapped:[", mods = "LEADER", action = "ActivateCopyMode" },
	{
		key = 'mapped:"',
		mods = "LEADER|SHIFT",
		action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
	},
	{
		key = "mapped:%",
		mods = "LEADER|SHIFT",
		action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
	},
	{ key = "mapped:&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
	{ key = "mapped:/", mods = "LEADER", action = wezterm.action({ Search = { CaseInSensitiveString = "" } }) },
	{ key = "l", mods = "LEADER", action = "ShowLauncher" },
	{ key = "r", mods = "LEADER", action = "ReloadConfiguration" },
}

if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
	-- remap underscore key
	table.insert(key_table, { key = "raw:97", action = wezterm.action({ SendString = "_" }) })
end

if wezterm.target_triple == "x86_64-apple-darwin" then
	local mac_key_table = {
		{ key = "c", mods = "SUPER", action = wezterm.action({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "SUPER", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	}
	for _, value in ipairs(mac_key_table) do
		table.insert(key_table, value)
	end
end

local settings = {
	color_scheme = "nord",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

	disable_default_key_bindings = true,
	leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = key_table,
	quick_select_patterns = {
		"\\S{5,}",
	},

	launch_menu = {
		{
			label = "Config",
			args = { "nvim", "~/.config/wezterm/wezterm.lua" },
		},
	},
}

local mac_settings = {
	font = wezterm.font("PlemolJP Console", { weight = "Medium" }),
	font_size = 14.0,
}

local linux_settings = {
	font = wezterm.font("PlemolJP Console", { weight = "Medium" }),
	-- font = wezterm.font("UDEV Gothic"),
	-- font = wezterm.font_with_fallback({
	-- 	"MesloLGMDZ Nerd Font",
	-- 	"PlemolJP Console",
	-- }),
	font_size = 13.0,
}

if wezterm.target_triple == "x86_64-apple-darwin" then
	for k, v in pairs(mac_settings) do
		settings[k] = v
	end
end

if wezterm.target_triple == "x86_64-unknown-linux-gnu" then
	for k, v in pairs(linux_settings) do
		settings[k] = v
	end
end

return settings
