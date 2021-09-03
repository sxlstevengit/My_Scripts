#!/bin/bash


#简单统计某个网站的独立IP
awk '/www.xxxx.com/{print $1}' acccess.log* | sort | uniq -c | wc -l

#单统计某个网站的PV
awk '/www.xxxx.com.cn/{print $1}' acccess.log* | wc -l

#按小时统计某个网站某天的PV.  扩展开来也可以按分钟来统计
# 先通过awk关键字提取某一天的日志，然后输出第4域即访问时间，cut取小时，然后排序，统计去重，最后按第2列小时正序排序
awk '/18\/Aug\/2021/{print $0}'lego.xxx.com-access_log | awk '{print $4}'  | cut -c 14-15 | sort | uniq -c | sort -n -k2


# 按小时统计PV，第二种方法，原理和上面一样：sed -n 只显示匹配内容 -r是支持正则， 作用就是只显示某天的日志。
sed -nr '\/18\/Aug\/2021/p' lego.xxx.com-access_log | awk '{print $4}'  | cut -c 14-15 | sort | uniq -c | sort -n -k2



# 日志格式如下:
# 121.4.148.54 - - [18/Aug/2021:23:59:01 +0800] "GET /web/index.php?s=/task/track/index HTTP/1.1" 200 - "-" "curl/7.29.0"
