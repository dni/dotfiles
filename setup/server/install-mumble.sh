#!/bin/sh
apt-get update
apt install -y mumble-server
ufw allow 64738/tcp
ufw allow 64738/udp
dpkg-reconfigure mumble-server
