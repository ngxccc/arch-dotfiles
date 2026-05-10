local terminal = "kitty"
local fileManager = "thunar"
local tuiFileManager = "kitty -e yazi"
local menu = "rofi -show drun"
local mainMod = "SUPER"
local screen_dir = "~/pictures/screenshots/"
local timestamp = "$(date +%Y-%m-%d_%H-%M-%S).png"

-- App Launches
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal), { desc = "Launch Terminal (" .. terminal .. ")" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { desc = "Open File Manager (GUI)" })
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(tuiFileManager), { desc = "Open File Manager (TUI)" })
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu), { desc = "Open Application Launcher" })

-- Window Management & System
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { desc = "Close Focused Window" })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("~/.config/hypr/scripts/logout.sh"), { desc = "Open Logout Menu" })
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }), { desc = "Toggle Floating Mode" })
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo(), { desc = "Toggle Pseudo Mode" })

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"), { desc = "Toggle Waybar" })
hl.bind(mainMod .. " + SHIFT + SLASH", hl.dsp.exec_cmd("~/.config/hypr/scripts/hypr-keys.sh"), { desc = "Show Keybinds Help" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), { desc = "Toggle Fullscreen" })

-- Navigation (Focus) - Vim motions
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), { desc = "Focus Left Window" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), { desc = "Focus Right Window" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }), { desc = "Focus Up Window" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), { desc = "Focus Down Window" })

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { desc = "Move Window Left" })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { desc = "Move Window Right" })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { desc = "Move Window Up" })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { desc = "Move Window Down" })

hl.bind(mainMod .. " + ALT + K", hl.dsp.workspace.move({ monitor = "u" }), { desc = "Move Workspace Up" })
hl.bind(mainMod .. " + ALT + J", hl.dsp.workspace.move({ monitor = "d" }), { desc = "Move Workspace Down" })

-- Open wall picker
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/wall-picker.sh"), { desc = "Open Wallpaper Picker" })

-- Screenshots
-- hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o ~/pictures/screenshots -z"))
-- hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m window -o ~/pictures/screenshots -z"))

local notify_cmd = " && notify-send -u normal -i "

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
			.. notify_cmd
			.. screen_dir
			.. "region_"
			.. timestamp
			.. " 'Screenshot' 'Selected region saved and copied!'"
	),
	{ desc = "Screenshot Region" }
)

hl.bind(
	mainMod .. " + SHIFT + PRINT",
	hl.dsp.exec_cmd(
		'grim -g "$(hyprctl activewindow -j | jq -r \'"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])"\')" -l 0 '
			.. screen_dir
			.. "win_"
			.. timestamp
			.. notify_cmd
			.. screen_dir
			.. "win_"
			.. timestamp
			.. " 'Screenshot' 'Window screenshot saved to collection!'"
	),
	{ desc = "Screenshot Window" }
)

hl.bind(
	mainMod .. " + ALT + PRINT",
	hl.dsp.exec_cmd(
		"grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name') -l 0 "
			.. screen_dir
			.. "mon_"
			.. timestamp
			.. notify_cmd
			.. screen_dir
			.. "mon_"
			.. timestamp
			.. " 'Screenshot' 'Full screen captured!'"
	),
	{ desc = "Screenshot Full Screen" }
)
-- Zoom Shortcut
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("hyprctl keyword misc:cursor_zoom_factor 2.0"), { desc = "Zoom In" })
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("hyprctl keyword misc:cursor_zoom_factor 1.0"), { desc = "Zoom Out" })

-- Workspaces & Moving Windows to WS
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { desc = "Focus Workspace " .. i })
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { desc = "Move Window to Workspace " .. i })
end

-- Special Workspace (Scratchpad)
-- hl.bind(mainMod .. " + W", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + NEXT", hl.dsp.focus({ workspace = "e+1" }), { desc = "Focus Next Workspace" })
hl.bind(mainMod .. " + PRIOR", hl.dsp.focus({ workspace = "e-1" }), { desc = "Focus Previous Workspace" })

-- Mouse Bindings
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { desc = "Next Workspace (Mouse Scroll Down)", mouse = true })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { desc = "Previous Workspace (Mouse Scroll Up)", mouse = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, desc = "Drag Window (Left Click)" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, desc = "Resize Window (Right Click)" })

-- Media & Brightness (Fn keys)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true, desc = "Increase Volume" }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true, desc = "Decrease Volume" }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true, desc = "Toggle Mute" }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true, desc = "Toggle Microphone Mute" }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true, desc = "Increase Brightness" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true, desc = "Decrease Brightness" })

-- Player Controls
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true, desc = "Next Track" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, desc = "Play/Pause" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, desc = "Play/Pause" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true, desc = "Previous Track" })
