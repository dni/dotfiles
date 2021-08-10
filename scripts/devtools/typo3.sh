#!/usr/bin/env sh

typo3clone() {
  if [ -z "$1" ]; then
    echo missing argument name
    exit
  fi
  if [ -z "$2" ]; then
    echo missing argument domain
    exit
  fi
  projectclone "$1" typo3
  cd /var/www/"$1" || exit
  vhostcreate "$1" "$2" typo3
  sudo service apache2 restart
  mysqlselect local
  mysqlcreatelocal "$1"
  mysqlmigrate online local "$1"
  git checkout v9
  yarn
  composer update
  chown -R typo3:www-data /var/www/"$1"
}
