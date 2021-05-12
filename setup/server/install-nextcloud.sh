#!/bin/sh

apt install -y apache2 php zip libapache2-mod-php \
  php-gd php-json php-mysql php-curl php-mbstring php-intl php-imagick php-xml php-zip php-mysql php-bcmath php-gmp

mkdir /var/www/nextcloud
#cd /var/www/nextcloud
#wget https://download.nextcloud.com/server/releases/latest.zip
#unzip latest.zip
chown -R www-data:www-data /var/www/nextcloud

cat <<EOF > /etc/apache2/sites-enabled/nextcloud.conf
<VirtualHost *:80>
  ServerName DOMAIN
  Redirect 301 / https://DOMAIN/
</VirtualHost>

<VirtualHost *:443>
  SSLCertificateFile /etc/letsencrypt/live/DOMAIN/fullchain.pem
  SSLCertificateKeyFile /etc/letsencrypt/live/DOMAIN/privkey.pem
  Include /etc/letsencrypt/options-ssl-apache.conf
  ServerName DOMAIN
  DocumentRoot /var/www/nextcloud
</VirtualHost>

## USAGE FOR GETTING CERTIFICATE
#<VirtualHost *:80>
#  ServerName DOMAIN
#  DocumentRoot /var/www/nextcloud
#</VirtualHost>
EOF
vim /etc/apache2/sites-enabled/nextcloud.conf

echo "mount /dev/sdg /var/www/nextcloud"
echo "dont forget fstab"
