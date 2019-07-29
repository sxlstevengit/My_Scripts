#!/bin/bash
BACKUP_DIR=/data/OA_Backup
SER_IP="10.99.3.14"
COMMAND="/usr/local/mysql/bin/mysqldump -h ${SER_IP} --set-gtid-purged=OFF -u XXX -pXXXXXXX --databases ryoa -R"
FILENAME=ryoa.`date +%Y-%m-%d-%H-%M-%S`.sql
LOG=/var/log/ryoa_backup/ryoa.log

$COMMAND | gzip >$BACKUP_DIR/${FILENAME}.gz

#如果需要还原:
#gunzip < test.gz |mysql -hlocalhost -uroot -pxxxxx

#Linux压缩保留源文件的方法：
#gzip –c filename > filename.gz
#Linux解压缩保留源文件的方法：
#gunzip –c filename.gz > filenam

echo "`date +%F` RYOA DB backup OVER" >> $LOG 



