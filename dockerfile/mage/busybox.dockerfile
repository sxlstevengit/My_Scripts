# This is a dockerfile
# Author:steven

FROM busybox:latest
#MAINTAINER steven <sxl_youcun@qq.com>
LABEL MAINTAINER="steven <sxl_youcun@qq.com>" \
      Author=steven \
      Version=1.0
#ARG MYKEY
ENV YUM_ROOT=/etc/yum.repos.d/ \
    NG_VER=nginx-1.17.3 \
    WEB_ROOT=/data/web/html/

WORKDIR /data/web/html/
#RUN touch ${MYKEY}
#COPY index.html ./ 
RUN echo "<h1>Welcome to my webwite</h1>" > index.html && \
    cat index.html

COPY yum.repos.d ${YUM_ROOT:-/etc/yum.repos.d/}

#ADD http://nginx.org/download/${NG_VER}.tar.gz /usr/local/src/
ADD ${NG_VER}.tar.gz /usr/local/src

VOLUME /data/mysql/

EXPOSE 80/tcp

#CMD /bin/httpd -f -h ${WEB_ROOT}
CMD ["/bin/httpd -f -h ${WEB_ROOT}"]
#CMD ["/bin/sh","-c","httpd -f -h ${WEB_ROOT}"]
#CMD ["/bin/sh","-c","sleep 3600"]
#CMD ["/bin/sh","-c","echo 'hello cmd!'"]
#CMD ["hello cmd","baby"]
#ENTRYPOINT echo
#ENTRYPOINT /bin/httpd -f -h ${WEB_ROOT}
ENTRYPOINT ["/bin/sh","-c"]
