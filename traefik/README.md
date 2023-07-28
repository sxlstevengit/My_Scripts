## 关于traefik官方简介

```
Traefik 是一个开源的 边缘路由器，它可以让你的服务发布成为一种有趣而轻松的体验。它代表您的系统接收请求，并找出哪些组件负责处理它们。

Traefik 的不同之处在于，除了它的众多功能外，它还可以自动为您的服务发现正确的配置。当 Traefik 检查您的基础设施时，奇迹就会发生，它会在其中找到相关信息并发现哪个服务服务于哪个请求。

Traefik 原生兼容所有主要的集群技术，例如 Kubernetes、Docker、Docker Swarm、AWS、Mesos、Marathon，不胜枚举；并且可以同时处理多个。（它甚至适用于在裸机上运行的遗留软件。）

使用 Traefik，无需维护和同步单独的配置文件：一切都自动实时发生（无需重新启动，无需连接中断）。使用 Traefik，您可以花时间为系统开发和部署新功能，而不是配置和维护其工作状态。

开发 Traefik，我们的主要目标是使其易于使用，我们相信您会喜欢它。

-- Traefik 维护者团队

本项目主要介绍在docker swarm环境中如何暴露服务。
```

## traefik安装

```
比较常用安装方式：二进制安装(主机)；使用官方Docker镜像安装(docker环境)；Helm安装(k8s环境)

二进制安装
从以下页面下面二进制包
https://github.com/traefik/traefik/releases

并运行它，查看配置项：
./traefik --help

指定配置文件启动
./traefik  --configfile=./traefik.toml

设置系统启动
mv traefik.service /lib/systemd/system/
systemctl enable traefik && systemctl start traefik


使用官方Docker镜像安装,
docker run -d -p 8080:8080 -p 80:80 -v $PWD/traefik.yml:/etc/traefik/traefik.yml traefik:v2.9.8

Helm安装省略，可以查看官方文档
```



## 文件说明及命令

```
文件
docker-compose.yml  # docker-compose案例文件
traefik.yml         # 配置文件，注意2.X和1.X版本配置文件和参数有很多不同，此处是2.X的版本。常见格式有yaml和toml两种。
traefik.service     # 系统启动文件
swarmMode           # 开启docker swarmMode模式下案例文件，注意下面的案例使用的就是此目录下文件。
  ├── backend.conf   # nginx配置文件，后面会有介绍。
  ├── docker-compose.yml  # docker-compose案例文件。
  ├── Dockerfile  # Dockerfile文件,  和backend.conf后面会介绍。
  └── traefik.yml # traefik配置文件，开启了swarmMode。 开启域名访问：defaultRule: Host(`{{ normalize .Name }}.docker.com`)。访问时加host.

命令

# 在docker swarm集群中创建一个overlay网络，在主节点创建后，会自动同步到其它节点。
docker network create \
--driver overlay \
--attachable  \
--subnet 10.100.0.0/24 \
my_net1

# 查看网络信息
docker network inspect my_net1

# 给节点打标签，需要在管理节点执行。
docker node update —label-add role=application node-1

# 更新服务
默认配置下，Swarm一次只更新一个副本，并且两个副本之间没有等待时间。
--update-parallelism #设置并行更新的副本数目
--update-delay #指定滚动更新的间隔时间
把web服务的镜像更新为rhel7，滚动更新间隔时间5s，每次更新3个容器实例。
docker service update --image rhel7 --update-delay 5s --update-parallelism 3 web


# 创建服务并指定端口映射后，所有的节点都会监听81端口，直接访问就可以访问到应用whoami
docker service create --name test --replicas 1 -p 81:80 --network application_net  repo.abc.com:5000/whoami:latest

# 创建一个容器监控的服务，可以从web直观查看运行的容器。 注意镜像名称是我内网用的一个registry. 
docker service create \
--name=viz \
--publish=8081:8080/tcp \
--constraint=node.role==manager \
--mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
repo.abc.com:5000/visualizer:latest


# 创建traefik服务，并指定网络名称。注意在Docker Swarm模式时，traefik必须放在主节点；需要通过constraints来限定节点。
docker service create \
    --name traefik \
    --label traefik.enable=true \
    --constraint=node.role==manager \
    --publish 80:80 --publish 8080:8080 \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
    --mount type=bind,source=/root/traefik/traefik.yml,target=/etc/traefik/traefik.yml \
    --network my_net1  \
    repo.abc.com:5000/traefik:v2.9.8 \
    traefik --configfile=/etc/traefik/traefik.yml

# 创建一个web服务并设定label,traefik自动识别label并自动发现服务。
- 
docker service create \
--name web \
--label traefik.enable=true \
--label traefik.http.routers.ng.entrypoints=web \ #告诉 Traefik，将使用 Web 入口点公开此容器。（该名称与之前在 Traefik 中创建的入口点相对应）
--label traefik.http.services.ng.loadbalancer.server.port=80 \ # 向 Traefik 指示容器在内部公开端口 80。这是 Traefik 充当代理所必需的。
--label traefik.http.routers.ng.rule='Host(`ng.docker.com`)' \  # 设置暴露此应用的域名。
--network my_net1 --replicas 3 repo.abc.com:5000/nginx 


#查看docker服务
[root@master01 traefik]# docker service ls
ID             NAME      MODE         REPLICAS   IMAGE                                 PORTS
6noxca1ykf8t   nginx     replicated   1/1        repo.abc.com:5000/nginxbasic:latest   *:8090->80/tcp
xnt8w81esavr   traefik   replicated   1/1        repo.abc.com:5000/traefik:v2.9.8      *:80->80/tcp, *:8080->8080/tcp
y20kijm407as   viz       replicated   1/1        repo.abc.com:5000/visualizer:latest   *:8081->8080/tcp
fk8bm07k7fgw   web       replicated   3/3        repo.abc.com:5000/nginx:latest        

# 删除服务
docker service rm backend-app

# 服务访问。
-- 打开traefik UI界面
http://reverse-proxy.docker.com:8080
-- 访问web的页面。
http://ng.docker.com



```

### Docker Compose和Stack文件的区别

单机模式下，可以使用 Docker Compose 来编排多个服务。Docker Swarm 只能实现对单个服务的简单部署。而Docker Stack 只需对已有的 docker-compose.yml 配置文件稍加改造就可以完成 Docker 集群环境下的多服务编排。stack是一组共享依赖，可以被编排并具备扩展能力的关联service。

Docker Stack和Docker Compose区别
	

* Docker stack会忽略了“构建”指令，无法使用stack命令构建新镜像，它是需要镜像是预先已经构建好的。 所以docker-compose更适合于开发场景；

* Docker Compose是一个Python项目，在内部，它使用Docker API规范来操作容器。所以需要安装Docker -compose，以便与Docker一起在您的计算机上使用；Docker Stack功能包含在Docker引擎中。你不需要安装额外的包来使用它，docker stacks 只是swarm mode的一部分。
  	
* Docker stack不支持基于第2版写的docker-compose.yml ，也就是version版本至少为3。然而Docker Compose对版本为2和3的 文件仍然可以处理；
  	
* docker stack把docker compose的所有工作都做完了，因此docker stack将占主导地位。同时，对于大多数用户来说，切换到使用
  	
* 单机模式（Docker Compose）是一台主机上运行多个容器，每个容器单独提供服务；集群模式（swarm + stack）是多台机器组成一个集群，多个容器一起提供同一个服务；

```
compose.yml deploy 配置说明

docker-compose.yaml文件中deploy参数下的各种配置主要对应了swarm中的运维需求。

docker stack deploy不支持的参数：
（这些参数，就算yaml中包含，在stack的时候也会被忽略，当然也可以为了docker-compose up留着这些配置）
build
cgroup_parent
container_name
devices
tmpfs
external_links
links
network_mode
restart
security_opt
userns_mode

deploy：指定与服务的部署和运行有关的配置。注：只在 swarm 模式和 stack 部署下才会有用。且仅支持 V3.4 及更高版本。


compose.yml 文件示例
version: "3"        # 版本号，deploy功能是3版本及以上才有的
services:            # 服务，每个服务对应配置相同的一个或者多个docker容器
  redis:            # 服务名，自取
    image: redis:alpine        # 创建该服务所基于的镜像。使用stack部署，只能基于镜像
    ports:             # 容器内外的端口映射情况
      - "1883:1883"
      - "9001:9001"
    networks:        # 替代了命令行模式的--link选项
      - fiware
    volumes:         # 容器内外数据传输的对应地址
      - "/srv/mqtt/config:/mqtt/config:ro"
      - "/srv/mqtt/log:/mqtt/log"
      - "/srv/mqtt/data/:/mqtt/data/"
    command: -dbhost stack_mongo # 命令行模式中跟在最后的参数，此条没有固定的格式，建议参照所部署的docker镜像的说明文档来确定是否需要该项、需要写什么
    deploy:
      mode: replicated
      replicas: 6            # replicas模式， 副本数目为1
      endpoint_mode: vip
      labels: 
        description: "This redis service label"
      resources:
        limits:
          cpus: '0.50'
          memory: 50M
        reservations:
          cpus: '0.25'
          memory: 20M
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
        window: 120s
      placement:
        constraints:
          - "node.role==worker"        # 部署位置，只在工作节点部署
          - "engine.labels.operatingsystem==ubuntu 18.04"
        preferences:
          - spread: node.labels.zone
      update_config:
        parallelism: 2
        delay: 10s
        order: stop-first

networks:         # 定义部署该项目所需要的网络
  fiware:


其它命令可参考下面链接：
https://developer.aliyun.com/article/1156985
```



### 使用docker stack来部署traefik

```
可以使用把所有的服务都写在docker-compose.yml 文件中，通过docker stack来部署，非常方便。 文件语法基本和docker-compose一样，

# 部署traefik
[root@master01 traefik]# docker stack deploy traefik -c docker-compose.yml 
Ignoring deprecated options:
container_name: Setting the container name is not supported.
Creating service traefik_nginx
Creating service traefik_reverse-proxy
Creating service traefik_whoami

# 查看stack
[root@master01 traefik]# docker stack ls
NAME      SERVICES
traefik   3

# stack部署之后在service也可以看到。
[root@master01 traefik]# docker service ls
ID             NAME                    MODE         REPLICAS   IMAGE                                 PORTS
6noxca1ykf8t   nginx                   replicated   1/1        repo.abc.com:5000/nginxbasic:latest   *:8090->80/tcp
mjpysbppkw4h   traefik_nginx           replicated   1/1        repo.abc.com:5000/nginx:latest        
jij9eocr1lp8   traefik_reverse-proxy   replicated   1/1        repo.abc.com:5000/traefik:v2.9.8      *:80->80/tcp, *:8080->8080/tcp
v5b6f0xkpltn   traefik_whoami          replicated   1/1        repo.abc.com:5000/whoami:latest       

# 扩容服务。如traefik_whoami扩到3个。
docker service scale traefik_whoami=3

# 访问。 同一个服务有多个实例时，通过traefik访问会自动负载均衡。
-- http://nginx.docker.com
-- http://whoami.docker.com

```

## 扩展：只通过nginx来暴露容器的服务

```
使用到了backend.conf和Dockerfile文件。

#创建应用backend-app，镜像使用whoami，实例数3个， 方便查看在不同的容器间轮询。
docker service create --name backend-app --replicas 3 --network my_net1 repo.abc.com:5000/whoami:latest

#创建nginx服务，映射端口8090到80。访问8090可以反代到后端的应用backend-app上面。
docker service create --name nginx --replicas 1 -p 8090:80 --network my_net1  repo.abc.com:5000/nginxbasic:latest

#访问
http://192.168.111.129:8090/
Hostname: 6c2896837ad5
IP: 127.0.0.1
IP: 10.0.2.76
IP: 172.18.0.5
RemoteAddr: 10.0.2.8:48996
GET / HTTP/1.1
Host: backend
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Connection: close
Sec-Gpc: 1
Upgrade-Insecure-Requests: 1


Hostname: a2077bc3a258
IP: 127.0.0.1
IP: 10.0.2.75
IP: 172.18.0.5
RemoteAddr: 10.0.2.8:49026
GET / HTTP/1.1
Host: backend
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Connection: close
Sec-Gpc: 1
Upgrade-Insecure-Requests: 1

Hostname: 744a50dd86e5
IP: 127.0.0.1
IP: 10.0.2.74
IP: 172.21.0.5
RemoteAddr: 10.0.2.8:49036
GET / HTTP/1.1
Host: backend
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2
Connection: close
Sec-Gpc: 1
Upgrade-Insecure-Requests: 1
```

