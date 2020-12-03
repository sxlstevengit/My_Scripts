#!/bin/bash

#此脚本用于查看容器镜像的dockerfile命令

USAGE(){
  echo "请这样使用: sh show_image_dockerfile.sh 你的容器镜像名称"
}

if [ $# -eq 1 ];then
        docker history --format {{.CreatedBy}} $1 --no-trunc | sed 's?/bin/sh -c #(nop)??g' | tac
    else
        USAGE
fi
