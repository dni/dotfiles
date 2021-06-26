#!/usr/bin/env sh

# useful mysql

# export databases and manually and sieve through dbs
# mysql -e "show databases;" > dbs.txt
# mysqlcollationmigrate dbs.txt [<charset> <collation>]
# changes MySQL/MariaDB charset and collation for one database - all tables and
# all columns in all tables

mysqlcollationmigrate() {
  DBS="$1"
  CHARSET="$2"
  COLL="$3"

  [ -n "$DBS" ] || exit 1
  [ -n "$CHARSET" ] || CHARSET="utf8mb4"
  [ -n "$COLL" ] || COLL="utf8mb4_unicode_ci"

  for DB in $(cat $DBS); do
    echo $DB
    echo "ALTER DATABASE $DB CHARACTER SET $CHARSET COLLATE $COLL;" | mysql
    echo "USE $DB; SHOW TABLES;" | mysql -s | (
        while read TABLE; do
            echo $DB.$TABLE
            echo "ALTER TABLE $TABLE CONVERT TO CHARACTER SET $CHARSET COLLATE $COLL;" | mysql $DB
        done
    )
  done
}

# create database and user
 mysqlcreate() {
  [[ -z $1 ]] && echo missing argument database && return
  [[ -z $2 ]] && echo missing argument username && return
  [[ -z $3 ]] && echo missing argument password && return
  local template=~/dotfiles/scripts/templates/create.sql
  local query=$(sed -e "s/%name%/$1/g" -e "s/%user%/$2/g" -e "s/%pw%/$3/g" $template)
  mysql -e "$query"
}
 mysqlcreatelocal() {
  [[ -z $1 ]] && echo missing argument database && return
  mysql -e "create database $1 default character set utf8 default collate utf8_general_ci;"
  mysql -e "grant all privileges on $1 . * to typo3user"
}
# select database server usage with ~/.my.cnf.dbname
 mysqlselect() {
  [[ -z $1 ]] && echo missing argument name && return
  local file=~/.my.cnf.$1
  [[ -f $file ]] || echo $file doesnt exist.
  [[ -f $file ]] || return
  cp ~/.my.cnf ~/.my.cnf.backup
  rm ~/.my.cnf
  ln -s $file ~/.my.cnf && echo using database: $1
}
# fetch a database from online to local
 mysqlfetch() {
  [[ -z $1 ]] && echo missing argument name && return
  mysqlmigrate online local $1
}
# migrate a database from server to server
 mysqlmigrate() {
  [[ -f ~/.my.cnf.$1 ]] || echo "from: $1 doesnt exist."
  [[ -f ~/.my.cnf.$1 ]] || return
  [[ -f ~/.my.cnf.$2 ]] || echo "to: $2 doesnt exist."
  [[ -f ~/.my.cnf.$2 ]] || return
  [[ -z $3 ]] && echo "missing argument database" && return
  # safely dump from production database
  mysqlselect $1
  echo "safely dump $3 sql from $1"
  mysqldump --single-transaction --quick --lock-tables=false --set-gtid-purged=OFF $3 > $3.sql
  # change user in SQL STATE DEFINER
  # needed for magento2 rds, migrations
  sed -i -e "s/\`$3\`/\`hostinghelden\`/g" $3.sql
  # import production database
  mysqlselect $2
  echo "import $3 into $2 database"
  mysql $3 < $3.sql
}



# clone projects and configure it
 projectclone() {
  [[ -z $1 ]] && echo "missing argument projectname" && return
  local file=/var/www/$1
  [[ -f $file ]] && echo git project does exist. && return
  git clone git@git.hostinghelden.at:$1.git $file
  chown -R $(whoami):www-data $file
  chmod -R 775 $file
}

# create a temporary vhosts for a domain, and request a ssl certificate with
# letsencrypt certbot
 vhostssl() {
  [[ -z $1 ]] && echo "missing argument domain" && return
  sudo su
  dir=/var/www/letsencrypt
  mkdir $dir
  echo "<VirtualHost *:80>\n ServerName $1 \n DocumentRoot $dir \n</VirtualHost>" > /etc/apache2/sites-enabled/letsencrypt.conf
  service apache2 reload
  certbot certonly --webroot --text --non-interactive --email office@dnilabs.com --agree-tos -d $1 --webroot-path $dir
  rm -rf /var/www/temp
  rm /etc/apache2/sites-enabled/temp.conf
  service apache2 reload
}
# create quick apache2 vhosts
 vhostcreate() {
  [[ -z $1 ]] && echo "missing argument name" && return
  [[ -z $2 ]] && echo "missing argument domain" && return
  local template=~/dotfiles/scripts/templates/vhost.conf
  local target=/etc/apache2/sites-enabled/$1.conf
  [[ -z $3 ]] || local template=~/dotfiles/scripts/templates/vhost-typo3.conf
  [[ -f $target ]] && echo vhost does exist. && return
  sudo cp $template $target
  sudo sed -i -e "s/%name%/$1/g" -e "s/%domain%/$2/g" $target
}

# grep db, username and password from config file and create it
 createdbfromconfig () {
  [[ -f $1 ]] || echo $1 doesnt exist.
  [[ -f $1 ]] || return
  db=$(grep -m 1 "dbname" $1 | cut -d "'" -f 4)
  user=$(grep -m 1 "user" $1 | cut -d "'" -f 4)
  pw=$(grep -m 1 "password" $1 | cut -d "'" -f 4)
  mysqlcreate $db $user $pw
}

 request_ssl() {
  [[ -z $1 ]] && echo missing argument domainname && return
  aws acm request-certificate --domain-name $1 --validation-method DNS
}

 request_ssl_email() {
  [[ -z $1 ]] && echo missing argument domainname without www && return
  aws acm request-certificate --domain-name $1 --validation-method EMAIL --subject-alternative-names $1 --domain-validation-options DomainName=$1,ValidationDomain=$1
}

 typo3createdb () {
  createdbfromconfig ./public/typo3conf/LocalConfiguration.php
}

 typo3createdbold () {
  createdbfromconfig ./typo3conf/LocalConfiguration.php
}

typo3sedMigrate() {
  [[ -z $1 ]] && echo missing argument name && return
  [[ -z $2 ]] && echo missing argument domain && return
  [[ -z $3 ]] && echo missing argument path && return
  capital=$(echo $1 | sed -e "s/\b\(.\)/\u\1/g")
  sed -i -e "s/Dummy/$capital/g" -e "s/dummy/$1/g" -e "s/v9.hostinghelden.at/$2/g" $3
}

typo3clone() {
  [[ -z $1 ]] && echo missing argument name && return
  [[ -z $2 ]] && echo missing argument domain && return
  projectclone $1 typo3
  cd /var/www/$1
  vhostcreate $1 $2 typo3
  sudo service apache2 restart
  mysqlselect local
  mysqlcreatelocal $1
  mysqlmigrate online local $1
  git checkout v9
  yarn
  composer update
  chown -R typo3:www-data /var/www/$1
}

alias m2="bin/magento"
alias m2index="bin/magento indexer:reindex"
alias m2cache="bin/magento cache:clean"
alias m2setup="bin/magento setup:upgrade"
alias m2module="bin/magento module:status"
alias m2enmodule="bin/magento module:enable"
alias m2dismodule="bin/magento module:disable"
alias m2di="bin/magento setup:di:compile"
alias m2disetup="bin/magento setup:upgrade;bin/magento setup:di:compile"

m2rm() {
  setopt localoptions rmstarsilent
  rm -rf var/cache/* var/view_preprocessed/* pub/static/frontend/* var/page_cache/*
}

magento2domainlocal() {
  [[ -z $1 ]] && echo missing argument domain && return
  bin/magento config:set "web/secure/use_in_frontend" 0
  bin/magento config:set "web/secure/use_in_adminhtml" 0
  bin/magento config:set "web/unsecure/base_url" "http://dev.$1:8082/"
  bin/magento config:set "web/secure/base_url" "http://dev.$1:8082/"
}

magento2fetch() {
  [[ -z $1 ]] && echo missing argument dbname && return
  [[ -z $2 ]] && echo missing argument domain && return
  mysqlfetch $1
  magento2dblocal
  magento2domainlocal $2
  bin/magento cache:flush
}

magento2domainonline() {
  [[ -z $1 ]] && echo missing argument domain && return
  bin/magento config:set "web/secure/use_in_frontend" 1
  bin/magento config:set "web/secure/use_in_adminhtml" 1
  bin/magento config:set "web/unsecure/base_url" "https://$1/"
  bin/magento config:set "web/secure/base_url" "https://$1/"
}

magento2dblocal() {
  bin/magento setup:config:set --db-host=localhost --db-user=magentouser --db-password=magentopass
}

magento2perms () {
  sudo find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
  sudo find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
  sudo chown -R magento2:www-data .
  sudo chmod u+x bin/magento
}
magento2createdb () {
  createdbfromconfig ./app/etc/env.php
}

# magento2create initialize new magento2 store
magento2createclean(){
  [[ -z $1 ]] && echo "missing argument projectname" && return
  [[ -z $2 ]] && echo "missing argument mysql password" && return
  [[ -z $3 ]] && echo "missing argument domain" && return
  [[ -z $4 ]] && echo "missing argument admin password" && return
  composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .
  php bin/magento setup:install \
    --base-url="http://$3/" \
    --db-host="magento2-sql.hostinghelden.at" \
    --db-name="$1" \
    --db-user="$1" \
    --db-password="$2" \
    --admin-firstname="dni" \
    --admin-lastname="khr" \
    --admin-email="office@hostinghelden.at" \
    --admin-user="hostinghelden" \
    --admin-password="$4" \
    --language="de_DE" \
    --currency="EUR" \
    --timezone="Europe/Vienna" \
    --use-rewrites="1" \
    --backend-frontname="admin"
  # german translations
  composer require splendidinternet/mage2-locale-de-de
  rm -f pub/static/frontend/Magento/luma/de_DE/js-translation.json
  php bin/magento setup:static-content:deploy de_DE -f
  # firegento
  composer require firegento/magesetup2:dev-develop
  php bin/magento module:enable FireGento_MageSetup
  php bin/magento setup:upgrade
  php bin/magento magesetup:setup:run at
  php bin/magento cache:enable
}
