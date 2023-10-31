﻿#!/bin/bash

#此脚本用来统计nginx访问日志某个时间段每分钟访问的总记录数。
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


#过滤时间范围内nginx的日志，-F'\\[| ' 表示以[和空格做为分隔符; $5 >= "30/Oct/2023:14:27:00" && $5 <= "30/Oct/2023:14:44:00" 表示第5域在时间2023.10.30 14:27分和14:44之间。
awk -F'\\[| ' '$5 >= "30/Oct/2023:14:27:00" && $5 <= "30/Oct/2023:14:44:00" {print $0}' adc.abc.com.log 

