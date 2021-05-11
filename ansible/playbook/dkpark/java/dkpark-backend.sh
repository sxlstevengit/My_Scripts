#!/bin/bash

APPNAME=dkpark-backend
JVM="-server -Xms512m -Xmx1024m -XX:MaxNewSize=256m -Dfile.encoding=utf-8 -Djava.awt.headless=true"
LOGPATH="/data/logs/apps/${APPNAME}"
[ ! -e $LOGPATH ] && mkdir -p $LOGPATH
[ ! -L logs ] && ln -s  $LOGPATH logs && [ -f /data/servers/${APPNAME}/${APPNAME}.jar ]  
nohup java $JVM -jar /data/servers/${APPNAME}/${APPNAME}.jar >> ${LOGPATH}/${APPNAME}.log 2>&1 &
