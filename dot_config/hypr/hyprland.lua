require("configs.env")
require("themes.catppuccin-mocha")
require("configs.monitors")

-- Core Engine configs (Hardware/Layout states that rarely change)
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 5,
		border_size = 1,
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
	dwindle = { preserve_split = true },
	master = { new_status = "master" },
	scrolling = { fullscreen_on_one_column = true },

	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},

	debug = {
		vfr = true,
	},

	input = {
		kb_layout = "us",
		follow_mouse = 1,
		sensitivity = 0,
		repeat_delay = 200,
		repeat_rate = 40,
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			scroll_factor = 1,
		},
		scroll_factor = 2,
	},
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

require("configs.windowrules")
require("configs.autostart")
require("configs.keybinds")
