#!/bin/bash

#此处网络采用了主机网络，当然也可以使用NAT模式
#IP地址填写公网IP[如云主机绑定的公网IP],-k _ 选项用来开启连接服务器key认证,如果不需要则可以不写。
docker run --name hbbs -v /data/rustdesk_server/data:/root -itd --net=host rustdesk/rustdesk-server hbbs -r x.x.x.x:21117 -k _

#-k _ 选项用来开启连接服务器key认证。 
docker run --name hbbr -v /data/rustdesk_server/data:/root -itd --net=host rustdesk/rustdesk-server hbbr -k _
