#!/usr/bin/env sh

# xinit hook
xinit_hook() {
  sh /etc/X11/xinit/xinitrc.d/50-systemd-user.sh # gnome keyring
  sh "$DOTFILES"/.config/screenlayout/workstation.sh
  jackd -R -d net -a 192.168.1.192
  pactl load-module module-jack-sink
  mousekeyboard # mouse keyboard settings
}

get_functions() {
  retval=$(sh -ic "declare -F" | sed "s/declare -f//g")
  echo "$retval"
}

# populate ./bin/ with symlink to the magic run_function script
create_binaries() {
  rm "$DOTFILES"/bin/*
  get_functions | while read -r x; do
    ln -sf "$DOTFILES"/scripts/run_function "$DOTFILES"/bin/"$x"
  done
}

check_update() {
  sudo pacman -Sy
  sudo pacman -Qu | wc -l > ~/.cache/updates
  dunstify "$(cat ~/.updates) updates available"
}

screenshot() {
  maim -s ~/Screenshots/screenshot-"$(date +%s)".jpg
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

upload() {
  [ -n "$1" ] || echo "$1" doesnt exist.
  [ -n "$1" ] || return
  aws s3 cp "$1" s3://dnilabs-hostinghelden/upload/
  echo "https://d261tqllhzwogc.cloudfront.net/upload/$1"
}
