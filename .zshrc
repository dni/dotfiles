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
  [[ -f $file ]] || echo $file doesnt exist. || return
  cp ~/.my.cnf ~/.my.cnf.backup && echo ~/.my.cnf.backup created
  rm ~/.my.cnf
  ln -s $file ~/.my.cnf && echo created symbolic link: $file ~/.my.cnf
}
# fetch a database from online to local
function mysqlfetch() {
  [[ -z $1 ]] && echo missing argument name && return
  [[ -f ~/.my.cnf.local ]] || echo $file doesnt exist. || return
  [[ -f ~/.my.cnf.online ]] || echo $file doesnt exist. || return
  mysqlselect online
  # safely dump from production database
  echo "safely dump $1 sql from remote..."
  mysqldump --single-transaction --quick --lock-tables=false $1 > $1.sql
  mysqlselect local
  # first backup local database
  echo "backup the local database"
  mysqldump $1 > $1.backup.sql
  # import production database
  echo "import $1 into local database"
  mysql $1 < $1.sql
}
# migrate a database from server to server
function mysqlmigrate() {
  [[ -f ~/.my.cnf.$1 ]] || echo from: $1 doesnt exist. || return
  [[ -f ~/.my.cnf.$2 ]] || echo to: $2 doesnt exist. || return
  [[ -z $3 ]] && echo missing argument database && return
  mysqlselect $1
  # safely dump from production database
  echo "safely dump $3 sql from remote..."
  mysqldump --single-transaction --quick --lock-tables=false $3 > $3.sql
  mysqlselect $2
  # first backup local database
  echo "backup the local database"
  mysqldump $3 > $3.backup.sql
  # import production database
  echo "import $3 into local database"
  mysql $3 < $3.sql
}

# clone projects and configure it
function projectclone() {
  [[ -z $1 ]] && echo missing argument projectname && return
  [[ -z $2 ]] && echo missing argument unix user && return
  local file=/var/www/$1
  [[ -f $file ]] && echo $file does exist. && return
  git clone git@git.hostinghelden.at:$1.git $file
  chown -R $2:www-data $file
  chmod -R 775 $file
}

# create quick apache2 vhosts
function vhostcreate() {
  [[ -z $1 ]] && echo missing argument name && return
  [[ -z $2 ]] && echo missing argument domain && return
  local template=~/dotfiles/scripts/templates/vhost.conf
  local target=/etc/apache2/sites-enabled/$1.conf
  [[ -f $target ]] && echo $file does exist. && return
  sudo cp $template $target
  sudo sed -i -e "s/%name%/$1/g" -e "s/%domain%/$2/g" $target
}

function magento2domain () {
  [[ -z $1 ]] && echo missing argument dbname && return
  [[ -z $2 ]] && echo missing argument domain && return
  mysql $1 -e "update core_config_data set value='http://$2:8082/' where path='web/unsecure/base_url'"
  mysql $1 -e 'update core_config_data set value="0" where path="web/secure/use_in_frontend"'
  mysql $1 -e 'update core_config_data set value="0" where path="web/secure/use_in_adminhtml"'
}

function magento2createdb () {
  local file=./app/etc/env.php
  [[ -f $file ]] || echo $file doesnt exist. || return
  db=$(grep "dbname" $file | cut -d "'" -f 4)
  user=$(grep "user" $file | cut -d "'" -f 4)
  pw=$(grep "password" $file | cut -d "'" -f 4)
  mysqlcreate $db $user $pw
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
