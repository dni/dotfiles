#!/usr/bin/env sh

# populate ./bin/ with symlink to the magic run_function script
create_binaries() {
  rm "$DOTFILES"/bin/*
  sh -ic "declare -F" | sed "s/declare -f//g" | while read -r x; do
    ln -sf "$DOTFILES"/scripts/run_function "$DOTFILES"/bin/"$x"
  done
}

check_update() {
  sudo pacman -Sy
  sudo pacman -Qu | wc -l > ~/.updates
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

externalip() {
  IP=$(wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1)
  msg="External IP: $IP"
  notify-send "$msg"
  echo "$msg"
  echo "$IP" > ~/.cache/.external_ip
}

upload() {
  [ -n "$1" ] || echo "$1" doesnt exist.
  [ -n "$1" ] || return
  aws s3 cp "$1" s3://dnilabs-hostinghelden/upload/
  echo "https://d261tqllhzwogc.cloudfront.net/upload/$1"
}

btcprice() {
  #get data and remove colors from output
  data=$(curl -s rate.sx/\?n=1 |
    sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | cat)

  price=$(echo "$data" |
    tail -n 6 |
    head -n 1 |
    cut -d " " -f 10
  )

  msg=$(echo "$data" |
    head -n 9 |
    tail -n 3
  )

  msg="$msg

   $price"

  dunstify "$msg"
  echo "$msg"
  echo "$price" > ~/.btc_price
}

weather() {
  # TODO: not hardcore city
  city="wels"

#get data and remove colors from output
data=$(curl -s wttr.in/$city |
  sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | cat)

# get temp
temp=$(echo "$data" |
  head -n 4 |
  tail -n 1 |
  sed 's/   */:/g' |
  cut -d : -f 4
)

# TODO: use icons for (rain|sun|cloudy|snow)
msg="$city: $temp"
notify-send "$msg"
echo "$msg"
echo "$temp" > ~/.weather # statusbar

}
