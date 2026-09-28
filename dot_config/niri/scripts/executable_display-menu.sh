#!/usr/bin/env bash

options="󰍺  Extend\n󰍹  Duplicate\n󰌢  PC Screen Only\n󰍹  Second Screen Only"

choice=$(echo -e "$options" | rofi -dmenu -i -p "Display Mode" -theme-str 'window {width: 28%;} listview {lines: 4;}')

[ -z "$choice" ] && exit 0

case "$choice" in
*Duplicate*)
  killall -q wl-mirror
  niri msg output eDP-1 on
  niri msg output HDMI-A-1 on
  niri msg output HDMI-A-1 position 0 0
  niri msg output eDP-1 position 0 1080
  sleep 0.2
  wl-mirror --fullscreen-output HDMI-A-1 eDP-1 &
  ;;
*Extend*)
  killall -q wl-mirror
  niri msg output eDP-1 on
  niri msg output HDMI-A-1 on
  niri msg output HDMI-A-1 position 0 0
  niri msg output eDP-1 position 0 1080
  ;;
*PC*)
  killall -q wl-mirror
  niri msg output HDMI-A-1 off
  niri msg output eDP-1 on
  niri msg output eDP-1 position 0 0
  ;;
*Second*)
  killall -q wl-mirror
  niri msg output eDP-1 off
  niri msg output HDMI-A-1 on
  niri msg output HDMI-A-1 position 0 0
  ;;
esac
