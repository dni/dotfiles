ftpUser=
ftpPass=

if [ -z "$1" ]
then
  echo "One argument is required, add for example daily, weekly, monthly ..."
  exit
else
  echo "Starting "$1" backup at $(date)"
fi

## create directorys
echo "create directorys"
mkdir -p /backup/$1

## backup databases
echo "backup databases"
mysqldump --defaults-extra-file=/root/.my.cnf --events --ignore-table=mysql.event --all-databases > /backup/$1/dump.sql

# Dump POSTGRES databases
# touch /backup/$1/pgdump.dump
# chown postgres:postgres /backup/$1/pgdump.dump
# su - postgres -c "pg_dumpall > /backup/$1/pgdump.dump"

## tar.gz folders
echo "tar.gz folders"
tar -pczf /backup/$1/backup.tar.gz /srv /opt /var /etc
tar -pczf /backup/$1.tar.gz /backup/$1

# create folder and upload backup to remote-ftp
echo "create folder and upload backup to remote-ftp user: $ftpUser"
ftp -i -n $ftpUser.your-backup.de <<END_SCRIPT
quote USER $ftpUser
quote PASS $ftpPass
put /backup/$1.tar.gz $1.tar.gz
END_SCRIPT
