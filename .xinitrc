xset r rate 200 40
setxkbmap -option caps:escape
xinput --set-prop 9 'libinput Accel Speed' -0.5
xmodmap -e "pointer =  3 2 1 4 5 6 7"
exec i3
