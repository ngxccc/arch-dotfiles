# ==========================================
# 30_aliases.zsh - Shortcuts & System Commands
# ==========================================

alias sudo='sudo '
alias vim='nvim'
alias zed='zeditor'
alias ls="eza --icons=auto"
alias ll="eza -l --icons=auto --git --header"
alias la="eza -la --icons=auto --git --header"
alias lt="eza --tree --level=2 --icons=auto"
alias cat="bat --paging=never"

# SYNOPSIS: Clean system packages and junk configs (Arch Linux)
alias sc='sysclean'

# SYNOPSIS: Start Docker daemon
alias d-up="sudo systemctl start docker.service && echo \"Docker is ON\""

# SYNOPSIS: Stop Docker daemon
alias d-down="sudo systemctl stop docker.service && echo \"Docker is OFF\""

# SYNOPSIS: Start DBX Web server
alias dbx-on="systemctl --user start dbx.service && echo 'DBX Web started: http://127.0.0.1:4224'"

# SYNOPSIS: Stop DBX Web server
alias dbx-off="systemctl --user stop dbx.service && echo 'DBX Web stopped (RAM freed)'"

# SYNOPSIS: Update DBX Web to latest GitHub release
alias dbx-up="dbx-update"

# SYNOPSIS: Fix hanging XDG Desktop Portal by masking
alias portal-nuke="systemctl --user stop xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk && systemctl --user mask xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk"

# SYNOPSIS: Restore and restart XDG Desktop Portal
alias portal-revive="systemctl --user unmask xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk && systemctl --user start xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-gnome"

# Screen Recording (wf-recorder + AMD VA-API 60fps + Audio)
# SYNOPSIS: Record screen with microphone audio
alias rec-screen='wf-recorder -a -r 60 -c h264_vaapi -d /dev/dri/renderD128 -f ~/videos/screen_$(date +%Y%m%d_%H%M%S).mp4'

# SYNOPSIS: Record screen with system audio (sink monitor)
alias rec-screen-sys='wf-recorder --audio=alsa_output.pci-0000_33_00.6.HiFi__Headphones__sink.monitor -r 60 -c h264_vaapi -d /dev/dri/renderD128 -f ~/videos/screen_sys_$(date +%Y%m%d_%H%M%S).mp4'
