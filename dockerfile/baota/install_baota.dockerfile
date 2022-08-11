FROM centos:centos7.9.2009
LABEL MAINTAINER="sxl_youcun@qq.com" \
      Author="steven"

ADD install.sh /
RUN yum install -y wget vim net-tools iproute coreutils && \
    wget -O /etc/yum.repos.d/epel.repo https://mirrors.aliyun.com/repo/epel-7.repo && \
    bash /install.sh && \
    yum clean all && \
    rm -rf /var/cache/yum
WORKDIR /
EXPOSE 8888
CMD ["/usr/sbin/init"]
