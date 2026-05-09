-- WHY: Internal ThinkPad display. Forced 1:1 scale for Pixel-Perfect XWayland rendering.
hl.monitor({
	output = "eDP-1",
	mode = "1920x1200@60",
	position = "0x1080",
	scale = "1",
})

-- WHY: External LG 27EA33 display. 'auto-right' perfectly anchors at X=1920.
hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@60", -- Copy từ hyprctl monitors
	position = "0x0", -- Neo đúng tọa độ sau màn laptop (1920)
	scale = "1",
})

-- PERF: Catch-all fallback. Dynamically handles rogue projectors.
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})
