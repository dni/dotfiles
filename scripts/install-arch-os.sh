#!/bin/sh
echo "dotfiles"
cd
git clone https://github.com/dni/dotfiles/
git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh

ln -s ~/dotfiles/.xinitrc ~/.xinitrc
ln -s ~/dotfiles/.config ~/.config
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

echo "init git submodule for vim"
cd dotfiles
git submodule init
git submodule update


echo "install deps"
sudo pacman -S --no-confirm firefox thunderbird dnsutils nautilus gimp libreoffice
