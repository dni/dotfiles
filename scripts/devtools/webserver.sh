#!/usr/bin/env sh

alias sers='service apache2 restart'
alias serl='service apache2 reload'
alias sert='apachectl configtest'

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
  [ -n "$1" ] || echo "missing argument domain"; return
  sudo su
  dir=/var/www/letsencrypt
  mkdir $dir
  echo "<VirtualHost *:80>\n ServerName $1 \n DocumentRoot $dir \n</VirtualHost>" > /etc/apache2/sites-enabled/letsencrypt.conf
  service apache2 reload
  certbot certonly --webroot --text --non-interactive --email office@dnilabs.com --agree-tos -d "$1" --webroot-path "$dir"
  rm -rf $dir
  rm /etc/apache2/sites-enabled/letsencrypt.conf
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

request_ssl() {
  [[ -z $1 ]] && echo missing argument domainname && return
  aws acm request-certificate --domain-name $1 --validation-method DNS
}

request_ssl_email() {
  [[ -z $1 ]] && echo missing argument domainname without www && return
  aws acm request-certificate --domain-name $1 --validation-method EMAIL --subject-alternative-names $1 --domain-validation-options DomainName=$1,ValidationDomain=$1
}
