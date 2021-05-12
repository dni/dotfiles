#!/bin/sh
apt-get update
apt-get upgrade
apt install vim git python3-pip build-essential wget python3-dev python3-venv \
    python3-wheel libfreetype6-dev libxml2-dev libzip-dev libldap2-dev libsasl2-dev \
    python3-setuptools node-less libjpeg-dev zlib1g-dev libpq-dev \
    libxslt1-dev libldap2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev \
    liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev

echo "creating odoo14 user"
useradd -m -d /opt/odoo14 -U -r -s /bin/bash odoo14

echo "installing postgresql and creating db user odoo14"
apt install postgresql
su - postgres -c "createuser -s odoo14"

echo "installing wkhtmltopdf"
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bionic_amd64.deb
apt install ./wkhtmltox_0.12.6-1.bionic_amd64.deb

echo "installing odoo"
su - odoo14
git clone https://www.github.com/odoo/odoo --depth 1 --branch 14.0 /opt/odoo14/odoo
cd /opt/odoo14
python3 -m venv odoo-venv
source odoo-venv/bin/activate
pip3 install wheel
pip3 install -r odoo/requirements.txt
deactivate
mkdir /opt/odoo14/odoo-custom-addons
exit

cat <<EOF > /etc/odoo14.conf
[options]
; This is the password that allows database operations:
admin_passwd = %INSERT PASSWORD%
db_host = False
db_port = False
db_user = odoo14
db_password = False
addons_path = /opt/odoo14/odoo/addons,/opt/odoo14/odoo-custom-addons
proxy_mode = True
EOF
vim /etc/odoo14.conf

echo "creating systemd service"
cat <<EOF > /etc/systemd/system/odoo14.service
[Unit]
Description=Odoo14
Requires=postgresql.service
After=network.target postgresql.service

[Service]
Type=simple
SyslogIdentifier=odoo14
PermissionsStartOnly=true
User=odoo14
Group=odoo14
ExecStart=/opt/odoo14/odoo-venv/bin/python3 /opt/odoo14/odoo/odoo-bin -c /etc/odoo14.conf
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now odoo14
systemctl status odoo14

echo "install apache2 und configure proxy"
apt install apache2
a2enmod proxy proxy_http

cat <<EOF > /etc/apache2/sites-enabled/odoo14.conf
<VirtualHost *:80>
  ServerName %INSERT DOMAIN%
  ProxyPreserveHost On
  ProxyRequests Off
  ProxyVia Off
  ProxyPass / http://localhost:8069/
  ProxyPassReverse / http://localhost:8069/
</VirtualHost>
EOF
vim /etc/apache2/sites-enabled/odoo14.conf
service apache2 reload
