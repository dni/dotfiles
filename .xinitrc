xset r rate 200 40
setxkbmap de
xmodmap -e "keysym Caps_Lock = Escape"
xmodmap -e "clear lock"
exec i3
