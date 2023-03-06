#### 安装

```bash
# 使用yum部署consul
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install consul
# 如果yum下载失败，可以直接下载RPM包安装
wget https://rpm.releases.hashicorp.com/RHEL/7/x86_64/stable/consul-1.15.0-1.x86_64.rpm
rpm -ivh consul-1.15.0-1.x86_64.rpm
```

#### 配置

```bash
vi /etc/consul.d/consul.hcl
log_level = "ERROR" #日志级别，日志太多可以只打印error日志，不需要可以去掉这行。
advertise_addr = "192.168.x.x" #填写你的网卡IP，如果启动或运行有报错，可以尝试去掉这行。 通告地址
data_dir = "/opt/consul"  # 为Agent存放状态数据的，持久存储目录。
client_addr = "0.0.0.0" # consul服务侦听地址（允许哪些IP访问）可以是HTTP、DNS、RPC服务器。 默认为127.0.0.1，不对外提供服务；0.0.0.0，允许公网访问。
ui_config{
  enabled = true # 启用web-ui
}
server = true  # 定义agent运行在server模式
bootstrap = true # 标志用于控制服务器是否处于"引导"模式。和-bootstrap-expect不能一起使用。数据中心只有1个server agent，那么需要设置该参数。不建议在引导群集后使用此标志
#bootstrap_expect=1 # 数据中心期望的server类型的节点个数，和bootstrap不能一起使用。
acl = {
  enabled = true  # 启用acl,即开启访问控制。
  default_policy = "deny"  #默认策略拒绝
  enable_token_persistence = true #  开启token持久化存储
}
```

#### 启动服务

```bash
chown -R consul:consul /opt/consul  #注意下数据目录的权限。
systemctl enable consul.service
systemctl start consul.service
```

### 安装后首次获取登录Token（记录SecretID，即为Consul登录的Token）
```bash
consul acl bootstrap|grep SecretID
```


### 忘记global-management Token，重新生成
```
# 记录最后的reset index: xx
consul acl bootstrap

# 进入consul数据目录执行
echo 13 > acl-bootstrap-reset

# 重新创建一个global-management Token
consul acl bootstrap
```

### consul kv 备份还原
```
consul kv export --http-addr=http://127.0.0.1:8500 -token=xxxxxxxx '' > consul_kv_bak.json
consul kv import --http-addr=http://127.0.0.1:8500 -token=xxxxxxxx @consul_kv_bak.json
```

### consul.yml文件说明

```bash
定义了一个consul server agent和一个client agent,用来测试其功能Connect Service - Service Mesh
可以参考：https://www.jianshu.com/p/15e49efa2e24
```

