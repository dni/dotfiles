dotfiles
========
yeah yeah yeah
http://vüz.org/
dni's .dotfiles

# Docker
## Start Docker
boot2docker start -v
## Build new Webserver Image from Dockerfile
docker build -t server1 --no-cache .
## Start new Instance of the Webserver and launch Shell
docker run -it --name dnilabs -p 8000:80 server1 /bin/zsh
## exit from Shell
CRTL+P and CRTL-Q
## View running Instances
docker ps
## View all instances
docker ps -la
## Start a existing instance
docker start dnilabs
## Enter running Instance
docker attach dnilabs

# Rescue
## Mount Disks
mount /dev/vg0/srv /mnt
ls -ahn /mnt

## Using Hetzner Installimage
installimage

# Setup Webserver
## Ubuntu LTS
## Configure LVM
Comment out default PART, and uncomment LVM PART and LV's
## Partitions
  * LV backup /backup ext4 100G
  * LV srv /srv ext4 100G

## Run the install script
wget https://raw.githubusercontent.com/dni/dotfiles/master/.install_webserver -O - | sh
## Configure Backup Server
vim ~/backup.sh # and edit ftpuser & ftppass

