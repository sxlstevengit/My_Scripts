启动容器 --privileged参数:因为基础镜像中，基础镜像中有很多目录只读挂载的，修改某些参数会提示没有权限，错误如下：
can't create /sys/kernel/mm/transparent_hugepage/enabled: Read-only file system

正确的启动命令(交互式):
docker run -it --privileged --name redis --rm -p 6379:6379 alpine-redis:1.0.6

直接启动: (--restart=always随docker服务一起启动)
docker run --privileged -p 6379:6379 --name redis -d --restart=always alpine-redis:1.0.7

redis客户端直接连接:
redis-cli -h 192.168.10.74 -p 6379



附其它的使用方法:

docker pull sxlsteven/alpine:redis1.0.0
docker pull redis:alpine

docker run -p 6379:6379 --name redis -v /usr/local/docker/redis/redis.conf:/etc/redis/redis.conf -v /usr/local/docker/redis/data:/data -d redis:alpine redis-server /etc/redis/redis.conf --appendonly yes

说明：
-p 6379:6379: 将容器的 6379 端口映射到宿主机的 6379 端口；
-v /usr/local/docker/redis/data:/data : 将容器中的 /data 数据存储目录, 挂载到宿主机中 /usr/local/docker/redis/data 目录下；
-v /usr/local/docker/redis/redis.conf:/etc/redis/redis.conf: 将容器中 /etc/redis/redis.conf 配置文件，挂载到宿主机的 /usr/local/docker/redis/redis.conf 文件上；
redis-server --appendonly yes: 在容器执行 redis-server 启动命令，并打开 redis 持久化配置;

连接容器
docker run -it redis:alpine redis-cli -h ip







