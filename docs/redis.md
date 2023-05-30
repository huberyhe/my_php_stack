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

### 1.1.3. List（列表）

Redis 列表是简单的字符串列表，按照插入顺序排序。你可以添加一个元素到列表的头部（左边）或者尾部（右边）。

列表最多可存储 2^32 - 1 元素 (4294967295, 每个列表可存储40多亿)。

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


### 1.1.4. Set（集合）

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



### 1.1.5. zset(sorted set：有序集合)

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

redis的事务不具备“原子性”，而仅仅满足了事务的“隔离性”中的串行化，保证当前执行的事务部不被其他事务打断

开启：`MULTI`

提交：`EXEC`

取消：`DISCARD`

## 1.3. 常见应用

### 1.3.1. 消息排队、异步逻辑处理

利用list的`rpush`+`lpop`模拟队列的先进先出，`llen`获取队列长度，`blpop`可实现阻塞读

缺点：空闲连接自动断开，应在代码中捕获异常并重试

### 1.3.2. 分布式锁

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

### 1.3.3. 延迟队列

加锁失败后放入延迟队列，延后处理避免冲突

延迟队列可以用zset实现，消息序列化后作为value，消息过期时间作为score，多个线程轮询这个zset获取到期的任务进行处理。

每次取一条消息，取到后zrem删除，删除成功才代表抢到了任务

缺点：zrangebyscore和zrem使用lua脚本实现原子化操作，避免抢占浪费

### 1.3.4. 使用位图实现签到功能

### 1.3.5. HyperLogLog统计UV

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

### 1.3.6. 布隆过滤器

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

### 1.3.7. 简单限流

限定用户某个行为在指定时间范围内只允许发生N次

使用zset数据结构，记录用户的行为历史，key是用户+行为，value和score都是毫秒时间戳

### 1.3.8. 漏斗限流

redis 4.0提供了限流模块Redis-Cell，提供了原子的限流指令`cl.throttle`

### 1.3.9. 位置模块GeoHash

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

### 1.3.10. 匹配键scan

keys可以模糊匹配，但是会一次返回所有符合条件的key，scan的改进在于每次只返回一部分和游标cursor，当cursor=0时表示遍历完毕。

```
> scan 0 match key99* count 1000
1) "13976"
2) 1) "key9911"
   ...
```

## 1.4. 持久化

### 1.4.1. 快照

- 特点：全量备份，将内存数据进行二进制序列化到磁盘。备份时会fork出一个子进程
- 触发时机：根据配置（开启or关闭）停止时写入，启动时加载；或者手动执行命令
- 命令：`bgsave`

### 1.4.2. AOF

- 特点：增量备份，记录修改内存的指令。
- 触发时机：每次修改之后，记录修改的指令。根据配置（每次、每n秒、从不）写入磁盘
- 命令：使用`bgrewriteaof`用于对AOF日志进行瘦身；使用`fsync`库函数保证日志可以写到磁盘不丢失

### 1.4.3. 持久化策略

1、持久化在从节点进行

2、实时监控，保证网络畅通或者能快速修复

3、增加备份从节点，提高容错

4、redis 4.0混合持久化：rdb文件和aof日志文件存在一起，重启时先加载rdb内容，再重放aof日志

5、配置aof的`fsync`策略：通常每隔1s左右执行一次`fsync`

## 1.5. 集群

### 1.5.1. 同步模式

主从同步、从从同步：集群中为减轻主节点的压力，可以使用*从从同步*和*无盘复制*

快照同步，增量同步：从节点加入到集群时，先进行一次快照同步，同步完成后再继续进行增量同步

CAP原理：当网络分区发生时，一致性和可用性两难全。两节点无法通信时，一个节点数据的修改无法同步到另外一个节点，所以数据的一致性无法满足，除非牺牲可用性，停止提供修改数据的功能。

redis数据是异步同步的，不满足一致性要求，只保证最终一致性。使用`wait`指令可确数据修改后的强一致性。

### 1.5.2. 哨兵模式 Sentinel

一种集群高可用方案，Sentinel持续监控主节点的健康，当主节点挂掉时，自动选择一个最优的从节点切换成主节点。客户端来需要通过Sentinel来查询主节点的地址

Sentinel可以尽量保证数据不丢失。以下配置表示：至少有一个从节点在进行正常复制，否则就停止对外写服务；如果超过10s没有收到从节点的反馈，则表示该从节点同步不正常。

```config
min-slaves-to-write 1
min-slaves-max-lag 10
```

### 1.5.3. Codis分片

一种大数据高并发方案，是一个代理中间件。

分片原理：Codis负责将特定的key转发到特定的实例，将key进行crc32哈希后对1024取模，余数就是对应key的槽位

缺点：不支持事务，不支持rename，增加了网络开销（代理），需要zookeeper存储槽位关系

### 1.5.4. Cluster集群

官方集群方案，

1、去中心化

2、同时实现高可用和分片

3、需要客户端支持。

## 1.6. 消息队列

### 1.6.1. 列表

使用`lpush`和`rpush`入列，`lpop`和`rpop`出列，`blpop`和`brpop`阻塞出列

### 1.6.2. 有序集合

消息序列化作为value，到期时间作为score。使用`zrangebyscore`查询任务，配合`zrem`来争抢任务

### 1.6.3. 发布订阅

发送者发送消息到指定频道，订阅者订阅频道并从频道中接收消息。接收者会丢失离线状态时的消息，且不支持持久化

### 1.6.4. stream

可持久化，保证可靠性的消息队列，类似kafka

消费队列：

1、`xadd`追加消息

2、`xdel`删除消息

3、`xrange`获取消息

4、`xlen`获取消息队列长度

5、`del`清空队列消息

6、`xread`消费消息，支持阻塞

消费组：

7、`xgroup create`创建消费组

8、`xreadgroup group`读取消费组中的消息

9、`xack`将消息标记为已处理

## 1.7. 过期和淘汰策略

### 1.7.1. 过期策略

定时扫描（默认10s），采用贪心策略。

1、从过期字典中随机跳转20个key，

2、删除其中过期的key，

3、如果过期的key的比例超过1/4，就重复1，直到过期字典中过期key变得稀疏。

另外也使用惰性策略来删除过期的key，请求达到时检查key是否过期，过期则删除。

### 1.7.2. 内存淘汰策略

当redis内存使用超过物理内存限制时，内存的数据开始和磁盘产生频繁的交换。生产环境应避免这种情况，配置`maxmemory`来限制内存使用限制，配置`maxmemory-policy`来腾出内存空间

- noeviction: 停止写服务，默认
- valatile-lru: 设置了过期时间的key中最少使用的key
- volatile-ttl: 最早过期时间
- volatile-random: 随机
- allkeys-lru: 所有key中最少使用的key
- allkeys-random: 随机

## 1.8. lua脚本

调用lua脚本可以实现原子操作，作用就类似于加了MULTI/EXEC

命令格式：

```bash
EVAL script numkeys key [key ...] arg [arg ...]
```

注意：脚本不允许操作传参以外的key

实例，检查key存在，存在则设置某个hash字段

```bash
eval "if redis.call('exists', KEYS[1]) == 1 then redis.call('hset', KEYS[1], ARGV[1], 1) end" 1 59205FE8-3ADB-9A25-2755-72A8F6EC2CBE Reload
```

> 参考：
> 1、[Scripting with Lua | Redis](https://redis.io/docs/manual/programmability/eval-intro/)
> 2、[EVAL – Redis (cndoc.github.io)](https://cndoc.github.io/redis-doc-cn/cn/commands/eval.html)

## 1.9. 系统命令

### 1. 查看状态 info

```
127.0.0.1:17490> info memory
# Memory
used_memory:1168904
used_memory_human:1.11M
used_memory_rss:2777088
used_memory_rss_human:2.65M
used_memory_peak:1234360
used_memory_peak_human:1.18M
total_system_memory:8200286208
total_system_memory_human:7.64G
used_memory_lua:37888
used_memory_lua_human:37.00K
maxmemory:0
maxmemory_human:0B
maxmemory_policy:noeviction
mem_fragmentation_ratio:2.38
mem_allocator:libc

```

### 2. 生成快照 SAVE/BGSAVE

### 3. 查看配置 config 

查看安装目录

```
127.0.0.1:17490> config get dir
1) "dir"
2) "/opt/topsec/topihs/redis/var/lib/redis"
```

查看认证配置

```
127.0.0.1:17490> CONFIG get requirepass
1) "requirepass"
2) ""
```

查看自动快照配置

```
127.0.0.1:17490> config get save
1) "save"
2) "900 1 300 10 60 10000"
```