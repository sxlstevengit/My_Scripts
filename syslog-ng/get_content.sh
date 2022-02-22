#!/bin/bash
# 此脚本用于生成java模块日志合并的内容。
# author:sxl_youcun@qq.com

name=$1
info_port=$2
error_port=$(($2+1))
warn_port=$(($2+2))
temp_name=$(echo $name | sed 's/-/_/g')


Usage(){
  echo "使用方法：./get_content.sh 模块名称 端口号"
  echo "端口号获取：请从配置文件syslog-ng.conf中JAVA模块部分获取最大的端口号,然后最大端口号+1，做为此脚本第二个参数"
  exit 1 
}

if [[ $# -ne 2 ]]
  then
     Usage
else
  echo "OK, 开始处理"
fi


if [[ $name =~ "-" ]]
  then
    sed  's/precision_marketing_server/'"$temp_name"'/g;s/precision-marketing-server/'"$name"'/g;s/180/'"$info_port"'/g;s/181/'"$error_port"'/g;s/182/'"$warn_port"'/g' template.txt
else
    sed  's/precision_marketing_server/'"$name"'/g;s/precision-marketing-server/'"$name"'/g;s/180/'"$info_port"'/g;s/181/'"$error_port"'/g;s/182/'"$warn_port"'/g' template.txt
fi
