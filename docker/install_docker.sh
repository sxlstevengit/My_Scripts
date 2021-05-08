#!/bin/bash


Install_Docker() {

#Remove old docker version
yum -y remove docker docker-common docker-selinux docker-engine docker-engine-selinux container-selinux

#Add docker repo and yum-config-manager include in yum-utils
yum -y install yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#Make yum cache 生成yum缓存,增加搜索速度
yum makecache fast

#Check the available versionsi in yum
yum list docker-ce.x86_64  --showduplicates | sort -r

#Install docker-ce-17.09.0.ce-1.el7.centos same as the V8 production
yum -y install docker-ce-17.09.0.ce-1.el7.centos

#Set up the environment
mkdir -p /etc/docker/ /data/docker


#Check daemon.json 
#"graph": "/data/docker" docker data directory.

# 关于overlay2的配置项：
#"storage-driver": "overlay2",
#"storage-opts": [
#      "overlay2.override_kernel_check=true"
#    ],

#Docker local repo
#"insecure-registries": ["repo.upaiyun.com:5000"],

#Aliyun repo 官方镜像仓库加速
#"registry-mirrors": ["https://abcdefg.mirror.aliyuncs.com"],


#Start docker service
systemctl start docker
systemctl enable docker
}


Install_Docker
