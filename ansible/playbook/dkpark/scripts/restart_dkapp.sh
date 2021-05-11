#!/bin/bash

APPNAME=$1
APPPATH=/data/servers
source /etc/profile && jps | grep ${APPNAME} | cut -d" " -f1 | xargs kill -9 
sleep 3

PID_NUM = `ps -aux | grep -v grep  | grep ${APPNAME} | wc -l`

if [[ $PID_NUM -ne 0 ]];then
  kill -9 $PID_NUM
fi

cd ${APPPATH}/$APPNAME && ./${APPNAME}.sh
sleep 5
