说明
====

#安装宝塔时无法直接用构建的方式安装,会出现一直卡着不动问题。
#软件安装可以选择简易安装。编译安装空间占用比较大。

步骤如下：
=========

### 1. 用centos7镜像启动容器。

docker run -itd --privileged -p 38888:8888 --name mycentos centos7 /usr/sbin/init

### 2. 进入容器安装baota面板及相关软件。

docker exec -it 0de9a47acc79 bash

 * 2.1 清理容器，为了减小镜像的大小

	清理yum缓存
	rm -rf /var/cache/yum  && yum clean all 

	清除编译的安装包及路径(如果是简易安装方式，则不需要执行这一步)
	rm -rf /www/server/nginx/src  /www/server/php/71/{src,src.tar.gz} 


### 3. 保存容器成新的镜像。

只安装有baota panels时生成镜像。
docker commit -m "baota7.4.5 just include baota panels" 0de9a47acc79 baota:0.0.2

或者
docker commit -m "baota7.4.5 include lnmp" 0de9a47acc79 baota:0.0.2

### 4. 以第3步中的镜像为base，写一个dockerfile, 制作最终镜像（如果不需要加个人信息之类，4和5可以不做）。

FROM baota:0.0.2
LABEL MAINTAINER="sxl_youcun@qq.com" \
      author="steven"
EXPOSE 20 21 80 443 888 8888
CMD ["/usr/sbin/init"]

### 5. 构建最终镜像

docker build -t sxlsteven/baota:1.0.2 -f baota.dockerfile . 

