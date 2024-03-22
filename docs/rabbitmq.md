[回到首页](../README.md)

# 1. RabbitMQ

说明

[TOC]

## 1.1. 使用场景

rocketmq和kafka支持严格的消息顺序保证，而rabbitmq在有多个消费者时可能失去顺序

## 1.2. 概念名词

exchange交易所
queue队列

## 消息模式

1、点对点模式（无exchange,queue="xx"; queye="xx"）：一个消息只能消费一次

2、worker争抢模式（无exchange,queue="xx"; queye="xx"）

3、发布订阅模式（exchange="fanout"; queue=""，消费端临时队列绑定到exchange）：最简单的广播模式

4、路由选择模式（exchange="direct", 发布消息时指定router_key; queue=""，消费端临时队列绑定到exchange，接收指定router_key的消息）

5、主题模式（exchange=“topic”, 发布消息时指定router_key; queue=""，消费端临时队列绑定到exchange，接收指定router_key的消息）

## 1.3. 常用命令

打印未确认的消息：
```bash
rabbitmqctl list_queues name messages_ready messages_unacknowledged
```

## 1.4. 消息队列常见问题

### 1.4.1. 消息顺序消费

rabbitmq本身不保证消息顺序，单一队列+单一消费者是顺序的

使用kafka的分片通道

### 1.4.2. 消息重复消费

1、编写幂等消息处理程序

2、跟踪消息并丢弃重复项：带msg_id，并存储到 已处理消息 表

## 1.5. 底层原理

### 1、rabbitmq的QPS

不同硬件，不同配置（持久化、消息模式）下qps不同，大约几千到几万。实际可以使用**rabbitmq-perf-test**官方性能测试工具对吞吐量、延迟等指标进行测试
