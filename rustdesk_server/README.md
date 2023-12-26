

# 简介

RustDesk 是一款可以平替 TeamViewer 的开源软件，旨在提供安全便捷的自建方案。

rustdesk-server版本是开源的，免费的。rustdesk-server pro版本是收费的。

默认情况下，hbbs 监听 21115(tcp), 21116(tcp/udp), 21118(tcp)，hbbr 监听 21117(tcp), 21119(tcp)。

务必在防火墙开启这几个端口， ** 请注意 21116 同时要开启 TCP 和 UDP**。

其中 21115 是 hbbs 用作 NAT 类型测试，21116/UDP 是 hbbs 用作 ID 注册与心跳服务，21116/TCP 是 hbbs 用作 TCP 打洞与连接服务，21117 是 hbbr 用作中继服务，21118 和 21119 是为了支持网页客户端。

如果您不需要网页客户端（21118，21119）支持，对应端口可以不开。



# 启动服务

启动rustdesk-server服务，三个文件都可以 docker-compose.yml、docker-compose-host.yml、start_rustdesk_server.sh使用。

任选其中一种
docker-compose -f docker-compose.yml up -d 

docker-compose -f docker-compose-host.yml up -d

chmod +x start_rustdesk_server.sh && ./start_rustdesk_server.sh


rustdesk支持各种系统的客户端：linux 、安卓、MAC、windows等



## 注意

hbbs -r xxx.xxx.xxx.xxx:21117 -k _

hbbs -r 服务器外网IP，如云服务器绑定的外网IP.
-k _   禁止没有填写key的用户建立非加密连接，请在运行 hbbs 和 hbbr 的时候添加 -k _ 参数。也注是必须填写key才能连接。

默认是不加密的。我们可以通过设置 Key来加密通话. 
hbbs 在第一次运行时，会自动产生一对加密私钥和公钥（分别位于运行目录下的 id_ed25519 和 id_ed25519.pub 文件中），其主要用途是为了通讯加密。
默认情况下，设置中继服务器时，并不需要填写key也可以进行通信，但是不加密通信，也就是明文通信。

# 参考

安装文档

https://rustdesk.com/docs/zh-cn/self-host/rustdesk-server-oss/install/

rustdesk镜像
https://hub.docker.com/r/rustdesk/rustdesk-server/tags

rustdesk-server服务端
https://github.com/rustdesk/rustdesk-server