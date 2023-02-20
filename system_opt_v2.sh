#!/bin/bash

#Date: 2017-11-02 17:51:21
#Author: created by steven.shi
#Mail: sxl_youcun@qq.com
#Function: This script function is optimize linux system.
#Version: 1.0
#全局变量用大写；函数首字母大写；函数内的变量用小写。

# only root user can run script
 
[[ "UID" -ne 0 ]] && echo "This script must be root user" && exit 1

#check_user(){
#  [ $(id -u) != '0' ] && {
#  echo "Error: You must be root to run this script"
#  exit 1
#}
#}



# load system funcions

[[ -e /etc/init.d/functions ]] && . /etc/init.d/functions || { 
  echo "Functions file is not exist"
  exit 1
}

# This function is set open file numberes

ENV_FILE=/etc/security/limits.conf
SELINUX_F=/etc/selinux/config

set_env(){
 [[ -f $ENV_FILE ]] && {
 cat >> $ENV_FILE << EOF
* soft core 0
* hard core 0
* soft nofile 1048576
* hard nofile 1048576
* soft nproc 1048576
* hard nproc 1048576
* soft stack unlimited
* hard stack unlimited
EOF
echo "set $ENV_FILE success"
}                                                                                                                         
}                                                                                                                           
                                                                                                                            
#This functioin is disabled selinux

set_selinux(){                                                                                                              
  selinux_status=`getenforce`                                                                                               
  if [[ "$selinux_status" = "Disabled" ]];then                                                                              
     return 0                                                                                                               
  else                                                                                                                      
     setenforce 0                                                                                                           
     sed -i 's/^SELINUX=.*/SELINUX=disabled/' $SELINUX_F                                                                    
     #sed -i 's/SELINUX=/#SELINUX=/g' $SELINUX_F                                                                            
     #echo "SELINUX=disabled" >> $SELINUX_F                                                                                 
  fi                                                                                                                        
  echo "set selinux success"                                                                                                
}                                          

# This function is set aliyun epel
install_ali_epel(){                                                                                                         
   RETVAL=0                                                                                                                 
   release=`rpm -q centos-release | cut -d"-" -f 3`                                                                         
   if [[ "$release" -eq 6 ]];then                                                                                           
      rpm -ivh https://mirrors.aliyun.com/epel/epel-release-latest-6.noarch.rpm &>/dev/null                                 
      RETVAL=$?                                                                                                             
   elif [[ "$release" -eq 7 ]];then                                                                                         
      rpm -ivh https://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm &>/dev/null                                 
      RETVAL=$?                                                                                                             
   else                                                                                                                     
      echo "you version is not support about epel"                                                                          
   fi                                                                                                                       
   return $RETVAL                                                                                                           
}                                  

# This function is set aliyun yum

yum_clean(){
  yum clean all &>/dev/null
  yum makecache &>/dev/null
}


install_ali_yum(){                                                                                                          
  aliyun_count=`grep "aliyun" /etc/yum.repos.d/*| wc -l`                                                                    
  [[ "$aliyun_count" -ge 1 ]] && echo "you have install aliyun_yum,I will ignore it" && return 0                            
  mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup.$(date +%F) &>/dev/null                     
  release=`rpm -q centos-release | cut -d"-" -f 3`                                                                          
  if [[ "$release" -eq 6 ]];then                                                                                            
     wget -q -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo                              
     [[ "$?" -eq 0 ]] && echo "$release install aliyun yum success" || echo "$release install aliyun yum failed"            
  elif [[ "$release" -eq 7 ]];then                                                                                          
     wget -q -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo                              
     [[ "$?" -eq 0 ]] && echo "$release install aliyun yum success" || echo "$release install aliyun yum failed"            
  elif [[ "$release" -eq 5 ]];then                                                                                          
     wget -q -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-5.repo                              
     [[ "$?" -eq 0 ]] && echo "$release install aliyun yum success" || echo "$release install aliyun yum failed"            
  else                                                                                                                      
     echo "you release is wrong"                                                                                            
     exit 1                                                                                                                 
  fi                                                                                                                        
  yum_clean                                                                                                                 
}                             

# This function is set firewall

add_firewall(){
  iptables -I INPUT -p tcp -m multiport --dports 22,80 -j ACCEPT &>/dev/null
  [[ "$?" -eq 0 ]] && echo "add firewall success" || echo "add failed please check firewall"  
  service iptables save &>/dev/null
}

stop_firewall(){
  release=`rpm -q centos-release | cut -d"-" -f 3`
  if [[ $release -le 6 ]];then
    service iptables stop &>/dev/null && chkconfig iptables off
    service ip6tables stop &>dev/null && chkconfig ip6tables of
  elif [[ $release -eq 7 ]];then
    systemctl disable firewalld &>/dev/null && systemctl stop firewalld
  else 
    echo "Your version is not support"
  fi
  echo "Firewall has stoped"
}

# This function is install JDK

install_jdk(){                                                                                                                               
  rpm -qa | grep jdk >/dev/null 2>&1                                                                                                         
  [[ "$?" -eq 0 ]] && echo "you have install jdk,I will ignore it" && return 0 || {                                                          
  echo "starting install jdk!"                                                                                                                
  yum install java-1.8.0-openjdk-headless.x86_64                                                                                             
  sleep 3                                                                                                                                    
  rpm -qa | grep jdk >/dev/null 2>&1                                                                                                        
  [[ "$?" -eq 0 ]] && echo "JDK install success" && return 0 || echo "JDK install failed" && exit 1                                   
}                                                                                                                           
}   

#This function is Check whether the service is installed
 
check_install(){
  rpm -qa | grep $1 >/dev/null 2>&1
  [[ "$?" -eq 0 ]] && echo "you have install $1,I will ignore it" && return 0 || return 2
}


#This function is set least service

least_service(){
  for i in `chkconfig --list | awk '{print $1}'`
  do
    chkconfig $i off &>/dev/null 
  done 

  for i in crond sshd network rsyslog sysstat
  do
    chkconfig $i on &>/dev/null
  done
}

least_service2(){
  chkconfig --list | awk '{print "chkconfig",$1,"off"}'|bash
  chkconfig --list | egrep "crond|sshd|network|rsyslog|sysstat"| awk '{print "chkconfig",$1,"on"}'|bash
  export LANG=en
  chkconfig --list | grep 3:on
}


# This function is add user and set sudo right
USER_FILE=/etc/passwd
USER_NAME=steven
USER_PASS="hundsun@1"
SUDO_FILE=/etc/sudoers

add_user(){
  User_Count=`grep -w $USER_NAME $USER_FILE | wc -l`
  if [[ $User_Count -lt 1 ]];then
     useradd $USER_NAME
     echo "$USER_PASS" | passwd --stdin $USER_NAME
     [[ "$?" -eq 0 ]] && action "$USER_NAME add success" /bin/true || action "$USER_NAME add failed" /bin/false
  else
     echo "$USER_NAME is exist"
  fi
}

add_sudo_user(){
  User_Sudo_Count=`grep -w $USER_NAME $SUDO_FILE`
  [[ "$User_Sudo_Count" -lt 1 ]] && {
  echo "$USER_NAME  ALL=(ALL)       ALL" >>$SUDO_FILE
  tail -1 $SUDO_FILE
  visudo -c >/dev/null 2>&1
}
}

# This function is set character

set_character(){
  release=`rpm -q centos-release | cut -d"-" -f 3`
  if [[ "$release" -eq 7 ]];then
     CHAR_FILE="/etc/locale.conf"
     cp $CHAR_FILE{,.backup}
     echo "LANG=zh_CN.UTF-8">$CHAR_FILE
     source $CHAR_FILE
     action "set character success" /bin/true
  else
     CHAR_FILE="/etc/sysconfig/i18n"
     cp $CHAR_FILE{,.backup}
     echo "LANG=zh_CN.UTF-8">$CHAR_FILE
     source $CHAR_FILE
     action "set character success" /bin/true
  fi
}

# This function is set crontab for sync system time

CRON=/var/spool/cron/root
NTP_SERVER="cn.ntp.org.cn"

sync_time(){
  [[ -e $CRON ]] || touch $CRON
  cron_count=`grep -w "ntpdate" "$CRON"|wc -l`
  if [[ $cron_count -lt 1 ]];then
     echo '#time sync by steven in 2017-11-03 17:48:45'>$CRON 
     echo "0 1 * * * /usr/sbin/ntpdate $NTP_SERVER >/dev/null 2>&1" >>$CRON
     crontab -l
  else
     echo "you have set ntp sync"
     exit 0
  fi
}

# This function is set command line arguments about TMOUT、HISTSIZE、HISTFILESIZE

ENV_PROFILE="/etc/profile"
set_com_line(){
  words_count=`egrep "TMOUT|HISTSIZE|HISTFILESIZE" $ENV_PROFILE| wc -l`
  if [[ "$words_count" -lt 3 ]];then
     cat >> $ENV_PROFILE <<- EOF
export TMOUT=300
readonly TMOUT
export HISTSIZE=5000
export HISTFILESIZE=10000
export HISTTIMEFORMAT='%F %T '
ulimit -SHn 1024000
EOF
     . $ENV_PROFILE
echo "set command line success"
  fi
}

# This function is set kernel

KERNEL_FILE="/etc/sysctl.conf"
set_kernel(){
  kernel_count=`grep kernel_flag $KERNEL_FILE|wc -l`
  if [[ $kernel_count -lt 1 ]];then
     cat >>$KERNEL_FILE<<-EOF
#kernel_flag
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
#net.ipv4.tcp_tw_recycle=0 //linux kernl 4.12+ dumped
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
#net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 30
net.ipv4.ip_local_port_range = 1024 65535

net.ipv4.neigh.default.gc_thresh1=1024
net.ipv4.neigh.default.gc_thresh2=2048
net.ipv4.neigh.default.gc_thresh3=4096
vm.swappiness=0
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_instances=8192
fs.inotify.max_user_watches=1048576
fs.file-max=52706963
fs.nr_open=52706963
net.ipv6.conf.all.disable_ipv6=1
net.netfilter.nf_conntrack_max=2310720
EOF
     sysctl -p

fi

}


#This function is set sshd config

SSH_FILE="sshd_config"

set_ssh(){
  cp $SSH_FILE{,.$(date +%F)}
  sed -i 's/^#Port 22$/Port 2222/' $SSH_FILE
  sed -i 's/^#UseDNS yes$/UseDNS no/' $SSH_FILE
  sed -i 's/^#PermitRootLogin yes$/PermitRootLogin no/' $SSH_FILE
  sed -i 's/^#PermitEmptyPasswords no$/PermitEmptyPasswords no/' $SSH_FILE
  sed -i 's/^#ClientAliveInterval 0$/ClientAliveInterval 3600/' $SSH_FILE
  sed -i 's/^#ClientAliveCountMax 3$/ClientAliveCountMax 3/' $SSH_FILE
  service sshd reload &>/dev/null
}


#This function is install some tool

install_tool(){
  tool_count=`rpm -qa lrzsz tree nmap nmap-ncat dos2unix | wc -l` 
  if [[ $tool_count -lt 5 ]];then
     yum install -y vim zip unzip wget telnet lrzsz git make cmake ntpdate ntp ntsysv gcc gcc-c++ tree nmap nmap-ncat dos2unix net-tools epel-release
    #yum update -y
  fi
  echo "Tool setup ok"
}

HOST_FILE1=/etc/hosts
HOST_FILE2=/etc/sysconfig/network

Set_Hostname(){
  temp=$1
  hostname $temp
  echo "127.0.0.1 $temp" >> ${HOST_FILE1}
  echo "HOSTNAME=$temp"  > ${HOST_FILE2}
  hostnamectl set-hostname $temp 
  echo "Hostname set OK"
}


NET_DIR=/etc/sysconfig/network-scripts
#NET_DIR=/root/A

Set_Ip(){
 [[ $# -eq 0 ]] && {
   echo "Please provider the IPaddress"
   exit 4
 }
 temp=$1
 net_name=`ifconfig | awk -F: 'NR==1{print $1}'`
 net_file=${NET_DIR}/ifcfg-${net_name}
 sed -i '{s/BOOTPROTO=dhcp/BOOTPROTO=static/;s/ONBOOT=no/ONBOOT=yes/}' $net_file
 cat>>${net_file} <<EOF
IPADDR=$temp
NETMASK=255.255.255.0
GATEWAY=192.168.10.254
DNS1=192.168.1.249
DNS2=114.114.114.114
EOF
echo "Ip set ok"
}



main(){
  set_env
  set_selinux
  install_ali_epel
  install_ali_yum
  add_firewall
#  stop_firewall
  install_jdk
  least_service
#  least_service2
  add_user
  add_sudo_user
  set_character
  sync_time
  set_com_line
  set_kernel
  set_ssh
  install_tool
}


RongYi(){
echo "此脚本只适用于Centos7"
A=$1
B=$2
Set_Hostname $A
Set_Ip $B
set_selinux
stop_firewall
#install_tool
sync_time

}

#RongYi ry-test-pc 192.168.100.200

#install_tool

set_env
set_com_line

