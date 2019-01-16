#!/bin/bash

APP_DIR=/root/src

Install_Epel(){

  cd $APP_DIR
  wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  rpm -ivh epel-release-latest-7.noarch.rpm
  yum repolist
  echo "Epel install is OK"

}


Install_Php7() {
  
cd $APP_DIR
  echo "start install dependencies package for php7"
  yum install --setopt=protected_multilib=false libxml2 libxml2-devel openssl openssl-devel libssl-devel curl libcurl4-gnutls-devel libjpeg-devel libpng12-devel libfreetype6 libfreetype6-devel libmcrypt4 libmcrypt-devel php-mcrypt libmcrypt libmcrypt-devel gd build-essential autoconf bzip2 bzip2-devel openldap openldap-devel aspell aspell-devel readline readline-devel libxslt libxslt-devel pcre pcre-devel freetype freetype-devel gmp-devel curl-devel libpng-devel -y
  
  [[ $? -eq 0 ]] && echo "start install php7" || {
     ret_val=$?
     echo "install package error"      
     exit $ret_val
  }
 
\cp -frp /usr/lib64/libldap* /usr/lib/

tar zxvf php-7.0.26.tar.gz && cd php-7.0.26 && ./buildconf --force 
   
  
./configure --prefix=/usr/local/php --exec-prefix=/usr/local/php --bindir=/usr/local/php/bin --sbindir=/usr/local/php/sbin --includedir=/usr/local/php/include --libdir=/usr/local/php/lib/php --mandir=/usr/local/php/php/man --with-config-file-path=/usr/local/php/etc --with-mysql-sock=/var/run/mysql/mysql.sock --with-mcrypt=/usr/include --with-mhash --enable-opcache --enable-mysqlnd --with-mysqli=shared,mysqlnd --with-pdo-mysql=shared,mysqlnd --enable-fpm --enable-static --enable-inline-optimization --enable-sockets --enable-pdo --enable-exif --enable-wddx --enable-zip --enable-calendar --enable-dba --enable-gd-jis-conv --enable-sysvmsg --enable-sysvshm --with-gd --with-iconv --with-openssl --with-zlib --with-gmp --with-pdo-sqlite --enable-bcmath --enable-soap --with-xmlrpc --with-pspell --with-pcre-regex --enable-mbstring --enable-shared --with-curl --with-bz2 --with-xsl --enable-xml --enable-ftp --with-mcrypt --with-mhash --enable-shmop --enable-sysvsem --enable-mbregex --enable-gd-native-ttf --enable-pcntl --enable-session --enable-fileinfo --with-gettext --with-freetype-dir --with-jpeg-dir --with-png-dir --with-readline --with-ldap --with-pear --disable-ipv6 --disable-debug --disable-maintainer-zts --disable-rpath --without-gdbm --without-pear 

sed -r -i 's/(EXTRA_LIBS = -lcrypt -lz -lexslt -lresolv -lcrypt -lreadline -lncurses -laspell -lpspell -lrt -lmcrypt -lldap -lgmp -lpng -lz -ljpeg -lcurl -lbz2 -lz -lrt -lm -ldl -lnsl -lxml2 -lz -lm -ldl -lssl -lcrypto -lcurl -lxml2 -lz -lm -ldl -lssl -lcrypto -lfreetype -lxml2 -lz -lm -ldl -lxml2 -lz -lm -ldl -lcrypt -lxml2 -lz -lm -ldl -lxml2 -lz -lm -ldl -lxml2 -lz -lm -ldl -lxml2 -lz -lm -ldl -lxml2 -lz -lm -ldl -lxslt -lxml2 -lz -ldl -lm -lssl -lcrypto -lcrypt)/\1 -llber/g' Makefile

make clean && make && make install

 [[ $? -eq 0 ]] && echo "install PHP7 is OK" || {
     ret_val=$?
     echo "install php7 error"
     exit $ret_val
  }

ln -s /usr/local/php/bin/php /usr/bin/php 

mkdir -p /data/logs/php/
chmod 777 -R /data/logs
cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod +x /etc/init.d/php-fpm
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf
service php-fpm start
netstat -lntp | grep 9000
chkconfig php-fpm on

}
Install_Epel
Install_Php7
