local terminal = "kitty"
local fileManager = "thunar"
local tuiFileManager = "kitty -e yazi"
local menu = "rofi -show drun"
local mainMod = "SUPER"
local screen_dir = "~/pictures/screenshots/"
local timestamp = "$(date +%Y-%m-%d_%H-%M-%S).png"

-- App Launches
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(tuiFileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))

-- Window Management & System
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("~/.config/hypr/scripts/logout.sh"))
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"))

-- Navigation (Focus) - Vim motions
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + ALT + K", hl.dsp.workspace.move({ monitor = "u" }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.workspace.move({ monitor = "d" }))

-- Open wall picker
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wall-picker.sh"))

-- Screenshots
-- hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o ~/pictures/screenshots -z"))
-- hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m window -o ~/pictures/screenshots -z"))

hl.bind(
	mainMod .. " + PRINT",
	hl.dsp.exec_cmd(
		'grim -g "$(slurp)" -l 0 '
			.. screen_dir
			.. "region_"
			.. timestamp
			.. " && wl-copy < "
			.. screen_dir
			.. "region_"
			.. timestamp
	)
)

hl.bind(
	mainMod .. " + SHIFT + PRINT",
	hl.dsp.exec_cmd(
		'grim -g "$(hyprctl activewindow -j | jq -r \'"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])"\')" -l 0 '
			.. screen_dir
			.. "win_"
			.. timestamp
	)
)

hl.bind(
	mainMod .. " + ALT + PRINT",
	hl.dsp.exec_cmd(
		"grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name') -l 0 "
			.. screen_dir
			.. "mon_"
			.. timestamp
	)
)

-- Zoom Shortcut
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("hyprctl keyword misc:cursor_zoom_factor 2.0"))
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("hyprctl keyword misc:cursor_zoom_factor 1.0"))

-- Workspaces & Moving Windows to WS
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special Workspace (Scratchpad)
-- hl.bind(mainMod .. " + W", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:magic" }))

-- Mouse Bindings
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media & Brightness (Fn keys)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Player Controls
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
