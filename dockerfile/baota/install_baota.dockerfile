FROM centos7:latest
LABEL MAINTAINER="sxl_youcun@qq.com" \
      Author="steven"
RUN yum install -y wget vim && \
    wget -O install.sh http://download.bt.cn/install/install_6.0.sh && \ 
    sh install.sh
WORKDIR /
EXPOSE 8888
CMD ["/usr/sbin/init"]
