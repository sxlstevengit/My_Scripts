#!/bin/bash
LOG=/var/log/backup/mysql_synch.log
echo "==========start in "`date "+%Y-%m-%d %H:%M:%S"`>> $LOG
/usr/local/bin/rsync -vazu --progress /data/mysqlbackup/  rsync@172.18.207.122::mysql  --password-file=/etc/rsyncd/password.secret>>$LOG
echo "==========end in "`date "+%Y-%m-%d %H:%M:%S"`>> $LOG
echo "">> $LOG
