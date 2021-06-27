#!/usr/bin/env sh
sh /etc/X11/xinit/xinitrc.d/50-systemd-user.sh # gnome keyring
sh "$DOTFILES"/.config/screenlayout/workstation.sh

jackd -R -d net -a 192.168.1.192
pactl load-module module-jack-sink

#sh -ic mousekeyboard # mouse keyboard settings
sxhkd & # keybinds daemon .config/sxhkd/
dunst & # notification daemon
while true; do
  #sh -ic status_update # statusbar
	sleep 20s
done &
exec dwm
