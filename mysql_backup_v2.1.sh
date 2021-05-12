#!/bin/bash
#定时备份mysql数据库脚本

#定义变量
BACKUP_DIR=/data/backup
SER_IP="10.X.X.X"
PASSWD="123456"
DB_NAME="mydb"
COMMAND="/usr/local/mysql/bin/mysqldump -h ${SER_IP} -u admin -p${PASSWD} --databases ${DB_NAME} --set-gtid-purged=off"
FILENAME=${DB_NAME}.`date +%Y-%m-%d-%H-%M-%S`.sql
LOGDIR=/data/logs/${DB_NAME}

#创建目录及文件
[[ ! -e $BACKUP_DIR && ! -e $LOGDIR ]] && mkdir -p $BACKUP_DIR $LOGDIR && touch $LOGDIR/${DB_NAME}.log

#备份及打印日志
$COMMAND | gzip >$BACKUP_DIR/${FILENAME}.gz
echo "`date +%F` $DB_NAME backup OVER" >> $LOGDIR/${DB_NAME}.log

#删除30天之前的备份文件
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -exec rm -f {} \;
echo "`date +%F` Files deleted Success" >> $LOGDIR/${DB_NAME}.log

#如果需要还原命令如下，主机根据需要选择
#gunzip < test.gz | mysql -hlocalhost -uroot -pxxxxx
