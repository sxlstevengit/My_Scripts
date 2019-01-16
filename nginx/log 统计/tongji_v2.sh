#!/bin/bash

#此脚本用来统计nginx访问日志每分钟访问的总记录数。
#使用前请先定义变量:KEY_WORDS and TIME_RANGE
#KEY_WORDS:关键字参数
#TIME_RANGE:时间范围参数

A=$1
KEY_WORDS="\/manage\/wechat\/.*\/weixinopen"
TIME_RANGE="/10:30:00/,/11:00:00/"



USAGE(){
  echo "First of all,Please Define the variable KEY_WORDS and TIME_RANGE in scripts"
  echo "Please input the file name,just like this ./scripts filename"
  exit 0
}


if [[ $# -ne 1 ]];then
   USAGE
fi

#没有限定时间范围
#awk '/\/v1\/user\/info/{print $8}' $A | cut -c 14-18|uniq -c |sort -nr |head -10

#限制时间范围，又限制关键字
sed -nr "${KEY_WORDS}/p" $A | awk -v B=$TIME_RANGE 'B{print $8}'|cut -c 14-18 | uniq -c |sort -nr | head -20
