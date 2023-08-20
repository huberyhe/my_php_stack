[回到首页](../README.md)

# 1. kubernetes



[TOC]

## 1.1. 基本使用

### 1.1.1. 部署应用

run-my-nginx.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx
spec:
  selector:
    matchLabels:
      run: my-nginx
  replicas: 2
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      containers:
      - name: my-nginx
        image: nginx
        ports:
        - containerPort: 80
```

```bash
kubectl apply -f ./run-my-nginx.yaml

# 查看应用
kubectl get pods -l run=my-nginx -o wide

# 查看环境变量
kubectl exec my-nginx-646554d7fd-5d7bk -- printenv

# 查看容器日志
kubectl logs my-nginx-646554d7fd-5d7bk

# 查看 ReplicaSet 对象
kubectl get replicasets
kubectl describe replicasets
```

### 1.1.2. 创建服务

```bash
kubectl expose deployment/my-nginx
```

等效于

```bash
kubectl create -f nginx-svc.yaml
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-nginx
  labels:
    run: my-nginx
spec:
  ports:
  - port: 80
    protocol: TCP
  selector:
    run: my-nginx

```

```bash
# 查看服务
kubectl get svc my-nginx

# 查看详细信息
kubectl describe svc my-nginx

# 查看端点
kubectl get endpointslices -l kubernetes.io/service-name=my-nginx
```



### 1.1.3. 配置

创建配置：

```bash
kubectl apply -f example-redis-config.yaml
# 查看配置
kubectl describe configmap/example-redis-config
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: example-redis-config
data:
  redis-config: |
    maxmemory 2mb
    maxmemory-policy allkeys-lru    
```

redis使用该配置：

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/pods/config/redis-pod.yaml
kubectl exec -it redis -- redis-cli
127.0.0.1:6379> CONFIG GET maxmemory
```



## 1.2. 无状态应用

无状态应用不需要持久化数据，方便水平扩展和故障恢复。



php+redis的留言板应用示例

```bash
# 创建redis部署
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-leader-deployment.yaml
# 创建redis领导者服务
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-leader-service.yaml

# 创建redis部署
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-follower-deployment.yaml
# 创建redis追随者服务
kubectl apply -f https://k8s.io/examples/application/guestbook/redis-follower-service.yaml

# 创建 Guestbook 前端 Deployment
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml
# 创建前端服务
kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml

# 转发开放端口，访问 http://localhost:8080
kubectl port-forward svc/frontend 8080:80
```



> 参考：[示例：使用 Redis 部署 PHP 留言板应用程序 | Kubernetes](https://kubernetes.io/zh-cn/docs/tutorials/stateless-application/guestbook/)

## 1.3. 有状态应用

有状态应用依赖持久化的状态，这些状态需要在应用迁移、扩展和故障恢复时得到保留。



wordpress+mysql的博客应用示例



```bash
# 创建 PersistentVolumeClaims 和 PersistentVolumes

# 创建 Secret 生成器
cat <<EOF >./kustomization.yaml
secretGenerator:
- name: mysql-pass
  literals:
  - password=YOUR_PASSWORD
EOF

# 补充 MySQL 和 WordPress 的资源配置
curl -LO https://k8s.io/examples/application/wordpress/mysql-deployment.yaml
curl -LO https://k8s.io/examples/application/wordpress/wordpress-deployment.yaml
cat <<EOF >>./kustomization.yaml
resources:
  - mysql-deployment.yaml
  - wordpress-deployment.yaml
EOF

# 应用和验证
kubectl apply -k ./
kubectl get secrets
kubectl get pvc
kubectl get pods
kubectl get services wordpress
minikube service wordpress --url
# 访问上一步的地址
```



> 参考：[示例：使用持久卷部署 WordPress 和 MySQL | Kubernetes](https://kubernetes.io/zh-cn/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)
