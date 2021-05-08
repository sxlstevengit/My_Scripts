#!/bin/bash
# Function: This script is used to setup mysql5.7.30
# 请将脚本和安装包放一个目录.
# Date: 2020.06.15
# Author: created by steven.shi
# Mail: sxl_youcun@qq.com
# Version: 1.0
# 全局变量用大写；函数首字母大写；函数内的变量用小写。


Install_Mysql(){
# set up enviroment for mysql
yum install -y cmake wget perl-Module-Install.noarch bison gcc-c++ ncurses-devel openssl-devel

# add mysql user and create directory
useradd -u 27 -d /home/mysql/ -s /sbin/nologin mysql
mkdir -p /data/mysql
mkdir -p /data/mysql_tmpdir
chown -R mysql:mysql /data/mysql
chown -R mysql:mysql /data/mysql_tmpdir

# unzip software 
tar -zxvf mysql-boost-5.7.30.tar.gz
cd mysql-5.7.30

# start install mysql
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DDEFAULT_CHARSET=utf8 -DENABLED_LOCAL_INFILE=1 \
-DMYSQL_DATADIR=/data/mysql/ -DSYSCONFDIR=/etc/mysql -DWITH_EXTRA_CHARSETS=all -DWITH_READLINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_READLINE=1 \
-DWITH_SSL=system -DWITH_LIBWRAP=0 -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DWITH_ZLIB=system \
-DDOWNLOAD_BOOST=1 -DWITH_BOOST=./boost/boost_1_59_0 && make -j `cat /proc/cpuinfo | grep processor | wc -l` && make install

}

Init_Mysql(){

#下载my.cnf文件
[[ -f /etc/my.cnf ]] && mv /etc/my.cnf /etc/my.cnf.backup.$(date +%Y-%m-%d)
wget -q -O /etc/my.cnf https://raw.githubusercontent.com/sxlstevengit/My_Scripts/master/mysql/5.7/my_5.7.cnf 
#可以使用下面的命令修改某些值
#sed  -i 's/2048M/1024M/g' /etc/my.cnf 
#初始化数据库
cd /usr/local/mysql/bin/
./mysqld --initialize-insecure --user=mysql --datadir=/data/mysql --basedir=/usr/local/mysql --socket=/tmp/mysql.sock
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
rpm -qa | grep expect >/dev/null 2>&1 
result=$?
[[ $result -eq 0 ]] && echo "expect has installed" || yum install -y expect
echo "Starting Mysql_Secure_Set"
/usr/bin/expect <<EOF 
set timeout 30
spawn mysql_secure_installation

expect "Press y|Y for Yes, any other key for No:"
send "Y\n"

expect "Please enter 0 = LOW, 1 = MEDIUM and 2 = STRONG:"
send "0\n"

expect "New password:"
send "abcd1234\n"

expect "Re-enter new password:"
send "abcd1234\n"

expect "Do you wish to continue with the password provided?(Press y|Y for Yes, any other key for No) :"
send "Y\n"

expect "Remove anonymous users?*"
send  "Y\n"

expect "Disallow root login remotely?*"
send "Y\n"

expect "Remove test database and access to it?*"
send "Y\n"

expect "Reload privilege tables now?*"
send "Y\n"

expect eof
EOF

echo "Finished Mysql_Secure_Set"
}

Job_Down() {
echo "All the work has been done "
}


#Install_Mysql
#Init_Mysql
#Start_Mysql
Mysql_Secure_Set
Job_Down

