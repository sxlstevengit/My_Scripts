#!/bin/bash
# This script is used to analyze nginx log 9:00-10:30 interface /v1/usr/info access
# 也就是9:00-10:30时间范围内，每分钟访问/v1/usr/info接口的次数。

A=$1

USAGE(){
  echo "Please input the file name,just like this ./scripts filename"
  exit 0
}


if [[ $# -ne 1 ]];then
   USAGE
fi

#没有限定时间范围
#awk '/\/v1\/user\/info/{print $8}' $A | cut -c 14-18|uniq -c |sort -nr > result.txt

#限制时间范围，又限制关键字
sed -n '/\/v1\/user\/info/p' $A | awk '/09:00:00/,/10:31:00/{print $8}'|cut -c 14-18|uniq -c |sort -nr >result.txt  


