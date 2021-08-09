#!/bin/bash

JAVA_HOME=/usr/local/java/jdk1.8.0_171
JRE_HOME=$JAVA_HOME/jre
PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
export JAVA_HOME JRE_HOME PATH CLASSPATH

APPNAME=dkpark-backend
JVM="-server -Xms512m -Xmx1024m -XX:MaxNewSize=256m -Dfile.encoding=utf-8 -Djava.awt.headless=true"
LOGPATH="/data/logs/apps/${APPNAME}"
cd `dirname $0`
[ ! -e $LOGPATH ] && mkdir -p $LOGPATH
[ ! -L logs ] && ln -s  $LOGPATH logs && [ -f /data/servers/${APPNAME}/${APPNAME}.jar ]  
nohup java $JVM -jar /data/servers/${APPNAME}/${APPNAME}.jar >> ${LOGPATH}/${APPNAME}.log 2>&1 &