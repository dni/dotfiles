#!/usr/bin/env sh

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

mysqlcollationmigrate() {
  # export databases and manually and sieve through dbs
  # mysql -e "show databases;" > dbs.txt
  # mysqlcollationmigrate dbs.txt [<charset> <collation>]
  # changes MySQL/MariaDB charset and collation for one database - all tables and
  # all columns in all tables
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
