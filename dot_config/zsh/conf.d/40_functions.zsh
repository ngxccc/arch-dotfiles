# ==========================================
# 40_functions.zsh - Shell Widgets & Utilities
# ==========================================

# SYNOPSIS: Open Yazi file manager and change directory on exit
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Video Compression (GPU AMD VA-API + H.265 / HEVC)
# SYNOPSIS: Compress video using AMD GPU VA-API (H.265 / HEVC) with audio
function compress-video() {
  if [ -z "$1" ]; then
    echo "Usage: compress-video <input_file.mp4> [output_file.mp4]"
    return 1
  fi
  local input="$1"
  local output="${2:-compressed_${input}}"
  ffmpeg -nostdin -vaapi_device /dev/dri/renderD128 -i "$input" -vf 'format=nv12,hwupload' -c:v hevc_vaapi -rc_mode CQP -qp 28 -c:a aac -b:a 128k "$output"
}

# SYNOPSIS: Compress video using AMD GPU VA-API (H.265 / HEVC) without audio
function compress-video-no-audio() {
  if [ -z "$1" ]; then
    echo "Usage: compress-video-no-audio <input_file.mp4> [output_file.mp4]"
    return 1
  fi
  local input="$1"
  local output="${2:-compressed_no_audio_${input}}"
  ffmpeg -nostdin -vaapi_device /dev/dri/renderD128 -i "$input" -vf 'format=nv12,hwupload' -c:v hevc_vaapi -rc_mode CQP -qp 28 -an "$output"
}

# SYNOPSIS: Quick cheatsheet lookup via fzf (Keybinding: Ctrl + Y)
function cheatsheet-finder() {
  local cheats_dir="$HOME/.config/cheatsheets"
  local selected=$(find "$cheats_dir" -type f -name "*.md" -printf "%f\n" 2>/dev/null |
    fzf --prompt="Cheatsheet > " \
      --height=80% \
      --layout=reverse \
      --border=rounded \
      --preview="cat $cheats_dir/{}" \
      --preview-window=right:65%:wrap)

  if [[ -n "$selected" ]]; then
    zle -I 2>/dev/null || true
    nvim -R "$cheats_dir/$selected"
  fi
  zle reset-prompt 2>/dev/null || true
}
zle -N cheatsheet-finder 2>/dev/null || true
bindkey '^Y' cheatsheet-finder
bindkey -M emacs '^Y' cheatsheet-finder 2>/dev/null || true
bindkey -M viins '^Y' cheatsheet-finder 2>/dev/null || true
bindkey -M vicmd '^Y' cheatsheet-finder 2>/dev/null || true
