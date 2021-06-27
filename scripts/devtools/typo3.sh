#!/usr/bin/env sh

typo3clone() {
  [ -n "$1" ] || echo missing argument name; return
  [ -n "$2" ] || echo missing argument domain; return
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
