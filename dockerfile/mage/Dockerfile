# Dockerfile for test
# Author: steven

#FROM busybox:latest
FROM busybox:19485c79a9bb
#MAINTAINER steven sxl_youcun@qq.com
#MAINTAINER "steven <sxl_youcun@qq.com>"
LABEL MAINTAINER="steven sxl_youcun@qq.com" \
      author="steven"
ENV HTML=/data/web/html/ \
    NGINX_VER="nginx-1.17.3"
COPY index.html ${HTML}

WORKDIR /usr/local
#ADD ${NGINX_VER}.tar.gz ./
ADD http://nginx.org/download/${NGINX_VER}.tar.gz ./

RUN tar -zxvf ${NGINX_VER}.tar.gz && \
    mv ${NGINX_VER} nginx
