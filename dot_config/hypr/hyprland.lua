require("configs.env")
require("configs.autostart")
require("configs.animations")
require("configs.monitors")
require("configs.keybinds")
require("configs.windowrules")

-- Core Engine configs (Hardware/Layout states that rarely change)
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 5,
		border_size = 1,
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",

		col = {
			active_border = { colors = { "rgba(FFFFFFFF)", "rgba(888888FF)" }, angle = 45 },
			inactive_border = "rgba(313244aa)",
		},
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
			scroll_factor = 0.5,
		},
		scroll_factor = 1.5,
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = { enabled = true, range = 4, render_power = 3, color = 0xee1a1a1a },
		blur = { enabled = true, size = 3, passes = 1, vibrancy = 0.1696 },
	},
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
