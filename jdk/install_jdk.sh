#!/bin/bash
# 此脚本用于安装JDK，适合tar.gz格式的JDK包。
# 请把JDK包和此脚本放在一个目录，然后执行脚本。

JDKDIR=/usr/local/java
ENV_FILE=/etc/profile

install_jdk(){
  mkdir -p $JDKDIR
  tar -zxvf jdk-8u171-linux-x64.tar.gz -C $JDKDIR
  JdkVersion=`basename $JDKDIR/*`
  cat >> $ENV_FILE <<- EOF
JAVA_HOME=/usr/local/java/$JdkVersion
JRE_HOME=$JAVA_HOME/jre
PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
export JAVA_HOME JRE_HOME PATH CLASSPATH
EOF
  . $ENV_FILE
  java -version >/dev/null 2>&1 
  Result=$?
  [[ $Result -eq 0 ]] && echo "JDK install up" || echo "JDK install failed"
  return $Result
}

install_jdk
exit $?
