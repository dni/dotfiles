#!/bin/sh
apt-get update
apt-get upgrade
apt install git
adduser git
which git-shell >> /etc/shells
chsh git -s $(which git-shell)
echo "mount /dev/sdf /home/git"
echo "genfstab > /etc/fstab"
