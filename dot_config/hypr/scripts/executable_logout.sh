#!/bin/bash
choice=$(echo -e "󰐥  Power Off\n󰜉  Reboot\n󰌾  Lock\n󰍃  Logout\n󰒲  Suspend" | rofi -dmenu -i -p "Logout?" -theme-str 'window {width: 20%;} listview {lines: 5;}')

case "$choice" in
*Suspend*) systemctl suspend ;;
*Reboot*) systemctl reboot ;;
*Power*) systemctl poweroff ;;
*Lock*) hyprlock ;;
*Logout*)
    if [ "$XDG_CURRENT_DESKTOP" = "niri" ]; then
        niri msg action quit --skip-confirmation
    else
        uwsm stop
    fi
    ;;
esac
