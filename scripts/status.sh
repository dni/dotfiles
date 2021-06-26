#!/usr/bin/env sh

status_update() {
  VOL="$(pamixer --get-volume)%"
  DATE="$(date | cut -c -2) $(date +%d.%m.%Y)"
  TIME=$(date +%H:%M)

  EXTIP=$(cat ~/.cache/external_ip)
  BTC=$(cat ~/.cache/btc_price)
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
