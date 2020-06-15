#!/bin/bash
# This script is used to backup mysql database
# 本脚本可以排除指定的库，备份剩余的其它库。远程和本地备份选择一个即可，另外一个请注释。
# Date: 2020.06.15
# Author: created by steven.shi
# Mail: sxl_youcun@qq.com
# Version: 1.0
# 全局变量用大写；函数首字母大写；函数内的变量用小写。

BACKUP_DIR=/data/backup
SER_IP=192.168.10.74
PORT=3306
USER=root
PASS="abcd1234"
# 远程备份命令
#COMMAND="xargs mysqldump -h ${SER_IP} -P $PORT -u $USER -p$PASS --databases -f -R -E "
# 本地直接备份
COMMAND="xargs mysqldump -u $USER -p$PASS --databases -f -R -E"
FILENAME=alldatabase.`date +%Y-%m-%d-%H-%M-%S`.sql
LOG=/var/log/mysql_backup/backup.log

[[ -d $BACKUP_DIR ]] || {
mkdir -p $BACKUP_DIR
mkdir /var/log/mysql_backup
}
 
echo "`date +%Y-%m-%d-%H-%M-%S` Alldatabase backup starting " >> $LOG
#配合远程备份命令
#mysql -h $SER_IP -P $PORT -u root -p$PASS -e 'show databases;'|egrep -v 'Database|performance_schema|information_schema|mysql|sys' | $COMMAND >$BACKUP_DIR/$FILENAME
#配合本地直接备份
mysql -u root -p$PASS -e 'show databases;'|egrep -v 'Database|performance_schema|information_schema|mysql|sys' | $COMMAND >$BACKUP_DIR/$FILENAME
echo "`date +%Y-%m-%d-%H-%M-%S` Alldatabase backup OVER" >> $LOG 
