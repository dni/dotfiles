#!/usr/bin/env sh

get_sinks(){
  echo $(pamixer --list-sink | grep "^[0-9]" | awk '{print $1}')
}

volume_down() {
  get_sinks | while read -r x; do
    pamixer --sink "$x" -d 5
  done
}

volume_up() {
  get_sinks | while read -r x; do
    pamixer --sink "$x" -i 5
  done
}

volume_set() {
  [ -n "$1" ] || exit
  get_sinks | while read -r x; do
    pamixer --sink "$x" --set-volume "$1"
  done
}

mute() {
  get_sinks | while read -r x; do
    pamixer --sink "$x" -t
  done
}
