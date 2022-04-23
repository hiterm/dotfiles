local wezterm = require("wezterm")

-- utils

local function append_table(table, other)
	for k, v in pairs(other) do
		table[k] = v
	end
end

local function append_array(array, other)
	for _, value in ipairs(other) do
		table.insert(array, value)
	end
end

local mac = wezterm.target_triple == "x86_64-apple-darwin"
local linux = wezterm.target_triple == "x86_64-unknown-linux-gnu"

-- key bindings

local key_table = {
	{ key = "t", mods = "CTRL|SHIFT", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "Tab", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },

	{ key = "mapped:+", mods = "CTRL|SHIFT", action = "IncreaseFontSize" },
	{ key = "mapped:-", mods = "CTRL", action = "DecreaseFontSize" },
	{ key = "0", mods = "CTRL", action = "ResetFontSize" },

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

if linux then
	-- remap underscore key
	table.insert(key_table, { key = "raw:97", action = wezterm.action({ SendString = "_" }) })
end

if mac then
	local mac_key_table = {
		{ key = "c", mods = "SUPER", action = wezterm.action({ CopyTo = "Clipboard" }) },
		{ key = "v", mods = "SUPER", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	}
	append_array(key_table, mac_key_table)
end

-- font

local font_list = {
	{
		name = "PlemolJP",
		setting = {
			font = wezterm.font("PlemolJP Console", { weight = "Medium" }),
		},
	},
	{
		name = "UDEV Gothic",
		setting = {
			font = wezterm.font("UDEV Gothic"),
		},
	},
	{
		name = "Source Han Code JP",
		setting = {
			font = wezterm.font("Source Han Code JP"),
		},
	},
	{
		name = "HackGen",
		setting = {
			font = wezterm.font("HackGenNerd Console"),
		},
	},
	{
		name = "Cica",
		setting = {
			font = wezterm.font("Cica"),
		},
	},
	{
		name = "Fira Code",
		setting = {
			font = wezterm.font_with_fallback({
				"FiraCode Nerd Font",
				"UDEV Gothic",
			}),
		},
	},
	{
		name = "Hack",
		setting = {
			font = wezterm.font_with_fallback({
				"Hack Nerd Font",
				"UDEV Gothic",
			}),
		},
	},
	{
		name = "Source Code Pro",
		setting = {
			font = wezterm.font_with_fallback({
				"SauceCodePro Nerd Font",
				"UDEV Gothic",
			}),
		},
	},
}
local date = os.date("*t")["yday"]
local today_font = font_list[(date % #font_list) + 1]

-- other settings

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
			label = "Font: " .. today_font["name"],
			args = { "nvim", "~/.config/wezterm/wezterm.lua" },
		},
	},
}

append_table(settings, today_font["setting"])

local mac_settings = {
	font_size = 14.0,
}

local linux_settings = {
	font_size = 13.0,
}

if mac then
	append_table(settings, mac_settings)
end

if linux then
	append_table(settings, linux_settings)
end

return settings
