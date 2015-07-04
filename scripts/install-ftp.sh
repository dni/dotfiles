#!/bin/bash

echo "create mysqluser pureftpd and database pureftpd with table users before"

apt-get install pure-ftpd-mysql

echo "updating /etc/pure-ftpd/conf"
cd /etc/pure-ftpd/conf
echo yes > ChrootEveryone
echo yes > CreateHomeDir
echo 50 > MaxClientsNumber
echo 5  > MaxClientsPerIP
echo 95 > MaxDiskUsage
echo 1 > TLS
echo 117 007 > Umask
echo no > UnixAuthentication
echo no > PAMAuthentication
echo 33 > MinUID

echo "creating ssl certificate"
mkdir -p /etc/ssl/private/
openssl req -x509 -nodes -newkey rsa:1024 -keyout \
   /etc/ssl/private/pure-ftpd.pem \
    -out /etc/ssl/private/pure-ftpd.pem
chmod 600 /etc/ssl/private/*.pem

echo "/etc/pure-ftpd/db/mysql.conf edit your sql details"
