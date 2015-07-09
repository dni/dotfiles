ftpUser=u61410
ftpPass=xVxoiC4v4Djvxcs0

if [ -z "$1" ]
then
  echo "One argument is required, add for example daily, weekly, monthly ..."
  exit
else
  echo "Starting "$1" backup  at $(date)"
fi


## create directorys
echo "create directorys"
mkdir -p /backup/$1

## backup databases
echo "backup databases"
mysqldump --defaults-extra-file=/root/.my.cnf --events --ignore-table=mysql.event --all-databases > /backup/$1/dump.sql

# Dump-pg-databases
# touch /backup/$1/pgdump.dump
# chown postgres:postgres /backup/$1/pgdump.dump
# su - postgres -c "pg_dumpall > /backup/$1/pgdump.dump"

## tar.gz folders
echo "tar.gz folders"
tar -pczf /backup/$1/backup.tar.gz /srv /opt /var /etc

# create folder and upload backup to remote-ftp
echo "create folder and upload backup to remote-ftp " \'$ftpUser\'
ftp -i -n $ftpUser.your-backup.de <<END_SCRIPT
quote USER $ftpUser
quote PASS $ftpPass
binary
cd /
mkdir $1
cd $1
PUT /backup/$1/dump.sql
PUT /backup/$1/backup.tar.gz
quit
END_SCRIPT

