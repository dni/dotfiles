#!/bin/sh
# this is the arch linux install script, by dni <3

echo "install programs"
sudo pacman -S --noconfirm git vim zsh tmux htop pass openssh wireguard-dkms wireguard-tools resolvconf

echo "dotfiles"
git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh

rm -f ~/.zshrc
rm -f ~/.aliases
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.aliases ~/.aliases
chsh -s /bin/zsh

rm -f ~/.vimrc
rm -rf ~/.vim
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.vimrc ~/.vimrc

mkdir ~/repos
mkdir .ssh
touch .ssh/authorized_keys

echo "add pub key to .ssh/authorized_keys and disable PasswordAuth in /etc/ssh/sshd_config"
echo "change pin of phone with passd"

# SETUP WIREGUARD
# install-wireguard.sh on server to get client keys
# move client_pub.key client_priv.key to /etc/wireguard/
# also rename client.conf to wg0.conf
# sudo wg-quick up wg0

# enable on bootup
# systemctl enable wg-quick@wg0
