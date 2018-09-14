#!/bin/bash
BACKUP_DIR=/data/mysqlbackup
COMMAND="/usr/local/mysql/bin/mysqldump -uroot -pXXXXXXX --all-databases" 
FILENAME=all_hailan.`date +%Y-%m-%d-%H-%M-%S`.sql
LOG=/var/log/hailandb_backup/hailan.log

$COMMAND >$BACKUP_DIR/$FILENAME

echo "`date +%F` Hailan DB backup OVER" >> $LOG 



