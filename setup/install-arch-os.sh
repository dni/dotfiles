#!/bin/sh
# this is the arch linux install script, by dni <3

echo "install cli programs"
sudo pacman -S --noconfirm vim zsh git htop maim dmenu dunst dnsutils pass pass-otp zbar openssh wireguard-tools sxhkd pulseaudio yay

echo "install fonts"
sudo pacman -S --noconfirm ttf-roboto ttf-droid ttf-font-awesome ttf-inconsolata

echo "install gnome programs"
sudo pacman -S --noconfirm gnome-control-center gnome-contacts gnome-calculator gnome-tweaks

echo "install gui programs"
sudo pacman -S --noconfirm firefox thunderbird nautilus libreoffice pavucontrol arandr vlc gimp inkscape fractal discord signal-desktop qtpass


echo "dotfiles"
git clone --recurse-submodules -j8 https://github.com/dni/dotfiles.git ~/dotfiles
git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
ln -s ~/dotfiles/.xinitrc ~/.xinitrc
ln -s ~/dotfiles/.config/sxhkd ~/.config/sxhkd
ln -s ~/dotfiles/.config/screenlayout ~/.config/screenlayout
ln -s ~/dotfiles/.config/fontconfig ~/.config/fontconfig
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

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

echo "rebooting..."
reboot
