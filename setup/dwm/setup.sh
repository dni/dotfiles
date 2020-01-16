#!/bin/sh
cd ~/repos
git clone https://git.suckless.org/dwm
cd dwm
wget https://dwm.suckless.org/patches/fibonacci/dwm-fibonacci-5.8.2.diff
git apply dwm-fibonacci-5.8.2.diff
wget https://dwm.suckless.org/patches/centeredmaster/dwm-centeredmaster-6.1.diff
git apply dwm-centeredmaster-6.1.diff
rm config.h
ln -s ~/dotfiles/setup/dwm/config.h config.h
sudo make clean install
