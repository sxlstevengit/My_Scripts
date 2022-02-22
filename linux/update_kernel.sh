#!/bin/bash

#红帽企业版 Linux 仓库网站 https://www.elrepo.org，主要提供各种硬件驱动（显卡、网卡、声卡等）和内核升级相关资源；
#兼容 CentOS7 内核升级。如下按照网站提示载入elrepo公钥及最新elrepo版本，然后按步骤升级内核（以安装长期支持版本 kernel-lt 为例）

HELP(){
 echo "升级内核需要重启服务器生效"
 echo "执行本脚本之前，请注意保存数据"
}

UPDATE_KERNEL(){

echo "开始升级内核"

# 载入公钥
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# 安装ELRepo
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
# 载入elrepo-kernel元数据
yum --disablerepo=\* --enablerepo=elrepo-kernel repolist
# 查看可用的rpm包
yum --disablerepo=\* --enablerepo=elrepo-kernel list kernel*
# 安装长期支持版本的kernel
yum --disablerepo=\* --enablerepo=elrepo-kernel install -y kernel-lt.x86_64
# 删除旧版本工具包
yum remove kernel-tools-libs.x86_64 kernel-tools.x86_64 -y
# 安装新版本工具包
yum --disablerepo=\* --enablerepo=elrepo-kernel install -y kernel-lt-tools.x86_64

#查看默认启动顺序
awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg  

#默认启动的顺序是从0开始，新内核是从头插入（目前位置在0，而4.4.4的是在1），所以需要选择0。
grub2-set-default 0  

cat << EOF
----------------------------------------
|***********请根据需要选择 ************|
----------------------------------------
`echo -e "\033[36m 0)立即重启\033[0m"`
`echo -e "\033[35m 1)之后重启\033[0m"`
EOF

read -p "请输入:" num
if [[ $num -eq 0 ]];then
  reboot
else
  exit 0
fi
}

HELP
UPDATE_KERNEL
