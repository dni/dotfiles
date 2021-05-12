#!/bin/sh
apt-get update
apt install -y mumble-server
ufw allow 64738/tcp
ufw allow 64738/udp
dpkg-reconfigure mumble-server
cat <<EOF > /etc/mumble-server.ini
database=/var/lib/mumble-server/mumble-server.sqlite
icesecretwrite=
logfile=/var/log/mumble-server/mumble-server.log
pidfile=/var/run/mumble-server/mumble-server.pid
welcometext="<br />Hostinghelden Mumble<br />Enjoy your stay!<br />"
port=64738
serverpassword=%CHANGE PW%
bandwidth=72000
users=20
uname=mumble-server
[Ice]
Ice.Warn.UnknownProperties=1
Ice.MessageSizeMax=65536
EOF
vim /etc/mumble-server.ini
