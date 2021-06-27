#!/usr/bin/env sh
xinit_hook # defined in script/utils.sh
sxhkd & # keybinds daemon .config/sxhkd/
dunst & # notification daemon
while true; do
  status_update # statusbar
	sleep "$STATUS_INTERVAL"
done &
exec dwm
