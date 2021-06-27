#!/usr/bin/env sh
sinks=$(pamixer --list-sink | grep "^[0-9]" | awk '{print $1}')

volume_down() {
  echo "$sinks" | while read -r x; do
    pamixer --sink "$x" -d 5
  done
}

volume_up() {
  echo "$sinks" | while read -r x; do
    pamixer --sink "$x" -i 5
  done
}

volume_set() {
  [ -n "$1" ] || exit
  echo "$sinks" | while read -r x; do
    pamixer --sink "$x" --set-volume "$1"
  done
}

mute() {
  echo "$sinks" | while read -r x; do
    pamixer --sink "$x" -t
  done
}
