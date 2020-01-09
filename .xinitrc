#!/bin/bash
# xrandr --output VGA-1 --mode 1920x1200 --pos 4480x0 --rotate left --output HDMI-2 --primary --mode 1920x1080 --pos 2560x0 --rotate normal --output HDMI-1 --mode 2560x1440 --pos 0x0 --rotate normal
#sh ~/.screenlayout/singlescreen.sh
mousekeyboard # mouse keyboard settings
sxhkd & # keybinds daemon .config/sxhkd/
dunst & # notification daemon
while true
do
  status # statusbar
	sleep 20s
done &
exec dwm
