#!/bin/bash

#Date: 2017-11-02 17:51:21
#Author: created by steven.shi
#Mail: sxl_youcun@qq.com
#Function: This script function is optimize linux system.
#Version: 1.0


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
* soft nproc 65536
* hard nproc 65536
* soft nofile 65536
* hard nofile 65536
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
  service iptables stop &>/dev/null && chkconfig iptables off
  service ip6tables stop &>dev/null && chkconfig ip6tables off
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
  cron_count=`grep -w "ntpdate" "$CRON"|wc -l`
  if [[ $cron_count -lt 1 ]];then
     echo '#time sync by steven in 2017-11-03 17:48:45'>$CRON 
     echo "ntpdate $NTP_SERVER >/dev/null 2>&1" >>$CRON
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
EOF
     . $ENV_PROFILE
  fi
}

# This function is set kernel

KERNEL_FILE="/etc/sysctl.conf"
set_kernel(){
  kernel_count=`grep kernel_flag $KERNEL_FILE|wc -l`
  if [[ $kernel_count -lt 1 ]];then
     cat >>$KERNEL_FILE<<-EOF
#kernel_flag
net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_announce = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 120
net.ipv4.ip_local_port_range = 4000 65535
net.ipv4.tcp_max_syn_backlog = 20000
net.ipv4.tcp_max_tw_buckets = 50000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.core.somaxconn = 32768
net.nf_conntrack_max = 2097152 
net.ipv4.tcp_max_syn_backlog = 20000
net.netfilter.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
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
     yum install -y lrzsz tree nmap nmap-ncat dos2unix
    #yum update -y
  fi
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


main

 



}
