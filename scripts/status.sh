#!/usr/bin/env sh

status_update() {
  VOL="$(pamixer --get-volume)%"
  DATE="$(date | cut -c -2) $(date +%d.%m.%Y)"
  TIME=$(date +%H:%M)

  EXTIP=$(cat ~/.cache/externalip)
  BTC=$(cat ~/.cache/btcprice)
  UPDATES=$(cat ~/.cache/updates)

  TEMP="$(($(cat /sys/class/thermal/thermal_zone0/temp) / 1000))C"
  AVAIL=$(df -h --output=avail | head -n4 | tail -n1)

  xsetroot -name " ($UPDATES) | $EXTIP | ♪ $VOL |  $TEMP |  $BTC | $AVAIL |  $DATE |  $TIME "

  #if acpi -a | grep off-line > /dev/null
  #then
  #  BAT="Bat. $(acpi -b | awk '{ print $4 " " $5 }' | tr -d ',')"
  #  xsetroot -name "$IP $BAT $VOL $TEMP $TIME"
  #else
  #  xsetroot -name "$EXTIP/$IP $VOL $TEMP $TIME"
  #fi

}

externalip() {
  IP=$(wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1)
  msg="External IP: $IP"
  notify-send "$msg"
  echo "$msg"
  echo "$IP" > ~/.cache/externalip
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
  echo "$price" > ~/.cache/btcprice
}

weather() {

  #get data and remove colors from output
  data=$(curl -s wttr.in/"$STATUS_WEATHER" | sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | cat)

  # get temp
  temp=$(echo "$data" |
    head -n 4 |
    tail -n 1 |
    sed 's/   */:/g' |
    cut -d : -f 4
  )

  # TODO: use icons for (rain|sun|cloudy|snow)
  msg="$STATUS_WEATHER: $temp"
  notify-send "$msg"
  echo "$msg"
  echo "$temp" > ~/.cache/weather # statusbar
}
