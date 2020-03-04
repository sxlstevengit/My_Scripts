#!/bin/sh
APPNAME=sentinel-dashboard
JVM="${DOCKER_JAVA_JVM:--server -Xms512m -Xmx1024m -XX:MaxNewSize=256m -Dfile.encoding=utf-8 -Dsun.jnu.encoding=utf-8 -Djava.awt.headless=true}"
JAVA_OPTS="${JAVA_OPS:--Dserver.port=8080 -Dcsp.sentinel.dashboard.server=localhost:8080 -Dproject.name=sentinel-dashboard -Djava.security.egd=file:/dev/./urandom -Dcsp.sentinel.api.port=8719}"
exec $@ $JVM $JAVA_OPTS -jar /usr/local/${APPNAME:-sentinel-dashboard}/${APPNAME:-sentinel-dashboard}.jar ${OTH_OPT} || exec sleep 300
