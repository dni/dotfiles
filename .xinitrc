#!/usr/bin/env sh
#source /etc/profile.d/dni.sh
xinit_hook & # defined in script/utils.sh
sxhkd & # keybinds daemon .config/sxhkd/
dunst & # notification daemon
compton & # composite manager
firefox &
thunderbird &
discord &
signal-desktop &
telegram-desktop &
while true; do
  status_update # statusbar
	sleep "$STATUS_INTERVAL"
done &
exec dwm
