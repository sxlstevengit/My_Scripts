#!/usr/bin/env bash
beip=$1
port=22
user=$(whoami)
if [ -d ~/.ssh ] && [ -f id_rsa ] && [ -f id_rsa.pub ];then
    echo have dir and file;
else
     mkdir ~/.ssh ;
    ssh-keygen -t rsa;
fi
#上传到主机上
ssh-copy-id -i ~/.ssh/id_rsa.pub -p ${port} ${user}@${beip}

