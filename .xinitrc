#!/bin/bash
sh ~/.config/screenlayouts/workstation.sh
mousekeyboard # mouse keyboard settings
sxhkd & # keybinds daemon .config/sxhkd/
dunst & # notification daemon
while true
do
  status # statusbar
	sleep 20s
done &
exec dwm
