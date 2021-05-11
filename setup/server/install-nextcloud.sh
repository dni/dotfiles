#!/bin/sh

# install nextcloud on ubuntu
sudo apt-get install apache2 mysql-server -y
sudo apt-get install php zip libapache2-mod-php php-gd php-json php-mysql php-curl php-mbstring php-intl php-imagick php-xml php-zip php-mysql php-bcmath php-gmp -y
sudo mysql_secure_installation
sudo mysql -u root -p < "CREATE DATABASE nextcloud;CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'nextcloud'; GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost'; FLUSH PRIVILEGES;"
wget https://download.nextcloud.com/server/releases/latest.zip
unzip latest.zip
