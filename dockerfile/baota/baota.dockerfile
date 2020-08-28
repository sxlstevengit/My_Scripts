FROM baota:0.0.3
LABEL MAINTAINER="sxl_youcun@qq.com" \
      author="steven"
WORKDIR /
#ADD www.tar.gz /
EXPOSE 20 21 80 443 888 8888 
CMD ["/usr/sbin/init"]


