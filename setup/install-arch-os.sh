#!/bin/sh
# this is the arch linux install script, by dni <3

echo "install programs"
sudo pacman -S --noconfirm htop maim dmenu ttf-roboto ttf-droid ttf-font-awesome ttf-inconsolata libnotify dunst firefox thunderbird dnsutils nautilus gimp libreoffice pulseaudio pulseaudio-alsa pamixer pavucontrol arandr pass pass-otp zbar openssh wireguard-tools vlc inkscape sxhkd

echo "dotfiles"
git clone --recurse-submodules -j8 https://github.com/dni/dotfiles.git ~/dotfiles
git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh

ln -s ~/dotfiles/.xinitrc ~/.xinitrc
ln -s ~/dotfiles/.config/sxhkd ~/.config/sxhkd
ln -s ~/dotfiles/.config/screenlayout ~/.config/screenlayout
ln -s ~/dotfiles/.config/fontconfig ~/.config/fontconfig

rm -f ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.aliases ~/.aliases
chsh -s /bin/zsh

rm -f ~/.vimrc
rm -rf ~/.vim
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.vimrc ~/.vimrc

mkdir ~/repos

echo "build dwm"
sh ~/dotfiles/setup/dwm/setup.sh

echo "build st"
sh ~/dotfiles/setup/st/setup.sh

echo "install trizen (AUR)"
cd
git clone https://aur.archlinux.org/trizen.git && cd trizen && makepkg -si
cd
rm -rf trizen

echo "rebooting..."
reboot
