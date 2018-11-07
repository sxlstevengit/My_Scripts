#! /bin/bash
#This script is used to auto install nginx.
#Author:steven.shi

#定义变量，全局变量用大写;函数首字母大写；函数中变量用小写。
NGINX_DIR=/usr/local/nginx
NGINX_CONF=$NGINX_DIR/conf
NGCONF_NAME=nginx.conf
APP_DIR=/root/src


Install_Nginx(){
  echo "start install dependencies package for nginx"
  yum install -y gcc gcc-c++ wget git epel-release libmcrypt libiconv mhash mcrypt openssl openssl-devel subversion
  
  [[ $? -eq 0 ]] && echo "start install pcre for nginx" || { 
     ret_val=$?
     echo "install package error"      
     exit $ret_val
  }
  
  cd $APP_DIR
  tar -zxvf pcre-8.40.tar.gz && cd pcre-8.40 && ./configure && make && make install
  [[ $? -eq 0 ]] && echo "start install zlib for nginx" || {
     ret_val=$?
     echo "install prce error"       
     exit $ret_val
  }  
   
  cd $APP_DIR
  tar -zxvf zlib-1.2.11.tar.gz && cd zlib-1.2.11 && ./configure && make && make install
  [[ $? -eq 0 ]] && echo "start down nginx module" || {
      ret_val=$?
      echo "install zlib error"
      exit $ret_val
  }   

  cd $APP_DIR
  svn co http://code.taobao.org/svn/nginx_concat_module/trunk nginx_concat_module
  
  echo "start install nginx"
  cd $APP_DIR
  tar -zxvf nginx-1.12.2.tar.gz && cd nginx-1.12.2 && ./configure --prefix=/usr/local/nginx --with-stream --with-http_stub_status_module --with-http_ssl_module --with-http_flv_module --with-http_mp4_module --with-http_dav_module --with-http_random_index_module --with-http_addition_module --with-http_sub_module --with-http_realip_module --with-http_gzip_static_module --with-pcre=/root/src/pcre-8.40 --with-zlib=/root/src/zlib-1.2.11 --add-module=/root/src/nginx_concat_module && make && make install

  [[ $? -eq 0 ]] && echo "install nginx is OK" || {
     ret_val=$?
     echo "install nginx error"
     exit $ret_val
  } 
  
  
  mkdir -p /data/logs/nginx
  chmod 777 -R /data/logs/

}

Init_Nginx(){
   touch /etc/init.d/nginx
   chmod 700 /etc/init.d/nginx
   cat >>/etc/init.d/nginx <<- "EOF"
#! /bin/sh
# chkconfig: - 85 15
# description: This scripts is used to start nginx

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

DESC="nginx daemon"
NAME=nginx
DAEMON=/usr/local/nginx/sbin/$NAME
CONFIGFILE=/usr/local/nginx/conf/$NAME.conf
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

set -e
[ -x "$DAEMON" ] || exit 0

do_start() {
$DAEMON -c $CONFIGFILE || echo -n "nginx already running"
}

do_stop() {
kill -INT `cat $PIDFILE` || echo -n "nginx not running"
}

do_reload() {
kill -HUP `cat $PIDFILE` || echo -n "nginx can't reload"
}

case "$1" in
start)
echo -n "Starting $DESC: $NAME"
do_start
echo "."
;;
stop)
echo -n "Stopping $DESC: $NAME"
do_stop
echo "."
;;
reload|graceful)
echo -n "Reloading $DESC configuration..."
do_reload
echo "."
;;
restart)
echo -n "Restarting $DESC: $NAME"
do_stop
do_start
echo "."
;;
*)
echo "Usage: $SCRIPTNAME {start|stop|reload|restart}" >&2
exit 3
;;
esac

exit 0

EOF

  chkconfig --add nginx
  chkconfig nginx on


#Set nginx config file and start nginx service  
cd $APP_DIR
mv $NGINX_CONF/$NGCONF_NAME{,.backup}
mkdir -p $NGINX_CONF/conf.d
git clone https://github.com/sxlstevengit/My_Scripts.git
cp My_Scripts/nginx/nginx.conf $NGINX_CONF
cp My_Scripts/nginx/default.conf $NGINX_CONF/conf.d 
rm -rf My_Scripts
service nginx start
  
#Add nginx command to path
cat>>/etc/profile<< "EOF"
export NGINX_HOME=/usr/local/nginx
export PATH=$PATH:$NGINX_HOME/sbin
EOF

. /etc/profile

}

Install_Nginx
Init_Nginx
