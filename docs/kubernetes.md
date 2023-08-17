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



## 1.2. 标题2

