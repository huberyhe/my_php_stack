[回到首页](../README.md)

# 1. etcd

说明

[TOC]

## 1.1. 使用场景

## 1.2. 功能

### 键值存储

```bash
etcdctl --endpoints=$ENDPOINTS put web1 value1
etcdctl --endpoints=$ENDPOINTS put web2 value2
etcdctl --endpoints=$ENDPOINTS put web3 value3

# 前缀读
etcdctl --endpoints=$ENDPOINTS get web --prefix

# 删除
etcdctl --endpoints=$ENDPOINTS del key
etcdctl --endpoints=$ENDPOINTS del k --prefix

# 事务
etcdctl --endpoints=$ENDPOINTS txn --interactive

compares:
value("user1") = "bad"

success requests (get, put, delete):
del user1

failure requests (get, put, delete):
put user1 good
```

### 监控和提醒

```bash
# 监控字段
etcdctl --endpoints=$ENDPOINTS watch stock1

# 另一个终端写
etcdctl --endpoints=$ENDPOINTS put stock1 1000
```

### 租约和过期

```shell
# 创建租约，300s过期
etcdctl --endpoints=$ENDPOINTS lease grant 300
# lease 2be7547fbc6a5afa granted with TTL(300s)

# 在租约上创建数据
etcdctl --endpoints=$ENDPOINTS put sample value --lease=2be7547fbc6a5afa
etcdctl --endpoints=$ENDPOINTS get sample

# 保持租约，每10s发送一个心跳
etcdctl --endpoints=$ENDPOINTS lease keep-alive 2be7547fbc6a5afa
# 解除租约
etcdctl --endpoints=$ENDPOINTS lease revoke 2be7547fbc6a5afa
# or after 300 seconds
etcdctl --endpoints=$ENDPOINTS get sample
```

### 锁

```bash
etcdctl --endpoints=$ENDPOINTS lock mutex1

# 另外一个终端尝试获取锁，但阻塞直到上面的锁操作主动退出
etcdctl --endpoints=$ENDPOINTS lock mutex1
```

### 选举

```bash
etcdctl --endpoints=$ENDPOINTS elect one p1

# 另外一个终端竞选同一个block，但知道上面的操作退出才能竞选成功
etcdctl --endpoints=$ENDPOINTS elect one p2
```

### 服务发现

利用get/put、watch、lease等功能实现

服务启动时：
1、新建租约
2、在租约上创建键值。键为服务名(/my-service/log/)+租约id，值为服务地址
3、保持租约

网关（负载均衡）：
1、读取所有服务地址，放到本地地址列表
2、监听key，根据事件修改本地地址列表
3、请求到来时选择一个服务，负载均衡策略包括轮询、随机选择、最少连接


## 1.3. 其他命令

检查集群状态：

```bash
etcdctl --write-out=table --endpoints=$ENDPOINTS endpoint status
etcdctl --endpoints=$ENDPOINTS endpoint health
```

快照保存：
```bash
ENDPOINTS=$HOST_1:2379
etcdctl --endpoints=$ENDPOINTS snapshot save my.db

etcdctl --write-out=table --endpoints=$ENDPOINTS snapshot status my.db
```

查看prometheus指标：
```bash
curl -L http://127.0.0.1:2379/metrics
```