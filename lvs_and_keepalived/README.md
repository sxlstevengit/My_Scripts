使用说明
=========
### LVS负载集群：

IPVS:工作在内核
ipvsadm:管理IPVS
keepalived和ipvsadm并行的，都可以直接管理内核ipvs。
keepalived和LVS亲密无间，keepalived就是为LVS诞生。

### LVS技术小结：

1.真正实现调度的工具是IPVS，工作在linux内核层面。
2.LVS自带的IPVS管理工具是ipvsadm。
3.keepalived实现管理IPVS及负载均衡器的高可用。
4.Red hat工具Piranha WEB管理实现调度的工具IPVS。

#### 注意

lvs和keepalived一起使用时，这里LVS配置并不是指真的安装LVS然后用ipvsadm来配置它，而是用keepalived的配置文件来代替ipvsadm来配置LVS，这样会方便很多，一个配置文件搞定这些，维护方便，配置方便是也！

对LVS 的几种调度模式的理解：
NAT：简单理解，就是数据进出都通过LVS，性能不是很好。
TUNL：简单理解：隧道
DR: 简单理解，客户端请求过来通过LVS，LVS转发给真实服务器，真实服务器会直接返回给客户端而不通过LVS。性能最好

```shell
备注：lvs的两台机器不能做为realserver,会有问题，所以实际使用过程中用haproxy更多些。
```





