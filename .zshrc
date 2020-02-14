export ZSH=~/.oh-my-zsh
export TERM="xterm-256color"
export EDITOR="vim"
export PATH=$PATH:~/dotfiles/scripts
ZSH_THEME="candy"
plugins=(aws vagrant)
source $ZSH/oh-my-zsh.sh

# enable vi mode
# bindkey -v

# useful mysql function
# create database and user
function mysqlcreate() {
  [[ -z $1 ]] && echo missing argument database && return
  [[ -z $2 ]] && echo missing argument username && return
  [[ -z $3 ]] && echo missing argument password && return
  local template=~/dotfiles/scripts/templates/create.sql
  local query=$(sed -e "s/%name%/$1/g" -e "s/%user%/$2/g" -e "s/%pw%/$3/g" $template)
  mysql -e "$query"
}
# select database server usage with ~/.my.cnf.dbname
function mysqlselect() {
  [[ -z $1 ]] && echo missing argument name && return
  local file=~/.my.cnf.$1
  [[ -f $file ]] || echo $file doesnt exist.
  [[ -f $file ]] || return
  cp ~/.my.cnf ~/.my.cnf.backup
  rm ~/.my.cnf
  ln -s $file ~/.my.cnf && echo using database: $1
}
# fetch a database from online to local
function mysqlfetch() {
  [[ -z $1 ]] && echo missing argument name && return
  mysqlmigrate online local $1
}
# migrate a database from server to server
function mysqlmigrate() {
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
function mysqlhostcreate() {
  sudo sed -i -e "\$a127.0.0.1 typo3-sql.hostinghelden.at" /etc/hosts
  sudo sed -i -e "\$a127.0.0.1 magento2-sql.hostinghelden.at" /etc/hosts
}
function mysqlhostremove() {
  sudo sed -i -e "/127.0.0.1 typo3-sql.hostinghelden.at/d" /etc/hosts
  sudo sed -i -e "/127.0.0.1 magento2-sql.hostinghelden.at/d" /etc/hosts
}

# clone projects and configure it
function projectclone() {
  [[ -z $1 ]] && echo "missing argument projectname" && return
  [[ -z $2 ]] && echo "missing argument unix user" && return
  local file=/var/www/$1
  [[ -f $file ]] && echo git project does exist. && return
  git clone git@git.hostinghelden.at:$1.git $file
  chown -R $2:www-data $file
  chmod -R 775 $file
}

# create quick apache2 vhosts
function vhostcreate() {
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
function createdbfromconfig () {
  [[ -f $1 ]] || echo $1 doesnt exist.
  [[ -f $1 ]] || return
  db=$(grep -m 1 "dbname" $1 | cut -d "'" -f 4)
  user=$(grep -m 1 "user" $1 | cut -d "'" -f 4)
  pw=$(grep -m 1 "password" $1 | cut -d "'" -f 4)
  mysqlcreate $db $user $pw
}

function request_ssl() {
  [[ -z $1 ]] && echo missing argument domainname without www && return
  aws acm request-certificate --domain-name www.$1 --validation-method EMAIL --subject-alternative-names $1 --domain-validation-options DomainName=$1,ValidationDomain=$1
}

function magento2domain () {
  [[ -z $1 ]] && echo missing argument dbname && return
  [[ -z $2 ]] && echo missing argument domain && return
  mysql $1 -e "update core_config_data set value='http://$2:8082/' where path='web/unsecure/base_url'"
  mysql $1 -e 'update core_config_data set value="0" where path="web/secure/use_in_frontend"'
  mysql $1 -e 'update core_config_data set value="0" where path="web/secure/use_in_adminhtml"'
}

function magento2perms () {
  sudo find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
  sudo find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
  sudo chown -R magento2:www-data .
  sudo chmod u+x bin/magento
}

function magento2rm () {
  rm -rf var/cache/* var/view_preprocessed/* pub/static/frontend/* var/page_cache/*
}
function magento2createdb () {
  createdbfromconfig ./app/etc/env.php
}

function typo3createdb () {
  createdbfromconfig ./public/typo3conf/LocalConfiguration.php
}

function typo3createdbold () {
  createdbfromconfig ./typo3conf/LocalConfiguration.php
}

typo3sedMigrate() {
  [[ -z $1 ]] && echo missing argument name && return
  [[ -z $2 ]] && echo missing argument domain && return
  [[ -z $3 ]] && echo missing argument path && return
  capital=$(echo $1 | sed -e "s/\b\(.\)/\u\1/g")
  sed -i -e "s/Dummy/$capital/g" -e "s/dummy/$1/g" -e "s/v9.hostinghelden.at/$2/g" $3
}

typo3migrate() {
  [[ -z $1 ]] && echo missing argument name && return
  [[ -z $2 ]] && echo missing argument domain && return
  projectclone $1 typo3
  cd /var/www/$1
  mysqlhostremove
  vhostcreate $1 $2 typo3
  sudo service apache2 restart
  mysqlselect local
  old_localconf=typo3conf/LocalConfiguration.php
  user=$(grep -m 1 "user'" $old_localconf | cut -d "'" -f 4)
  pw=$(grep -m 1 "password'" $old_localconf | cut -d "'" -f 4)
  mysqlcreate $1 $user $pw
  mysqlselect onlinenew
  mysqlcreate $1 $user $pw
  mysqlfetch $1
  mysql $1 -e "rename table tx_basetemplate_carousel_item to tx_bootstrappackage_carousel_item"
  mysql $1 -e "rename table tx_basetemplate_accordion_item to tx_bootstrappackage_accordion_item"
  mysql $1 -e "rename table tx_basetemplate_tab_item to tx_bootstrappackage_tab_item"
  mysqlhostcreate
  git checkout --orphan v9
  git rm -rf .
  git remote add upstream git@git.hostinghelden.at:v9.git
  git fetch upstream
  git merge upstream/v9
  localconf=public/typo3conf/LocalConfiguration.php
  sed -i -e "s/v9.hostinghelden.at/$2/g" -e "s/v9/$1/g" -e "s/typo3user/$user/" -e "s/typo3pass/$pw/" $localconf
  mv config/sites/dummy config/sites/$1
  ext_key="$1-template"
  ext_path="packages/$ext_key/"
  cp -r packages/dummy-template $ext_path
  typo3sedMigrate $1 $2 package.json
  typo3sedMigrate $1 $2 $ext_path/composer.json
  typo3sedMigrate $1 $2 $ext_path/ext_tables.php
  typo3sedMigrate $1 $2 $ext_path/ext_emconf.php
  typo3sedMigrate $1 $2 $ext_path/ext_localconf.php
  typo3sedMigrate $1 $2 $ext_path/Configuration/TypoScript/constants.typoscript
  composer update
  ./vendor/bin/typo3cms database:updateschema
  ./vendor/bin/typo3cms upgrade:all
  ./vendor/bin/typo3cms cache:flush
}


## aliases
alias smysqldump="mysqldump --single-transaction --quick --lock-tables=false"
alias mysqlshow="ls -n ~/.my.cnf"
# git
alias gac="git add -A && git commit -am"
alias gps="git push"
alias gpl="git pull"
alias gst="git status"
alias pgp="pass git push"

# shortcuts
alias t='tail -f'
alias h="history"
alias p="sudo pacman"
alias c="clear"

# cli apps
alias m="mutt"
alias f="ranger"
alias i="weechat"
alias v="vim ."

# configs
alias ho="sudo vim /etc/hosts"

# dir shortcuts
alias www="cd /var/www/"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# pipe commands
alias -g G='| grep'
alias -g M='| more'
alias -g L='| less'
alias -g T='| tail'
alias -g H='| head'

# tmux
alias ta='tmux attach -t'
alias tnew='tmux new -s'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'

# notifications
alias notify='dunstify'

# misc
alias pwgen='openssl rand -base64 32'
alias myip='wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1'
alias decrypt='openssl aes-256-cbc -d -a'
alias encrypt='openssl aes-256-cbc -a -salt'

# server
alias sers='service apache2 restart'
alias serl='service apache2 reload'
alias sert='apachectl configtest'
