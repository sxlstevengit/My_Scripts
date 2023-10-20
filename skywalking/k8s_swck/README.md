## 1. 简介：

### 1.1 SWCK 是什么？

[SWCK](https://github.com/apache/skywalking-swck)是部署在 Kubernetes 环境中，为 Skywalking 用户提供服务的平台，用户可以基于该平台使用、升级和维护 SkyWalking 相关组件。

实际上，SWCK 是基于 [kubebuilder](https://book.kubebuilder.io/) 开发的Operator，为用户提供自定义资源（ CR ）以及管理资源的控制器（ Controller ），所有的自定义资源定义（CRD）如下所示：

- [JavaAgent](https://github.com/apache/skywalking-swck/blob/master/docs/operator.md#javaagent)
- [OAP](https://github.com/apache/skywalking-swck/blob/master/docs/operator.md#oap)
- [UI](https://github.com/apache/skywalking-swck/blob/master/docs/operator.md#ui)
- [Storage](https://github.com/apache/skywalking-swck/blob/master/docs/operator.md#storage)
- [Satellite](https://github.com/apache/skywalking-swck/blob/master/docs/operator.md#satellite)
- [Fetcher](https://github.com/apache/skywalking-swck/blob/master/docs/operator.md#fetcher)

### 1.2  java 探针注入器是什么？

对于 java 应用来说，用户需要将 java 探针注入到应用程序中获取元数据并发送到 Skywalking 后端。为了让用户在 Kubernetes 平台上更原生地使用 java 探针，我们提供了 java 探针注入器，该注入器能够将 java 探针通过 sidecar 方式注入到应用程序所在的 pod 中。 java 探针注入器实际上是一个[Kubernetes Mutation Webhook控制器](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)，如果请求中存在 [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) ，控制器会拦截 pod 事件并将其应用于 pod 上。

### 1.3 主要特点：

- **透明性**。用户应用一般运行在普通容器中而 java 探针则运行在初始化容器中，且两者都属于同一个 pod 。该 pod 中的每个容器都会挂载一个共享内存卷，为 java 探针提供存储路径。在 pod 启动时，初始化容器中的 java 探针会先于应用容器运行，由注入器将其中的探针文件存放在共享内存卷中。在应用容器启动时，注入器通过设置 JVM 参数将探针文件注入到应用程序中。用户可以通过这种方式实现 java 探针的注入，而无需重新构建包含 java 探针的容器镜像。
- **可配置性**。注入器提供两种方式配置 java 探针：全局配置和自定义配置。默认的全局配置存放在 [configmap](https://kubernetes.io/docs/concepts/configuration/configmap/) 中，用户可以根据需求修改全局配置，比如修改 `backend_service` 的地址。此外，用户也能通过 annotation 为特定应用设置自定义的一些配置，比如不同服务的 `service_name` 名称。详情可见 [java探针说明书](https://github.com/apache/skywalking-swck/blob/master/docs/java-agent-injector.md)。
- **可观察性**。每个 java 探针在被注入时，用户可以查看名为 `JavaAgent` 的 CRD 资源，用于观测注入后的 java 探针配置。详情可见 [JavaAgent说明](https://github.com/apache/skywalking-swck/blob/master/docs/javaagent.md)。



## 2. 安装SWCK

### 2.1 安装证书管理器(cert-manger)

SWCK 的证书都是由证书管理器分发和验证，需要先通过如下命令安装[证书管理器cert-manger](https://cert-manager.io/docs/)。

```sh
kubectl apply -f cert-manager.yaml

```

验证 cert-manger 是否安装成功。

```sh
kubectl get pod -n cert-manager
NAME                                       READY   STATUS    RESTARTS   AGE
cert-manager-7dd5854bb4-slcmd              1/1     Running   0          73s
cert-manager-cainjector-64c949654c-tfmt2   1/1     Running   0          73s
cert-manager-webhook-6bdffc7c9d-h8cfv      1/1     Running   0          73s
```



### 2.2  安装SWCK

java 探针注入器是 SWCK 中的一个组件，首先需要按照如下步骤安装 SWCK：

下载地址：https://skywalking.apache.org/downloads/   ；选择Operation----SkyWalking Cloud on Kubernetes----Distribution.

我已经下载好了文件，直接应用就行了。

```
kubectl delete -f operator-bundle.yaml 

或者直接从官网下载并安装
curl -Ls https://dlcdn.apache.org/skywalking/swck/0.8.0/skywalking-swck-0.8.0-bin.tgz | tar -zxf - -O ./config/operator-bundle.yaml | kubectl apply -f -
```



检查 SWCK 是否正常运行。

```
kubectl get pod -n skywalking-swck-system
NAME                                                  READY   STATUS    RESTARTS   AGE
skywalking-swck-controller-manager-7f64f996fc-qh8s9   2/2     Running   0          94s
```



### 2.3 安装 Skywalking 组件 — OAPServer 和 UI

在 `skytest` 命名空间中部署 OAPServer 组件和 UI 组件。

```
创建名称空间
kubectl create namespace skytest
安装组件
kubectl apply -f default.yaml -n skytest
```

查看 OAPServer和 UI 组件部署情况。

```
[root@stag-node01 skytest]# kubectl get oapserver -n skytest
NAME      INSTANCES   RUNNING   ADDRESS
default   1           1         default-oap.skytest


[root@stag-node01 skytest]# kubectl get ui -n skytest
NAME      INSTANCES   RUNNING   INTERNALADDRESS      EXTERNALIPS   PORTS
default   1           1         default-ui.skytest                 [80]

```

### 2.4 部署demo应用

```
给 skytest 命名空间打上标签使能 java 探针注入器。
kubectl label namespace skytest swck-injection=enabled

接下来为 spring boot 应用对应的部署文件 springboot.yaml ，其中使用了 annotation 覆盖默认的探针配置，比如 service_name ，将其覆盖为 backend-service

springboot.yaml内容如下：
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-springboot
  namespace: skytest
spec:
  selector:
    matchLabels:
      app: demo-springboot
  template:
    metadata:
      labels:
        swck-java-agent-injected: "true"  # enable the java agent injector
        app: demo-springboot
      annotations:
        strategy.skywalking.apache.org/agent.Overlay: "true"  # enable the agent overlay
        agent.skywalking.apache.org/agent.service_name: "backend-service"
        agent.skywalking.apache.org/collector.backend_service: "default-oap:11800"
    spec:
      containers:
      - name: springboot
        imagePullPolicy: IfNotPresent
        image: springio/gs-spring-boot-docker
---
apiVersion: v1
kind: Service
metadata:
  name: demo
  namespace: skytest
spec:
  type: ClusterIP
  ports:
  - name: 8085-tcp
    port: 8085
    protocol: TCP
    targetPort: 8080
  selector:
    app: demo-springboot
```

安装应用

```
kubectl apply -f springboot.yaml
查看部署情况
kubectl get pod -n skytest
NAME                               READY   STATUS    RESTARTS   AGE
demo-springboot-7c89f79885-dvk8m   1/1     Running   0          11s

通过 JavaAgent 查看最终注入的 java 探针配置
kubectl get javaagent -n skytest
NAME                            PODSELECTOR           SERVICENAME       BACKENDSERVICE
app-demo-springboot-javaagent   app=demo-springboot   backend-service   default-oap:11800
```



### 2.5 验证注入器

当完成上述步骤后，我们可以查看被注入pod的详细状态，比如被注入的`agent`容器。

```
#kubectl get pod -A -lswck-java-agent-injected=true
NAMESPACE           NAME                               READY   STATUS    RESTARTS   AGE
springboot-system   demo-springboot-7c89f79885-lkb5j   1/1     Running   0          75s
```

通过ingress暴露UI服务并访问

```
 注意：在default.yaml文件中已经定义了ingress配置，那这一步就不需要执行了。
 kubectl apply -f ingress.yaml
 
 把ingress域名绑定host
 http://skytest.xxx.com
 
 首次访问没有啥数据，先造点数据
 while true;do curl http://10.254.202.145:8085;done
```



## 参考：

https://skywalking.apache.org/zh/2022-04-19-how-to-use-the-java-agent-injector/#

