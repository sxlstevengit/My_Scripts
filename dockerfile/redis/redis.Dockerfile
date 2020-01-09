FROM alpine:latest
LABEL MAINTAINER="sxl_youcun@qq.com" \
      author="steven"
ENV Ver 5.0.7
WORKDIR /data
ADD redis-${Ver}.tar.gz .
COPY docker-entrypoint.sh /usr/local/bin/
RUN mkdir -p /etc/redis &&\
    mkdir -p /data &&\
    addgroup -S redis &&\ 
    adduser -S -G redis redis &&\
    chown -R redis.redis /data &&\
    ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime &&\
    echo "export LC_ALL=zh_CN.UTF-8" >> /etc/profile &&\
    echo http://mirrors.ustc.edu.cn/alpine/v3.9/main > /etc/apk/repositories &&\
    echo http://mirrors.ustc.edu.cn/alpine/v3.9/community >> /etc/apk/repositories &&\
    apk upgrade --update-cache &&\
    apk --no-cache add ca-certificates && \
    apk --no-cache add 'su-exec>=0.2' &&\
    apk --no-cache add musl-dev coreutils curl make gcc g++ linux-headers tcl &&\
    cd redis-${Ver} &&\
    make &&\
    make install &&\
    sed -i 's/^bind 127.0.0.1/bind 0.0.0.0/' redis.conf &&\
    cp redis.conf /etc/redis/redis.conf &&\
    apk --no-cache del musl-dev coreutils curl make gcc g++ linux-headers tcl &&\
    rm -rf /tmp/* /var/cache/apk/* \
       /data/redis-${Ver}

EXPOSE 6379
CMD ["redis-server","/etc/redis/redis.conf"]
ENTRYPOINT ["docker-entrypoint.sh"]
