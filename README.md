# 技术栈

梳理自己的技术栈，方便自己回顾和加深学习。可以是自己学习过的觉得比较重要的，或者只是看到过还需要加深印象的

## 计算机基础

### [操作系统](./docs/computer-basics.md)

### [计算机网络](./docs/net-basic.md)

### [算法与数据结构](./docs/arithmetic-questions.md)

## 编程语言

### php

- [基本使用](./docs/php-basic.md)
- [框架](./docs/php-mvc.md)
- 常用组件

### go

- [基本使用](./docs/go-basic.md)
- 技巧与性能优化
- 框架
- 常用组件

	- gorm
	- casbin

## 中间件

### 反向代理

- [Nginx](./docs/nginx-basic.md)
- Apache
- Caddy

### [负载均衡](./docs/load-balancing.md)

- 负载均衡算法

	- 基于轮询Round Robin
	- 基于权重Weight
	- 基于最少连接
	- 基于响应时间
	- 基于IP地址
	- 基于内容
	- 动态负载均衡
	- 集群负载均衡

- 四层与七层

	- OSI模型传输层
	- OSI模型应用层

- 工具

	- Nginx
	- HAProxy
	- F5 BIG-IP
	- Kubernetes Ingress
	- LVS

### 数据库

- 关系型

	- [MySQL](./docs/mysql.md)
	- [PostgreSQL](./docs/postgresql-basic.md)
	- [sqlite](./docs/sqlite-basic.md)

- 非关系型

	- [MongoDB](./docs/mongodb.md)
	- [Elasticsearch](./docs/elasticsearch.md)
	- [Dgraph](./docs/dgraph.md)
	- [Redis](./docs/redis.md)

### 缓存

- [Redis](./docs/redis.md)
- Memcached
- Google Guava

### [消息队列](./docs/mq.md)

- RabbitMQ
- Kafka

### 服务发现与注册

- etcd
- ZooKeeper
- nacos
- k8s

## 工程构建

### 代码管理

- svn
- [git](./docs/git.md)

### shell脚本

- [基本使用](./docs/shell-basic.md)
- [技巧](./docs/shell-tips.md)
- [三剑客](./docs/shell-advanced-command.md)

### [Makefile](./docs/makefile.md)

### 打包

- [docker](./docs/docker.md)
- [rpm和deb包](./docs/linux-package.md)
- ssu包

### CI/CD

- gitlab
- jenkins
- circleCI
- argoCD

### [部署策略](./docs/software-engineering.md)

- 大爆炸部署
- 滚动部署
- 蓝绿部署
- 金丝雀部署
- 功能切换部署

## 系统设计

### [软件安全](./docs/safe-coding.md)

- 常见攻击和防范

	- xss
	- csrf
	- sql注入
	- 命令注入

- 扫描工具

	- appscan
	- Nessus
	- sslscan
	- Acunetix Security Audit

- 许可证协议

	- MIT许可证
	- Apache许可证
	- GNU通用公共许可证（GPL）

	  GPL 是一种相对较严格的许可证，要求任何以 GPL 许可证发布的软件及其修改版也必须以 GPL 许可证发布，并且要求在修改的软件中包含原始许可证和版权声明。
	  
	  这个要求使用该项目的项目必须开源。
	  
	- BSD许可证

- 网络安全漏洞信息发布平台

### 设计原则

- SOLID
- 7大设计原则

### 设计模式

- 23种设计模式

### 分布式系统

- 分布式事务
- CAP理论

### 认证方式

- cookie&session
- token
- SSO
- OAuth

