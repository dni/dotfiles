#!/bin/sh
apt-get update
apt-get upgrade

fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

apt install vim zsh tmux htop
