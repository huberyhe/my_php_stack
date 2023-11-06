[回到首页](../README.md)

# 1. RabbitMQ

说明

[TOC]

## 1.1. 使用场景

## 1.2. 概念名词

exchange交易所
queue队列

## 1.2. 常用命令

打印未确认的消息：
```bash
rabbitmqctl list_queues name messages_ready messages_unacknowledged
```