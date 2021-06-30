#!/usr/bin/env sh

get_sinks(){
  echo $(pamixer --list-sink | grep "^[0-9]" | awk '{print $1}')
}

volume_command(){
  for x in $(get_sinks); do
    pamixer --sink "$x" "$@"
  done
}

volume_down() {
  volume_command -d 5
}

volume_up() {
  volume_command -i 5
}

volume_set() {
  [ -n "$1" ] || exit
  volume_command --set-volume "$1"
}

mute() {
  volume_command -t
}
