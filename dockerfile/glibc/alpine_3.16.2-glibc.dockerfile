FROM alpine:3.16.2
LABEL maintainer="sxl_youcun@qq.com" \
      alpine_version="3.16.2"
ENV LANG="en_US.UTF-8" \
    proxy="https://ghproxy.com/"

ARG  GLIBCVER="2.33"

#COPY ./glibc/glibc-${GLIBCVER}-r0.apk /tmp/glibc-${GLIBCVER}-r0.apk
#COPY ./glibc/glibc-dev-${GLIBCVER}-r0.apk /tmp/glibc-dev-${GLIBCVER}-r0.apk
#COPY ./glibc/glibc-bin-${GLIBCVER}-r0.apk /tmp/glibc-bin-${GLIBCVER}-r0.apk
#COPY ./glibc/glibc-i18n-${GLIBCVER}-r0.apk /tmp/glibc-i18n-${GLIBCVER}-r0.apk
COPY ./glibc/sgerrand.rsa.pub /etc/apk/keys/sgerrand.rsa.pub


RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && cd /tmp/ \
    && apk update \
    && apk --no-cache add ca-certificates wget \
    && wget ${proxy}https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBCVER}-r0/glibc-${GLIBCVER}-r0.apk \
    && wget ${proxy}https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBCVER}-r0/glibc-bin-${GLIBCVER}-r0.apk \
    && wget ${proxy}https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBCVER}-r0/glibc-i18n-${GLIBCVER}-r0.apk \
    && wget ${proxy}https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBCVER}-r0/glibc-dev-${GLIBCVER}-r0.apk \
    && apk add --no-cache glibc-${GLIBCVER}-r0.apk glibc-dev-${GLIBCVER}-r0.apk \
    && rm -f /usr/glibc-compat/lib/ld-linux-x86-64.so.2 \
    && ln -s /usr/glibc-compat/lib/ld-2.33.so /usr/glibc-compat/lib/ld-linux-x86-64.so.2 \
    && apk add --no-cache glibc-bin-${GLIBCVER}-r0.apk glibc-i18n-${GLIBCVER}-r0.apk \
    && apk add --no-cache tzdata libstdc++ ca-certificates ttf-dejavu font-adobe-100dpi fontconfig curl \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && echo "export LC_ALL=en_US.UTF-8"  >>  /etc/profile \
    && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && addgroup -g 2022 ryuser \
    && adduser -h /home/ryuser -u 2022 -G ryuser -D ryuser \
    && cd / \
    && rm -rf /tmp/* \
    && rm -f /etc/apk/keys/sgerrand.rsa.pub

CMD ["sh"]
