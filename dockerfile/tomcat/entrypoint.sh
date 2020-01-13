#!/bin/sh
#
# cp jar application.yaml
mkdir -p /data/servers/${APPNAME:-ops} && cp -f /data/apps/${APPNAME:-ops}/*.jar /data/servers/${APPNAME:-ops}/

#env config
JVM="${DOCKER_JAVA_JVM:--server -Xms512m -Xmx1024m -XX:MaxNewSize=256m -Dfile.encoding=utf-8 -Dsun.jnu.encoding=utf-8 -Djava.awt.headless=true}"
LOGPATH="/data/logs/apps/${APPNAME:-ops}"
[ -d $LOGPATH -a ! -f logs ] && ln -s $LOGPATH logs && \
exec $@ $JVM -jar /data/servers/${APPNAME:-ops}/${APPNAME:-ops}.jar --server.port=${SERVER_PORT:-8090} ${OTH_OPT} || exec sleep 300
