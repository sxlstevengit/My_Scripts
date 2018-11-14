#!/bin/bash

APP_DIR=/root/src
ZK_DIR=/usr/local/zookeeper
SER1="10.40.0.10"
SER2="10.40.0.11"
SER3="10.40.0.12"

Install_Zookeeper(){
  cd $APP_DIR
  tar -zxvf zookeeper-3.4.9.tar.gz
  mv zookeeper-3.4.9 /usr/local/zookeeper
  
  cat >>/etc/profile << "EOF"
export ZOOKEEPER_HOME=/usr/local/zookeeper
export PATH=$ZOOKEEPER_HOME/bin:$ZOOKEEPER_HOME/conf:$PATH
EOF
  
  mkdir -p /data/zookeeper/data
  mkdir -p /data/logs/zookeeper
  chmod -R 777 /data/logs/
  
  cd $ZK_DIR/conf
  cp zoo_sample.cfg zoo.cfg
  
  cat>zoo.cfg<< EOF
tickTime=2000
initLimit=5
syncLimit=2
dataDir=/data/zookeeper/data
dataLogDir=/data/logs/zookeeper
clientPort=2181
server.1=$SER1:2888:3888
server.2=$SER2:2888:3888
server.3=$SER3:2888:3888
EOF


getip=`ifconfig ens33 | awk 'NR==2{print $2}'`

if [[ $getip == $SER1 ]]
  then 
    echo "1" > /data/zookeeper/data/myid
elif [[ $getip == $SER2 ]]
  then
    echo "2" >/data/zookeeper/data/myid
else 
    echo "3" >/data/zookeeper/data/myid 
fi



cat >>/etc/init.d/zookeeper<<"EOF"
#!/bin/bash
# chkconfig:   2345 10 90
# description:  zookeeper 
export JAVA_HOME=/usr/local/java/jdk1.8.0_92
export ZOO_LOG_DIR=/data/logs/zookeeper
ZOOKEEPER_HOME=/usr/local/zookeeper
${ZOOKEEPER_HOME}/bin/zkServer.sh "$1"
EOF

chmod +x /etc/init.d/zookeeper
chkconfig --add zookeeper
chkconfig zookeeper on

service zookeeper start

}


