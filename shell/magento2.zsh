alias m2="bin/magento"
alias m2index="bin/magento indexer:reindex"
alias m2cache="bin/magento cache:clean"
alias m2setup="bin/magento setup:upgrade"
alias m2module="bin/magento module:status"
alias m2enmodule="bin/magento module:enable"
alias m2dismodule="bin/magento module:disable"
alias m2di="bin/magento setup:di:compile"
alias m2disetup="bin/magento setup:upgrade;bin/magento setup:di:compile"

function m2rm() {
  setopt localoptions rmstarsilent
  rm -rf var/cache/* var/view_preprocessed/* pub/static/frontend/* var/page_cache/*
}

function magento2domainlocal() {
  [[ -z $1 ]] && echo missing argument domain && return
  bin/magento config:set "web/secure/use_in_frontend" 0
  bin/magento config:set "web/secure/use_in_adminhtml" 0
  bin/magento config:set "web/unsecure/base_url" "http://dev.$1:8081/"
  bin/magento config:set "web/secure/base_url" "http://dev.$1:8081/"
}

function magento2fetch() {
  [[ -z $1 ]] && echo missing argument dbname && return
  [[ -z $2 ]] && echo missing argument domain && return
  mysqlfetch $1
  magento2dblocal
  magento2domainlocal $2
  bin/magento cache:flush
}

function magento2domainonline() {
  [[ -z $1 ]] && echo missing argument domain && return
  bin/magento config:set "web/secure/use_in_frontend" 1
  bin/magento config:set "web/secure/use_in_adminhtml" 1
  bin/magento config:set "web/unsecure/base_url" "https://$1/"
  bin/magento config:set "web/secure/base_url" "https://$1/"
}

function magento2dblocal() {
  bin/magento setup:config:set --db-host=localhost --db-user=magentouser --db-password=magentopass
}

function magento2perms () {
  sudo find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
  sudo find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
  sudo chown -R magento2:www-data .
  sudo chmod u+x bin/magento
}
function magento2createdb () {
  createdbfromconfig ./app/etc/env.php
}

# magento2create initialize new magento2 store
function magento2createclean(){
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
