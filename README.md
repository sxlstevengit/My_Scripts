本项目主要是工作当中一些常用的脚本、程序、服务文件等。


关于某个服务会以文件夹命名，目录下包含服务启用脚本，及配置文件相关。
例如：nginx， 启用脚本nginx适合各种Centos版本，nginx.service只适用Centos7
推荐nginx 和 nginx2

使用方法：
 
下载脚本后，根据实际需要修改变量。
mv nginx /etc/init.d/
chmod +x /etc/init.d/nginx
systemctl daemon-reload
chkconfig nginx on
service nginx start

or 

mv nginx.service /usr/lib/systemd/system/
systemctl daemon-reload
systemctl enable nginx
systemctl start nginx

