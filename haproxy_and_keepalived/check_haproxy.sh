#!/bin/bash
A=`ps -C haproxy --no-header |wc -l`
if [ $A -eq 0 ];then
 #/usr/bin/systemctl start haproxy
 :
 sleep 2
 if [ `ps -C haproxy --no-header |wc -l` -eq 0 ];then
    /usr/bin/systemctl stop keepalived
 fi
fi
