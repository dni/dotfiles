#!/bin/sh
apt-get update
apt-get upgrade
apt install vim zsh tmux htop

fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile    none    swap    sw    0   0" >> /etc/fstab
