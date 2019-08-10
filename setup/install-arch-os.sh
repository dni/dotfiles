#!/bin/sh
# this is the arch linux install script, by dni <3

echo "install programs"
sudo pacman -S --noconfirm htop firefox thunderbird dnsutils nautilus gimp libreoffice pulseaudio pulseaudio-alsa pamixer pavucontrol arandr pass openssh openvpn vlc inkscape libreoffice

echo "dotfiles"
git clone --recurse-submodules -j8 https://github.com/dni/dotfiles.git ~/dotfiles
git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh

ln -s ~/dotfiles/.xinitrc ~/.xinitrc
ln -s ~/dotfiles/.config/sxhkd ~/.config/sxhkd
ln -s ~/dotfiles/screenlayouts ~/.screenlayout

rm -f ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.aliases ~/.aliases
chsh -s /bin/zsh

rm -f ~/.vimrc
rm -rf ~/.vim
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.vimrc ~/.vimrc

mkdir ~/repos

echo "install dwm"
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

echo "install st"
cd ~/repos
git clone https://git.suckless.org/st
cd st
rm config.h
ln -s ~/dotfiles/setup/st/config.h config.h
sudo make clean install

echo "install trizen (AUR)"
cd
git clone https://aur.archlinux.org/trizen.git && cd trizen && makepkg -si
cd
rm -rf trizen

reboot
