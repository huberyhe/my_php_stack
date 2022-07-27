[回到首页](../README.md)

# 1. redis使用

说明

[TOC]

## 1.1. 数据类型

### 1.1.1. String（字符串）

值最大512MB，是二进制安全的

```
redis 127.0.0.1:6379> SET runoob "菜鸟教程"
OK
redis 127.0.0.1:6379> GET runoob
"菜鸟教程"
```

### 1.1.2. Hash（哈希）

是一个键值(key=>value)对集合

```
redis 127.0.0.1:6379> DEL runoob
redis 127.0.0.1:6379> HMSET runoob field1 "Hello" field2 "World"
"OK"
redis 127.0.0.1:6379> HGET runoob field1
"Hello"
redis 127.0.0.1:6379> HGET runoob field2
"World"
```

1.1.3. List（列表）

Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。

列表最多可存储 232 - 1 元素 (4294967295, 每个列表可存储40多亿)。

```
redis 127.0.0.1:6379> DEL runoob
redis 127.0.0.1:6379> lpush runoob redis
(integer) 1
redis 127.0.0.1:6379> lpush runoob mongodb
(integer) 2
redis 127.0.0.1:6379> lpush runoob rabbitmq
(integer) 3
redis 127.0.0.1:6379> lrange runoob 0 10
1) "rabbitmq"
2) "mongodb"
3) "redis"
redis 127.0.0.1:6379>
```



1.1.4. Set（集合）

Redis 的 Set 是 string 类型的无序集合。

集合是通过哈希表实现的，所以添加，删除，查找的复杂度都是 O(1)。

```
redis 127.0.0.1:6379> DEL runoob
redis 127.0.0.1:6379> sadd runoob redis
(integer) 1
redis 127.0.0.1:6379> sadd runoob mongodb
(integer) 1
redis 127.0.0.1:6379> sadd runoob rabbitmq
(integer) 1
redis 127.0.0.1:6379> sadd runoob rabbitmq
(integer) 0
redis 127.0.0.1:6379> smembers runoob

1) "redis"
2) "rabbitmq"
3) "mongodb"
```



1.1.5. zset(sorted set：有序集合)

Redis zset 和 set 一样也是string类型元素的集合,且不允许重复的成员。

不同的是每个元素都会关联一个double类型的分数。redis正是通过分数来为集合中的成员进行从小到大的排序。

zset的成员是唯一的,但分数(score)却可以重复。

```
redis 127.0.0.1:6379> DEL runoob
redis 127.0.0.1:6379> zadd runoob 0 redis
(integer) 1
redis 127.0.0.1:6379> zadd runoob 0 mongodb
(integer) 1
redis 127.0.0.1:6379> zadd runoob 0 rabbitmq
(integer) 1
redis 127.0.0.1:6379> zadd runoob 0 rabbitmq
(integer) 0
redis 127.0.0.1:6379> ZRANGEBYSCORE runoob 0 1000
1) "mongodb"
2) "rabbitmq"
3) "redis"
```

## 1.2. 事务

开启：`MULTI`

提交：`EXEC`

取消：`DISCARD`

## 1.2. 常见应用

### 1.2.1. 消息排队、异步逻辑处理

利用list的`rpush`+`lpop`模拟队列的先进先出，`llen`获取队列长度，`blpop`可实现阻塞读

缺点：空闲连接自动断开，应在代码中捕获异常并重试

### 1.2.2. 分布式锁

```
> setnx lock:codehole true
OK
> expire lock:codehole 5
... do something
> del lock:codehole
```

由于setnx和expire两步操作不具原子性，2.8版本增加了set指令的扩展参数，是的setnx和expire可以一起执行

```bash
> set logck:codehole true ex 10 nx
OK
... do something
> del lock:codehole
```

缺点：超时问题，不具可重入性

### 1.2.3. 延迟队列

加锁失败后放入延迟队列，延后处理避免冲突

延迟队列可以用zset实现，消息序列化后作为value，消息过期时间作为score，多个线程轮询这个zset获取到期的任务进行处理。

每次取一条消息，取到后zrem删除，删除成功才代表抢到了任务

缺点：zrangebyscore和zrem使用lua脚本实现原子化操作，避免抢占浪费

### 1.2.4. 使用位图实现签到功能

### 1.2.5. HyperLogLog统计UV

```
> pfadd codehole user1
1
> pfcount codehole
1
> pfadd codehole user1 user2
1
> pfcount codehole
2
```

### 1.2.6. 布隆过滤器

redis4.0后，布隆过滤器作为一个插件加载到redis中

```
> bf.add codehole user1
1
> bf.exists codehole user1
1
> bf.madd codehole user2 user3
1
1
> bf.mexists codehole user1 user4
1
0
```

### 1.2.7. 简单限流

限定用户某个行为在指定时间范围内只允许发生N次

使用zset数据结构，记录用户的行为历史，key是用户+行为，value和score都是毫秒时间戳

### 1.2.8. 漏斗限流

redis 4.0提供了限流模块Redis-Cell，提供了原子的限流指令`cl.throttle`

### 1.2.9. 位置模块GeoHash

查找指定范围“附近的人”

redis 3.2提供了地理位置Geo模块

```
> geoadd company 116.48105 39.996794 juejin
> geoadd company 116.514203 39.905409 ireader
> geodist company juejin ireader km
"10.5501"
> geopos company juejin
1) 1) "116.48105"
   2) "39.996794"
> geohash compnay juejin
1) "wx4gd94yjn0"
> georadiusbymenmber company ireader 20 km count 3 asc
1) "ireader"
2) "juejin"
```

### 1.2.10. 匹配键scan

keys可以模糊匹配，但是会一次返回所有符合条件的key，scan的改进在于每次只返回一部分和游标cursor，当cursor=0时表示遍历完毕。

```
> scan 0 match key99* count 1000
1) "13976"
2) 1) "key9911"
   ...
```

