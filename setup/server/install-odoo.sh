#!/bin/sh
wkhtmlto_bin=wkhtmltox_0.12.6-1.focal_amd64.deb
wkhtmlto_url=https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb

install_odoo() {
  wget $wkhtmlto_url
  apt install -y postgresql apache2 python2 python2-dev python3-pip build-essential wget python3-dev python3-venv \
      python3-wheel libfreetype6-dev libxml2-dev libzip-dev libldap2-dev libsasl2-dev \
      python3-setuptools node-less libjpeg-dev zlib1g-dev libpq-dev \
      libxslt1-dev libldap2-dev libtiff5-dev libjpeg8-dev libopenjp2-7-dev \
      liblcms2-dev libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev \
      ./$wkhtmlto_bin

  a2enmod proxy proxy_http
  create_odoo_instance 14 8069
  create_odoo_instance 8 8068
  echo "IMPORTANT: odoo8 probably fails installing python modules"
  echo "needs more configuration with python2 and also wget https://bootstrap.pypa.io/pip/2.7/get-pip.py"
  service apache2 reload
}

create_odoo_instance() {
  version=$1
  port=$2
  user=odoo$version
  echo "creating odoo$version user"
  useradd -m -d /opt/$user -U -r -s /bin/bash $user

  echo "installing postgresql and creating db user $user"
  su - postgres -c "createuser -s $user"

  echo "installing $user"
  su $user <<EOSU
git clone https://www.github.com/odoo/odoo --depth 1 --branch $version.0 /opt/$user/odoo
cd /opt/$user
python3 -m venv $user-venv
source $user-venv/bin/activate
pip3 install wheel
pip3 install -r odoo/requirements.txt
deactivate
mkdir /opt/$user/odoo-custom-addons
EOSU

  echo "enter postgres password for $user: "
  read -r dbpass

  cat <<EOF > /etc/$user.conf
[options]
; This is the password that allows database operations:
admin_passwd = $dbpass
db_host = False
db_port = False
db_user = $user
db_password = False
addons_path = /opt/$user/odoo/addons,/opt/$user/odoo-custom-addons
proxy_mode = True
EOF

  echo "creating systemd service"

  cat <<EOF > /etc/systemd/system/$user.service
[Unit]
Description=$user
Requires=postgresql.service
After=network.target postgresql.service

[Service]
Type=simple
SyslogIdentifier=$user
PermissionsStartOnly=true
User=$user
Group=$user
ExecStart=/opt/$user/$user-venv/bin/python3 /opt/$user/odoo/odoo-bin -c /etc/$user.conf --xmlrpc-port=$port
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable --now $user
  systemctl status $user


  echo "domain for user $user: "
  read -r domain
  cat <<EOF > /etc/apache2/sites-enabled/$user.conf
<VirtualHost *:80>
  ServerName $domain
  ProxyPreserveHost On
  ProxyRequests Off
  ProxyVia Off
  ProxyPass / http://localhost:$port/
  ProxyPassReverse / http://localhost:$port/
</VirtualHost>
EOF
}

install_odoo
