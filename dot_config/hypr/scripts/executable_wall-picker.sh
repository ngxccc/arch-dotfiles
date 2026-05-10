#!/bin/bash

set -e

WALL_DIR="$HOME/walls"

if [ ! -d "$WALL_DIR" ]; then
    notify-send -u critical "Wallpaper Error" "$WALL_DIR folder not found!"
    exit 1
fi

shopt -s nullglob nocaseglob
cd "$WALL_DIR" || exit 1

SELECTED=$(
    for file in *.{jpg,jpeg,png,gif,webp}; do
        printf "%s\0icon\x1f%s/%s\n" "$file" "$WALL_DIR" "$file"
    done | rofi -dmenu -i -show-icons -p "Wallpapers" \
        -theme-str '
        window {
            width: 70%;
            padding: 20px;
        }
        listview {
            columns: 4;
            lines: 2;
            spacing: 20px;
            flow: horizontal;
        }
        element {
            orientation: vertical;
            padding: 10px;
            border-radius: 12px;
        }
        element-icon {
            size: 14em;
        }
        element-text {
            horizontal-align: 0.5;
            vertical-align: 0.5;
        }'
)

if [ -z "$SELECTED" ]; then
    exit 0
fi

FULL_PATH="$WALL_DIR/$SELECTED"

if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 1
fi

awww img "$FULL_PATH" \
    --transition-type center \
    --transition-pos "$(hyprctl cursorpos)" \
    --transition-duration 1.2 \
    --transition-fps 60

