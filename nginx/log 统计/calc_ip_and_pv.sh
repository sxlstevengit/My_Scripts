#!/bin/bash


#简单统计某个网站的独立IP
awk '/www.xxxx.com/{print $1}' acccess.log* | sort | uniq -c | wc -l

#单统计某个网站的PV
awk '/www.xxxx.com.cn/{print $1}' acccess.log* | wc -l
