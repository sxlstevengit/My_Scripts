#!/bin/bash

APP_DIR=/usr/local/src
REDIS_DIR=/usr/local/redis-3.2.9

Install_Redis(){
  cd $APP_DIR
  tar -zxvf redis-3.2.9.tar.gz -C /usr/local
  cd $REDIS_DIR && make
}



Set_Redis_Conf(){
  cat >>/etc/profile << "EOF"
export PATH=/usr/local/redis-3.2.9/src:$PATH
EOF
  
  mkdir -p /data/redis
  mkdir -p /data/logs/redis
  chmod -R 777 /data/logs/
  
  cd $REDIS_DIR && cp redis.conf{,.old}
  sed -i 's/daemonize no/daemonize yes/' redis.conf
  sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' redis.conf
  sed -i 's#logfile ""#logfile /data/logs/redis/redis.log#' redis.conf
  sed -i 's#dir ./#dir /data/redis#' redis.conf
  sed -i '/# maxmemory <bytes>/a\maxmemory 2048mb' redis.conf
  sed -i '/# maxmemory-policy noeviction/a\maxmemory-policy volatile-lru' redis.conf
  sed -i '/# requirepass/a\requirepass abc.com' redis.conf
}

EXEC=/usr/local/bin/redis-server
CLIEXEC=/usr/local/bin/redis-cli

PIDFILE=/var/run/redis_${REDISPORT}.pid
CONF="/etc/redis/${REDISPORT}.conf"

Start_Redis(){
cd $REDIS_DIR/utils
cp redis_init_script redisd
sed -i '1a# chkconfig:   2345 90 10' redisd
sed -i 's#EXEC=/usr/local/bin/redis-server#EXEC=/usr/local/redis-3.2.9/src/redis-server#' redisd
sed -i 's#CLIEXEC=/usr/local/bin/redis-cli#CLIEXEC=/usr/local/redis-3.2.9/src/redis-cli#' redisd
sed -i 's#CONF="/etc/redis/${REDISPORT}.conf"#CONF=/usr/local/redis-3.2.9/redis.conf#' redisd
mv redisd /etc/init.d/redisd
chmod +x /etc/init.d/redisd
chkconfig --add redisd
chkconfig redisd on

service redisd start
}

Install_Redis
Set_Redis_Conf
Start_Redis
