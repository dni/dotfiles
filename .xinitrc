#!/bin/bash
sxhkd & # keybinds
xrandr --output VGA-1 --mode 1920x1200 --pos 4480x0 --rotate left --output HDMI-2 --primary --mode 1920x1080 --pos 2560x0 --rotate normal --output HDMI-1 --mode 2560x1440 --pos 0x0 --rotate normal
xinput --set-prop "Razer Razer DeathAdder" "libinput Left Handed Enabled" 1
xinput --set-prop "Razer Razer DeathAdder" "libinput Accel Profile Enabled" 0, 0
xset r rate 200 40
setxkbmap de
xmodmap -e "keysym Caps_Lock = Escape"
xmodmap -e "clear lock"
# exec i3


while true
do
  status
	sleep 20s
done &


exec dwm
