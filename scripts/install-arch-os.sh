#!/bin/sh

echo "git config"
git config --global user.email "dni.khr@gmail.com"
git config --global user.name "dni"

echo "dotfiles"
git clone --recurse-submodules -j8 https://github.com/dni/dotfiles/ ~/dotfiles
git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh

ln -s ~/dotfiles/.xinitrc ~/.xinitrc
ln -s ~/dotfiles/.config/termite ~/.config/termite
ln -s ~/dotfiles/.config/i3/config ~/.config/i3/config
ln -s ~/dotfiles/.config/i3/i3status.conf ~/.i3status.conf

mkdir ~/.fonts
cp ~/dotfiles/Monaco\ for\ Powerline.otf ~/.fonts

rm -f ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.aliases ~/.aliases
chsh -s /bin/zsh

rm -f ~/.vimrc
rm -rf ~/.vim
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.vimrc ~/.vimrc

echo "install programs"
sudo pacman -S --noconfirm htop firefox thunderbird dnsutils nautilus gimp libreoffice pulseaudio pulseaudio-alsa pavucontrol arandr pass openssh openvpn

reboot
