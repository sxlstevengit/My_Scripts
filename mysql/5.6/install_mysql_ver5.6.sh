#!/bin/bash
# This script is used to setup mysql5.6
# 请将脚本和安装包放一个目录.

Install_mysql(){
# set up enviroment for mysql
yum install -y perl-Module-Install.noarch bison gcc-c++ ncurses-devel openssl-devel

# add mysql user and create directory
useradd -u 27 -d /home/mysql/ -s /sbin/nologin mysql
mkdir -p /data/mysql
mkdir -p /data/mysql_tmpdir
chown -R mysql:mysql /data/mysql/
chown -R mysql:mysql /data/mysql_tmpdir/

# unzip software 
tar -zxvf mysql-5.6.35.tar.gz
cd mysql-5.6.35


# start install mysql
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DDEFAULT_CHARSET=utf8 -DENABLED_LOCAL_INFILE=1 -DMYSQL_DATADIR=/data/mysql -DSYSCONFDIR=/etc/mysql -DWITH_EXTRA_CHARSETS=all -DWITH_READLINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_READLINE=1 -DWITH_SSL=system -DWITH_LIBWRAP=0 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DWITH_ZLIB=system && make -j `cat /proc/cpuinfo | grep processor | wc -l` && make install

}

Init_Mysql(){

[[ -f /etc/my.cnf ]] && mv /etc/my.cnf /etc/my.cnf.backup.$(date +%Y-%m-%d)
wget -q -O /etc/my.cnf https://raw.githubusercontent.com/sxlstevengit/My_Scripts/master/mysql/5.6/my_5.6.cnf && sed  -i 's/2048M/1024M/g' /etc/my.cnf 
cd /usr/local/mysql/scripts/
./mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql
}

Start_Mysql(){
cd /usr/local/mysql/support-files
cp mysql.server /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
cat >>/etc/profile<< EOF
export PATH=/usr/local/mysql/bin:\$PATH
EOF
chkconfig mysqld on
service mysqld start
}

Mysql_Secure_Set(){
yum install -y expect
expect install_mysql_first.exp
}


#Install_mysql
#Init_Mysql
#Start_Mysql
#Mysql_Secure_Set

