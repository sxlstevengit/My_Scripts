#!/bin/bash

# 这个可以根据自己的nginx日志格式适当调整。
# 此脚本列出了两种方法，都非常实用。


#方法一:

#只统计接口的访问次数，且从多个文件中搜索
#egrep -r cloudwalk-portal XXX_202010*.log | wc -l | xargs echo "cloudwalk-portal": > result.txt

#统计该接口下面细分的接口次数,并倒序排列
egrep -r cloudwalk-portal XXX_202010*.log | awk '{print $11}' | sort | uniq -c | sort -nr > result.txt


#方法二:

#只统计接口的访问次数，且从多个文件中搜索
#awk '/game-portal/{print $11}'XXX_202010*.log | wc -l | xargs echo "game-portal": >> result.txt   

#统计该接口下面细分的接口次数,并倒序排列
awk '/game-portal/{print $11}' XXX_202010*.log | awk '{++a[$NF]}END{for(b in a )print a[b],b}' | sort -nr | awk 'BEGIN{printf "game-portal接口统计如下:\n\n"}{print $0}'>> result.txt
