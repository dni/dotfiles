#!/bin/sh
cd ~/repos
git clone https://git.suckless.org/st
cd st
rm config.h
ln -s ~/dotfiles/setup/st/config.h config.h
sudo make clean install
