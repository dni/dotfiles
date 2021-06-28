#!/usr/bin/env sh
SPEAKER=${SPEAKER:-"Line Out"}
HEADPHONE=${HEADPHONE:-"Headphone"}
EARPIECE=${EARPIECE:-"Earpiece"}

audiodevice() {
	amixer sget "$EARPIECE" | grep -qE '\[on\]' && echo "$EARPIECE" && return
	amixer sget "$HEADPHONE" | grep -qE '\[on\]' && echo "$HEADPHONE" && return
	amixer sget "$SPEAKER" | grep -qE '\[on\]' && echo "$SPEAKER" && return
	echo "None"
}

audioout() {
  ARG="$1"
  amixer set "$SPEAKER" mute
  amixer set "$HEADPHONE" mute
  amixer set "$EARPIECE" mute

  if [ "$ARG" = "Speaker" ]; then
    amixer set "$SPEAKER" unmute
  elif [ "$ARG" = "Headphones" ]; then
    amixer set "$HEADPHONE" unmute
  elif [ "$ARG" = "Earpiece" ]; then
    amixer set "$EARPIECE" unmute
  fi
  sxmo_statusbarupdate.sh
}

audiostatus() {
	# Volume
	AUDIODEV="$(audiodevice)"
	AUDIOSYMBOL=$(echo "$AUDIODEV" | cut -c1)
	if [ "$AUDIOSYMBOL" = "L" ] || [ "$AUDIOSYMBOL" = "N" ]; then
		AUDIOSYMBOL="" #speakers or none, use no special symbol
	elif [ "$AUDIOSYMBOL" = "H" ]; then
		AUDIOSYMBOL=" "
	elif [ "$AUDIOSYMBOL" = "E" ]; then
		AUDIOSYMBOL=" " #earpiece
	fi
	VOL=0
	[ "$AUDIODEV" = "None" ] || VOL="$(
		amixer sget "$AUDIODEV" |
		grep -oE '([0-9]+)%' |
		tr -d ' %' |
		awk '{ s += $1; c++ } END { print s/c }'  |
		xargs printf %.0f
	)"
	if [ "$AUDIODEV" != "None" ]; then
		if [ "$VOL" -eq 0 ]; then
			VOLUMESYMBOL="ﱝ"
		elif [ "$VOL" -lt 25 ]; then
			VOLUMESYMBOL="奄"
		elif [ "$VOL" -gt 75 ]; then
			VOLUMESYMBOL="墳"
		else
			VOLUMESYMBOL="奔"
		fi
	fi
}

volume_notify() {
	VOL="$(
		amixer get "$(audiodevice)" |
		grep -oE '([0-9]+)%' |
		tr -d ' %' |
		awk '{ s += $1; c++ } END { print s/c }'  |
		xargs printf %.0f
	)"
	dunstify -i 0 -u normal -r 998 "♫ $VOL"
	sxmo_statusbarupdate.sh
}

volume_up() {
	amixer set "$(audiodevice)" 1+
	volume_notify
}

volume_down() {
	amixer set "$(audiodevice)" 1-
	volume_notify
}

volume_set() {
	amixer set "$(audiodevice)" "$1"
	volume_notify
}

mute() {
	audiodevice > /tmp/muted-audio.dev
	amixer set "$(cat /tmp/muted-audio.dev)" mute
	volume_notify
}

unmute() {
	amixer set "$(cat /tmp/muted-audio.dev)" unmute
	volume_notify
}
