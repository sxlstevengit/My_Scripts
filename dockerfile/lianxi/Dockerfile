FROM busybox:latest
LABEL maintainer="sxl_youcun@qq.com" \
      author="steven" \
      version="1.0.0"
ENV WEB_ROOT=/www/html
WORKDIR /www/html
ADD index.html $WEB_ROOT 
#COPY
#RUN
#VOLUME
EXPOSE 80

## CMD command param1 param2 shell的形式，自动添加sh -c command; 启动时以sh的子进程执行，且会取代sh成为容器中进程号为1的进程。
#CMD httpd -f -h $WEB_ROOT 

##无法解析变量$WEB_ROOT, CMD ["exec","p1","p2"] 官方推荐方式，启动时直接启动为主进程，进程号为1。
#CMD ["httpd","-f","-h $WEB_ROOT"] 

##如果命令里用到变量及shell的一些特性，那么可以用sh -c的形式，且-c后面所有的部分作为一个参数给出。
#CMD ["/bin/sh","-c","/bin/httpd -f -h $WEB_ROOT"] 

## ENTRYPOINT command p1 p2;  Shell形式不接收任何CMD传过来的参数.
#ENTRYPOINT /bin/httpd -f -h $WEB_ROOT

##ENTRYPOINT ["executable", "param1", "param2"] 官方推荐方式，接收CMD传过来的参数,且参数会放在现有参数的后面。
#ENTRYPOINT ["/bin/sh","-c","/bin/httpd -f -h $WEB_ROOT"]

## CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
CMD ["hello","steven"]
ENTRYPOINT ["echo"]
