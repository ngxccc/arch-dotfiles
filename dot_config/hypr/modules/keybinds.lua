-- ZONE 1: CONSTANTS & APP REGISTRY
local mainMod = "SUPER"

local apps = {
  terminal = "kitty",
  browser = "brave",
  file_gui = "thunar",
  file_tui = "kitty -e yazi",
  launcher = "rofi -show drun",
  wall_picker = "~/.config/hypr/scripts/wall-picker.sh",
  logout = "~/.config/hypr/scripts/logout.sh",
  key_help = "~/.config/hypr/scripts/hypr-keys.sh",
}

-- Screenshot configs
local screen_dir = "~/pictures/screenshots/"
local timestamp = "$(date +%Y-%m-%d_%H-%M-%S).png"
local notify_cmd = " && notify-send -u normal -i "

-- ZONE 2: HELPER SCRIPTS
local cmd_scrot_region = string.format(
  "grim -g \"$(slurp)\" -l 0 %sregion_%s && wl-copy < %sregion_%s%s%sregion_%s 'Screenshot' 'Selected region saved and copied!'",
  screen_dir,
  timestamp,
  screen_dir,
  timestamp,
  notify_cmd,
  screen_dir,
  timestamp
)

local cmd_scrot_window = string.format(
  'grim -g "$(hyprctl activewindow -j | jq -j \'.at[0], ",", .at[1], " ", .size[0], "x", .size[1]\')" -l 0 %swin_%s && wl-copy < %swin_%s%s%swin_%s \'Screenshot\' \'Window screenshot saved and copied!\'',
  screen_dir,
  timestamp,
  screen_dir,
  timestamp,
  notify_cmd,
  screen_dir,
  timestamp
)

local cmd_scrot_monitor = string.format(
  "grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name') -l 0 %smon_%s && wl-copy < %smon_%s%s%smon_%s 'Screenshot' 'Full screen saved and copied!'",
  screen_dir,
  timestamp,
  screen_dir,
  timestamp,
  notify_cmd,
  screen_dir,
  timestamp
)

-- ZONE 3: APPLICATION LAUNCHERS
hl.bind(
  mainMod .. " + T",
  hl.dsp.exec_cmd(apps.terminal),
  { desc = "Launch Terminal (" .. apps.terminal .. ")" }
)
hl.bind(
  mainMod .. " + E",
  hl.dsp.exec_cmd(apps.file_gui),
  { desc = "Open File Manager (GUI)" }
)
hl.bind(
  mainMod .. " + SHIFT + E",
  hl.dsp.exec_cmd(apps.file_tui),
  { desc = "Open File Manager (TUI)" }
)
hl.bind(
  mainMod .. " + D",
  hl.dsp.exec_cmd(apps.launcher),
  { desc = "Open Application Launcher" }
)
hl.bind(
  mainMod .. " + B",
  hl.dsp.exec_cmd(apps.browser),
  { desc = "Open Browser" }
)
hl.bind(
  mainMod .. " + W",
  hl.dsp.exec_cmd(apps.wall_picker),
  { desc = "Open Wallpaper Picker" }
)

-- ZONE 4: WINDOW & SYSTEM MANAGEMENT
hl.bind(
  mainMod .. " + Q",
  hl.dsp.window.close(),
  { desc = "Close Focused Window" }
)
hl.bind(
  mainMod .. " + SHIFT + Q",
  hl.dsp.exec_cmd(apps.logout),
  { desc = "Open Logout Menu" }
)
hl.bind(
  mainMod .. " + SPACE",
  hl.dsp.window.float({ action = "toggle" }),
  { desc = "Toggle Floating Mode" }
)
hl.bind(
  mainMod .. " + P",
  hl.dsp.window.pseudo(),
  { desc = "Toggle Pseudo Mode" }
)
hl.bind(
  mainMod .. " + SHIFT + B",
  hl.dsp.exec_cmd("killall -SIGUSR2 waybar"),
  { desc = "Toggle Waybar" }
)
hl.bind(
  mainMod .. " + SHIFT + SLASH",
  hl.dsp.exec_cmd(apps.key_help),
  { desc = "Show Keybinds Help" }
)
hl.bind(
  mainMod .. " + SHIFT + F",
  hl.dsp.window.fullscreen(),
  { desc = "Toggle Fullscreen" }
)
hl.bind(
  mainMod .. " + F",
  hl.dsp.window.fullscreen({ mode = "maximized" }),
  { desc = "Maximize Window (Keep Taskbar)" }
)

-- ZONE 5: NAVIGATION (Vim Motions & Workspaces)
-- Focus Windows
hl.bind(
  mainMod .. " + H",
  hl.dsp.focus({ direction = "left" }),
  { desc = "Focus Left Window" }
)
hl.bind(
  mainMod .. " + L",
  hl.dsp.focus({ direction = "right" }),
  { desc = "Focus Right Window" }
)
hl.bind(
  mainMod .. " + K",
  hl.dsp.focus({ direction = "up" }),
  { desc = "Focus Up Window" }
)
hl.bind(
  mainMod .. " + J",
  hl.dsp.focus({ direction = "down" }),
  { desc = "Focus Down Window" }
)

-- Move Windows
hl.bind(
  mainMod .. " + SHIFT + H",
  hl.dsp.window.move({ direction = "l" }),
  { desc = "Move Window Left" }
)
hl.bind(
  mainMod .. " + SHIFT + L",
  hl.dsp.window.move({ direction = "r" }),
  { desc = "Move Window Right" }
)
hl.bind(
  mainMod .. " + SHIFT + K",
  hl.dsp.window.move({ direction = "u" }),
  { desc = "Move Window Up" }
)
hl.bind(
  mainMod .. " + SHIFT + J",
  hl.dsp.window.move({ direction = "d" }),
  { desc = "Move Window Down" }
)

-- Move Workspaces across Monitors
hl.bind(
  mainMod .. " + ALT + K",
  hl.dsp.workspace.move({ monitor = "u" }),
  { desc = "Move Workspace Up" }
)
hl.bind(
  mainMod .. " + ALT + J",
  hl.dsp.workspace.move({ monitor = "d" }),
  { desc = "Move Workspace Down" }
)

hl.bind(
  mainMod .. " + S",
  hl.dsp.workspace.toggle_special("magic"),
  { desc = "Toggle Scratchpad" }
)

hl.bind(
  mainMod .. " + SHIFT + S",
  hl.dsp.window.move({ workspace = "special:magic" }),
  { desc = "Move Window to Scratchpad" }
)

hl.bind(
  mainMod .. " + ALT + S",
  hl.dsp.window.move({ workspace = "e+0" }),
  { desc = "Fetch Window from Scratchpad to Current WS" }
)

-- Workspace Binding Loop
for i = 1, 10 do
  local key = i % 10
  hl.bind(
    mainMod .. " + " .. key,
    hl.dsp.focus({ workspace = i }),
    { desc = "Focus Workspace " .. i }
  )
  hl.bind(
    mainMod .. " + SHIFT + " .. key,
    hl.dsp.window.move({ workspace = i }),
    { desc = "Move Window to Workspace " .. i }
  )
end

-- Relative Workspaces
hl.bind(
  mainMod .. " + NEXT",
  hl.dsp.focus({ workspace = "e+1" }),
  { desc = "Focus Next Workspace" }
)
hl.bind(
  mainMod .. " + PRIOR",
  hl.dsp.focus({ workspace = "e-1" }),
  { desc = "Focus Previous Workspace" }
)

-- ZONE 6: MOUSE, MEDIA & HARDWARE CONTROLS
-- Mouse
hl.bind(
  mainMod .. " + mouse_down",
  hl.dsp.focus({ workspace = "e+1" }),
  { desc = "Next Workspace", mouse = true }
)
hl.bind(
  mainMod .. " + mouse_up",
  hl.dsp.focus({ workspace = "e-1" }),
  { desc = "Previous Workspace", mouse = false }
)
hl.bind(
  mainMod .. " + mouse:272",
  hl.dsp.window.drag(),
  { mouse = true, desc = "Drag Window (Left Click)" }
)
hl.bind(
  mainMod .. " + mouse:273",
  hl.dsp.window.resize(),
  { mouse = true, desc = "Resize Window (Right Click)" }
)

-- Screenshots
hl.bind(
  mainMod .. " + PRINT",
  hl.dsp.exec_cmd(cmd_scrot_region),
  { desc = "Screenshot Region" }
)
hl.bind(
  mainMod .. " + SHIFT + PRINT",
  hl.dsp.exec_cmd(cmd_scrot_window),
  { desc = "Screenshot Window" }
)
hl.bind(
  mainMod .. " + ALT + PRINT",
  hl.dsp.exec_cmd(cmd_scrot_monitor),
  { desc = "Screenshot Full Screen" }
)

-- Audio & Mic
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

-- Brightness
hl.bind(
  "XF86MonBrightnessUp",
  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),
  { locked = true, repeating = true, desc = "Increase Brightness" }
)
hl.bind(
  "XF86MonBrightnessDown",
  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),
  { locked = true, repeating = true, desc = "Decrease Brightness" }
)

-- Player Controls
hl.bind(
  "XF86AudioNext",
  hl.dsp.exec_cmd("playerctl next"),
  { locked = true, desc = "Next Track" }
)
hl.bind(
  "XF86AudioPause",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { locked = true, desc = "Play/Pause" }
)
hl.bind(
  "XF86AudioPlay",
  hl.dsp.exec_cmd("playerctl play-pause"),
  { locked = true, desc = "Play/Pause" }
)
hl.bind(
  "XF86AudioPrev",
  hl.dsp.exec_cmd("playerctl previous"),
  { locked = true, desc = "Previous Track" }
)

-- ZONE 7: ZOOM SUBMAP
local global_zoom = 1.0

local function adjust_zoom(operation)
  if operation == "*" then
    global_zoom = math.min(global_zoom * 1.1, 3.0)
  elseif operation == "/" then
    global_zoom = math.max(global_zoom / 1.1, 1.0)
  else
    global_zoom = 1.0
  end

  hl.config({ cursor = { zoom_factor = global_zoom } })
end

hl.bind(mainMod .. " + Z", function()
  hl.dispatch(hl.dsp.submap("zoom_mode"))
  hl.dispatch(
    hl.dsp.exec_cmd(
      "notify-send -t 1500 'Zoom mode' 'scroll to zoom. press E to exit.'"
    )
  )
end, { desc = "Enter Zoom Mode" })

hl.define_submap("zoom_mode", function()
  hl.bind("k", function()
    adjust_zoom("*")
  end, { repeating = true, desc = "Zoom In" })
  hl.bind("j", function()
    adjust_zoom("/")
  end, { repeating = true, desc = "Zoom Out" })

  -- hl.bind("equal", function()
  --   adjust_zoom("*")
  -- end, { repeating = true })

  -- hl.bind("minus", function()
  --   adjust_zoom("/")
  -- end, { repeating = true })

  hl.bind("0", function()
    adjust_zoom("1")
  end)

  hl.bind("e", function()
    hl.dispatch(hl.dsp.submap("reset"))
    hl.dispatch(
      hl.dsp.exec_cmd("notify-send -t 1500 'Normal mode' 'Exited Zoom Mode.'")
    )
  end)
end)
