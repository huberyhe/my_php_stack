[回到首页](../README.md)

# 1. 消息队列

消息队列的使用场景

[TOC]

## 1.1. 使用场景

### 1.1.1. 异步处理

比如，注册帐号后发送邮件或短信，使用异步处理去执行任务可提高系统吞吐量

 ![img](../imgs/820332-20160124211131625-1083908699.png)

### 1.1.2. 应用解耦

一个应用的异常不会影响另一个应用。比如订单系统与库存系统，库存系统挂掉之后应不影响正常的下单操作

 ![img](../imgs/820332-20160124211254187-1511483255.png)

### 1.1.3. 流量削峰

比如，秒杀系统，一般会因为流量过大，导致流量暴增，应用挂掉。为解决这个问题，一般需要在应用前端加入消息队列

 ![img](../imgs/820332-20160124211333125-923847962.png)

- 可以控制活动的人数
- 可以缓解短时间内高流量压垮应用
- 用户的请求，服务器接收后，首先写入消息队列。假如消息队列长度超过最大数量，则直接抛弃用户请求或跳转到错误页面
- 秒杀业务根据消息队列中的请求信息，再做后续处理

### 1.1.4. 日志处理

日志处理是指将消息队列用在日志处理中，比如Kafka的应用，解决大量日志传输的问题。架构简化如下

 ![img](../imgs/820332-20160124211436718-1054529852.png)

- 日志采集客户端，负责日志数据采集，定时写受写入Kafka队列
- Kafka消息队列，负责日志数据的接收，存储和转发
- 日志处理应用：订阅并消费kafka队列中的日志数据

> 参考：
> 
> 1、[消息队列使用的四种场景介绍](https://www.cnblogs.com/yanglang/p/9259172.html)

### 1.1.5. 消息通讯

## 1.2. 常用消息队列

### 1.2.1. Kafka

### 1.2.2. RabbitMQ

**RabbitMQ**是实现了[高级消息队列协议](https://zh.wikipedia.org/wiki/高级消息队列协议)（AMQP）的开源[消息代理](https://zh.wikipedia.org/wiki/消息代理)软件

官方文档：[RabbitMQ Tutorials — RabbitMQ](https://www.rabbitmq.com/getstarted.html)

特性：

- 可伸缩性：集群服务
- 消息持久化：从内存持久化消息到硬盘，再从硬盘加载到内存

打印出未ack的队列任务

```bash
sudo rabbitmqctl list_queues name messages_ready messages_unacknowledged
```

打印excahnges

```bash
sudo rabbitmqctl list_exchanges
```

列出绑定

```bash
sudo rabbitmqctl list_bindings
```

**与redis作为消息队列时的区别**，为什么一般会选择rabbitmq？

redis的list设计简单，没有保证消费的机制，一旦消费失败，消息丢失。而rabbitmq会使失败的消息自动回到原队列

redis： 轻量级，低延迟，高并发，低可靠性；

rabbitmq：重量级，高可靠，异步，不保证实时；

> 参考：[Redis 与 MQ 的区别](https://www.cnblogs.com/dengguangxue/p/11537466.html)

## 1.3. 应用实例

### ELK

Logstash 是服务器端数据处理管道，能够同时从多个来源采集数据，转换数据，然后将数据发送到诸如Elasticsearch 等“存储库”中。

Kibana 则可以让用户在 Elasticsearch 中使用图形和图表对数据进行可视化。



### Debezium

Debezium 是一个分布式平台，它将现有数据库的信息转换为事件流，使应用程序能够检测，并立即响应数据库中的行级更改。

Debezium 基于 [Apache Kafka](http://kafka.apache.org/) 构建，提供一组 [Kafka Connect](https://kafka.apache.org/documentation.html#connect) 兼容连接器。每个连接器都可用于特定的数据库管理系统(DBMS)。连接器记录 DBMS 中数据更改的历史记录，方法是在发生时检测更改，并将每个更改事件的记录流传输到 Kafka 主题。然后，消耗应用程序可以从 Kafka 主题中读取生成的事件记录。

通过利用 Kafka 的可靠流平台，Debezium 使应用程序可以正确、完全消耗数据库中发生的更改。即使您的应用程序意外停止或丢失其连接，也不会丢失停机期间发生的事件。应用程序重启后，它会从其离开的时间从主题中恢复读取。



### benthos

基于go语言的声明式流式ETL（代表**提取、转换和加载**，是组织将多个系统中的数据组合到单个数据库、数据存储空间、数据仓库或数据湖中的传统方法），高性能和弹性流处理器。

Benthos 是一个开源的、高性能和弹性的数据流处理器，能够以各种代理模式连接各种源和汇，可以帮助用户在不同的消息流之间进行路由，转换和聚合数据，并对有效载荷执行水合、富集、转换和过滤。

功能包括：

- 从多种消息流输入数据，包括 HTTP，Kafka，AMQP 等
- 将数据转换为各种格式，包括 JSON，XML，CSV 等
- 将数据聚合为单个消息
- 将数据路由到多个输出流，包括 HTTP，Kafka，AMQP 等
