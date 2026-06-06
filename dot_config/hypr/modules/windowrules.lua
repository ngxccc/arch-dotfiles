hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
  border_size = 1,
  rounding = 0,
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
  border_size = 0,
  rounding = 0,
})

hl.window_rule({
  name = "standard-gui-floaters",
  match = {
    class = "^([Tt]hunar|nwg-look|blueman-manager|org\\.fcitx\\.fcitx5-config-qt)$",
  },
  float = true,
  center = true,
  size = "800 600",
})

hl.window_rule({
  name = "float-batctl",
  match = {
    class = "^(kitty)$",
    title = "^(batctl|impala|bluetui|pulsemixer)$",
  },
  float = true,
  center = true,
  size = "800 600",
})

hl.window_rule({
  name = "float-bitwarden",
  match = {
    class = "^(brave-.*)$",
    title = "^(_crx_nngceckbapebfimnlniiiahkandclblb)$",
  },
  float = true,
  center = true,
  size = "600 700",
})

hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },
  move = "20 monitor_h-120",
  float = true,
})

hl.window_rule({
  name = "blur-kitty",
  match = { class = "^(kitty)$" },
  opacity = "0.85 0.85",
})

hl.window_rule({
  name = "rofi-launcher",
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
})

hl.window_rule({
  match = { float = true },
  rounding = 0,
})

hl.window_rule({
  match = { fullscreen_state_internal = 1 },
  border_size = 0,
})
