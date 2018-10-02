#!/bin/sh
# this is the arch linux install script, by dni <3
echo "install programs"
sudo pacman -S --noconfirm python-pyqt5 libffado numlockx

# change to razor mouse
xinput --set-prop 11 'libinput Left Handed Enabled' 1

# turn on numlock
numlockx on

# mount raid
sudo mkdir /mnt/raid_hdd
sudo mount /dev/md0 /mnt/raid_hdd
