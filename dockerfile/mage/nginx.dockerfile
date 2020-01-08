# This is a nginx dockerfile
# Author: steven

FROM nginx:1.14-alpine
ARG MYQQ=12345678
LABEL maintainer="steven <sxl_youcun@qq.com>" \
      Author=steven \
      QQ=${MYQQ}

ENV NGX_WEB_ROOT="/data/web/html" \
    LANG="en_US.UTF-8"

ADD entrypoint.sh /bin/
WORKDIR ${NGX_WEB_ROOT}
 
RUN echo "<h1>Welcome to steven's website</h1>" > ${NGX_WEB_ROOT}/index.html \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf
EXPOSE 80/tcp   
HEALTHCHECK --interval=5s --timeout=3s --start-period=3s CMD wget -O - -q http://${ip:-0.0.0.0}:18080/ || exit 1
ONBUILD LABEL SEX="male"
CMD ["/usr/sbin/nginx","-g","daemon off;"]
ENTRYPOINT ["/bin/entrypoint.sh"]
