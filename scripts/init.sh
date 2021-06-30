#!/usr/bin/env sh

# xinit hook
xinit_hook() {
  sh /etc/X11/xinit/xinitrc.d/50-systemd-user.sh # gnome keyring
  sh "$DOTFILES"/.config/screenlayout/workstation.sh
  [ -e "$HOME"/.fehbg ] && sh "$HOME"/.fehbg & # background
  jackd -R -d net -a 192.168.1.192
  pactl load-module module-jack-sink
  mousekeyboard # mouse keyboard settings
}

mousekeyboard() {
  xinput --set-prop "Razer Razer DeathAdder" "libinput Left Handed Enabled" 1
  xinput --set-prop "Razer Razer DeathAdder" "libinput Accel Profile Enabled" 0, 0
  xset r rate 200 40
  setxkbmap de
  xmodmap -e "keysym Caps_Lock = Escape"
  xmodmap -e "clear lock"
  numlockx
}
