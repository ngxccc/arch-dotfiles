#!/bin/bash

set -e
THEME_NAME=$1

if [ -z "$THEME_NAME" ]; then
    echo "Usage: $0 <theme_name> (e.g., porsche, catppuccin)"
    exit 1
fi

THEME_DIR="$HOME/.config/themes/$THEME_NAME"

if [ ! -d "$THEME_DIR" ]; then
    notify-send -u critical "Lỗi" "Theme $THEME_NAME không tồn tại!"
    exit 1
fi

ln -sf "$THEME_DIR/waybar.css" "$HOME/.config/waybar/current_theme.css"
ln -sf "$THEME_DIR/swaync.css" "$HOME/.config/swaync/current_theme.css"
ln -sf "$THEME_DIR/gtk-3.0.css" "$HOME/.config/gtk-3.0/current_theme.css"
ln -sf "$THEME_DIR/kitty.conf" "$HOME/.config/kitty/current_theme.conf"
ln -sf "$THEME_DIR/rofi.rasi" "$HOME/.config/rofi/current_theme.rasi"

# 1. Reload Waybar
killall -SIGUSR2 waybar
pkill -USR1 -x kitty
swaync-client -rs
# 3. Reload Hyprland
hyprctl reload

