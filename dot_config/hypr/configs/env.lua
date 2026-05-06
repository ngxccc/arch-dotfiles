hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
-- WHY: Forces modern UI toolkits to strictly use Wayland backend, falling back to X11 only if necessary
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- PERF: Identifies the session for desktop portals (fixes screen sharing issues)
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- WHY: Injects the Input Method framework into standard toolkit pipelines
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("SDL_IM_MODULE", "fcitx")

-- HACK: Kitty terminal explicitly requires ibus fallback to process fcitx5 events on Wayland
hl.env("GLFW_IM_MODULE", "ibus")

hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
