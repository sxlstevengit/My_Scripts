#!/bin/bash
# 此脚本用来安装zabbix_agent:编译安装

ZABBIX_AGENT_CONF=/usr/local/zabbix/etc/zabbix_agentd.conf


install_zabbix_agent(){

#install Depend on the package
yum install -y curl curl-devel net-snmp net-snmp-devel perl-DB

# adduser and group
groupadd zabbix
useradd zabbix -g zabbix -s /bin/false

# make install zabbix agent
tar zxvf zabbix-3.4.4.tar.gz && cd zabbix-3.4.4
./configure --prefix=/usr/local/zabbix --enable-agent
[[ $? -eq 0 ]] && make install && echo "Install OK"  || echo "Something is wrong"

#modify config file
sed -i 's/^LogFile=.*/LogFile=\/data\/logs\/zabbix\/zabbix_agentd.log/' $ZABBIX_AGENT_CONF
sed -i 's/^Server=.*/Server=123.207.219.29/' $ZABBIX_AGENT_CONF
sed -i 's/^ServerActive=.*/ServerActive=123.207.219.29/' $ZABBIX_AGENT_CONF
sed -i 's/^Hostname=.*/#&/' $ZABBIX_AGENT_CONF
sed -i 's/^# \(HostnameItem=.*\)/\1/' $ZABBIX_AGENT_CONF
cat >> $ZABBIX_AGENT_CONF <<- EOF
LogFileSize=32
EnableRemoteCommands=1
HostMetadataItem=system.uname
UnsafeUserParameters=1
Include=/usr/local/zabbix/etc/zabbix_agentd.conf.d/*.conf
EOF

echo "Modify config is OK"


#mkdir log dir
mkdir -p /data/logs/zabbix
chmod -R 777 /data/logs

#start agent
Serv_Dir=/etc/rc.d/init.d
cd /root/src/zabbix-3.4.4
cp misc/init.d/fedora/core/zabbix_agentd $Serv_Dir
Serv_Scripts=/etc/rc.d/init.d/zabbix_agentd
sed -i 's/^\([\t]BASEDIR=\).*/\1\/usr\/local\/zabbix/' $Serv_Scripts
chmod +x $Serv_Scripts
chkconfig --add zabbix_agentd
chkconfig zabbix_agentd on
service zabbix_agentd start


}

install_zabbix_agent
