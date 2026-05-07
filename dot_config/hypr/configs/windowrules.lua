hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- HACK: Prevents XWayland invisible drag-drop hitboxes from blocking input events
hl.window_rule({
	name = "fix-xwayland-drags",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "blur-kitty",
	match = { class = "kitty" },
	opacity = "0.8 0.8",
})

hl.window_rule({
	match = { class = "^(rofi)$" },
	float = true,
	center = true,
	no_anim = true,
	stay_focused = true,
	border_size = 0,
	rounding = 16,
	dim_around = true,
})

hl.window_rule({
	match = { workspace = "w[tv1]" },
	border_size = 0,
	rounding = 0,
})
