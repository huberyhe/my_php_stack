[回到首页](../README.md)

# 1. MySQL高级

说明

[TOC]

## 1.1. 分区

指将同一表中不同行的记录分配到不同的物理文件中，几个分区就有几个.idb文件

**使用场景**：一张表的查询速度慢到影响使用；对数据的查询只是特定一部分（热点数据）

**目的**：减少一次查询需要扫描的数据量

**缺点**：

目前MySQL支持一下几种类型的分区，RANGE分区，LIST分区，HASH分区，KEY分区。如果表存在主键或者唯一索引时，分区列必须是唯一索引的一个组成部分。实战十有八九都是用RANGE分区。

1.1 RANGE分区

RANGE分区是实战最常用的一种分区类型，行数据基于属于一个给定的连续区间的列值被放入分区。

当插入的数据不在一个分区中定义的值的时候，会抛异常

```sql
CREATE TABLE `m_test_db`.`Order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `partition_key` INT NOT NULL,
  `amt` DECIMAL(5) NULL,
  PRIMARY KEY (`id`, `partition_key`)
) PARTITION BY RANGE(partition_key) PARTITIONS 5( PARTITION part0 VALUES LESS THAN (201901),  PARTITION part1 VALUES LESS THAN (201902),  PARTITION part2 VALUES LESS THAN (201903),  PARTITION part3 VALUES LESS THAN (201904),  PARTITION part4 VALUES LESS THAN (201905)) ;
```

1.2 LIST分区

LIST分区和RANGE分区很相似，只是分区列的值是离散的，不是连续的。LIST分区使用VALUES IN，因为每个分区的值是离散的，因此只能定义值。

1.3 HASH分区

说到哈希，那么目的很明显了，将数据均匀的分布到预先定义的各个分区中，保证每个分区的数量大致相同。

1.4 KEY分区

KEY分区和HASH分区相似，不同之处在于HASH分区使用用户定义的函数进行分区，KEY分区使用数据库提供的函数进行分区。


> 参考：[搞懂MySQL分区](https://www.cnblogs.com/GrimMjx/p/10526821.html)

## 1.2. 分库分表

**使用场景**：一张表的查询速度慢到影响使用；频繁写入影响查询（并发锁）

**目的**：减少一次查询需要扫描的数据量；减少数据写入对查询的影响

**缺点**：增加了编码的复杂度，查询时需要先找出特定表，多个表需要联合查询

分布式事务：柔性事务是目前主流的方案，TCC模式就属于柔性事务。

> 参考：[MySql分库分表与分区的区别和思考](https://www.cnblogs.com/GrimMjx/p/11772033.html)

## 1.3. 读写分离

## 1.4. 主从复制原理

`binlog` -> 主节点 `log dump thread` 线程-> 从节点I/O线程 -> `relay log` -> 从节点sql进程重放sql

## 1.5. Mycat中间件

官网地址：[Mycat1.6](http://www.mycat.org.cn/)

支持读写分离，分库分表

使用haproxy+keepalived实现高可用

> 参考：
>
> 1、[分库分表中间件工具](https://www.jianshu.com/p/b1395b680818)
>
> 2、[GitHub - MyCATApache/Mycat-Server](https://github.com/MyCATApache/Mycat-Server)
>
> 3、[Mycat安装与配置](https://segmentfault.com/a/1190000022888772)
>
> 4、[mysql读写分离优缺点](https://zhuanlan.zhihu.com/p/358474872)

## 1.6. 常见问题

### 1.6.1. 什么情况下会生成临时表

1. UNION查询；
2. 用到TEMPTABLE算法或者是UNION查询中的视图；
3. ORDER BY和GROUP BY的子句不一样时；
4. 表连接中，ORDER BY的列不是驱动表中的；
5. DISTINCT查询并且加上ORDER BY时；
6. SQL中用到SQL_SMALL_RESULT选项时；
7. FROM中的子查询；
8. 子查询或者semi-join时创建的表；

### 1.6.2. 什么情况下需要回表查询

回表查询：先定位主键值，再定位行记录，它的性能较扫一遍索引树更低。

索引覆盖：只需要在一棵索引树上就能获取SQL所需的所有列数据，无需回表，速度更快。explain的输出结果Extra字段为**Using index**时，能够触发索引覆盖。

>  参考：
>  [MySQL优化：如何避免回表查询？什么是索引覆盖？ (转) - myseries - 博客园 (cnblogs.com)](https://www.cnblogs.com/myseries/p/11265849.html)

### 1.6.3. 聚簇索引、非聚簇索引和辅助索引

- 聚簇索引：将数据存储与索引放到了一块，找到索引也就找到了数据。表数据按照索引的顺序来存储的，也就是说索引项的顺序与表中记录的物理顺序一致。
- 非聚簇索引：将数据存储与索引分开，叶结点包含索引字段值及指向数据页数据行的逻辑指针，其行数量与数据表行数据量一致。

>  参考：[浅谈聚簇索引与非聚簇索引 | Java 技术论坛 (learnku.com)](https://learnku.com/articles/50096)

### 1.6.4. MyISAM与InnoDB引擎适用场景，OLTP与OLAP的概念

OLTP（在线事务处理），如Blog、电子商务、网络游戏等；

OLAP（在线分析处理），如数据仓库、数据集市。

### 1.6.5. MyISAM为什么比InnoDB查询更快

MyISAM在查询主键和非主键时，速度都更快，因为MyISAM要维护的东西更少，比如：

1、数据块，InnoDB要缓存，MyISAM只缓存索引块， 这中间还有换进换出的减少；

2、InnoDB寻址要映射到块，再到行，MyISAM记录的直接是文件的OFFSET，定位比InnoDB要快

3、InnoDB还需要维护MVCC一致； 虽然你的场景没有，但他还是需要去检查和维护MVCC (Multi-Version Concurrency Control)多版本并发控制 。

> 参考：[MySQL中MyISAM为什么比InnoDB查询快](https://www.cnblogs.com/chingho/p/14798021.html)

### 1.6.6. MyISAM与InnoDB中B+树的区别

MyISAM的主索引和普通索引都是非聚族索引，叶子节点不会存放行数据，而是存放的**磁盘地址**

> 参考：
>
> 1、[Innodb和MyIsam在B+树中的区别是什么？](https://blog.csdn.net/weixin_42740530/article/details/106922905)
>
> 2、[MyISAM与InnoDB的索引结构](https://www.cnblogs.com/yuyafeng/p/11350873.html)

### 1.6.7. 行锁、表锁的使用

InnoDB的行锁是针对索引加的锁，不是针对记录加的锁。并且该索引不能失效，否则都会从行锁升级为表锁

- 行锁：

```sql
SET AUTOCOMMIT=0;
BEGIN;
select * from innodb_lock where id=4 for update;// 显式加行锁，须命中索引，不然升级为表锁
update innodb_lock set v='4001' where id=4;
COMMIT;

// 分析表锁定
show status like 'innodb_row_lock%';
```

- 表锁：

```sql
lock table myisam_lock read;// 显式加表锁
...
unlock tables;

// 查看加锁情况
show open tables where in_use > 0;
// 查看表锁
show status like 'table_locks%';
```

> 参考：
> 
> 1、[MySQL 行锁 表锁机制](https://www.cnblogs.com/itdragon/p/8194622.html)
> 
> 2、[INNODB索引实现原理](https://blog.csdn.net/bohu83/article/details/81104432)

### 1.6.8. B+树的结构

B+树的内部节点包括：Key键值，Index索引值
B+树的叶子节点包括：Key键值，Index索引值，Data数据
B+树的内部节点也可称为索引节点，叶子节点也可称为外部节点

> 参考：
> 
> [B+树结构参考](https://www.jianshu.com/p/b395a81d04ee)
> 
> [InnoDB一棵B+树可以存放多少行数据？](https://www.cnblogs.com/leefreeman/p/8315844.html)



### 1.6.9. Procedure Analyse优化表结构

PROCEDURE ANALYSE的语法如下：

```sql
SELECT ... FROM ... WHERE ... PROCEDURE ANALYSE([max_elements,[max_memory]])
```

`max_elements`:指定每列非重复值的最大值，当超过这个值的时候，MySQL不会推荐enum类型。（默认值256）

 `max_memory `（默认值8192）`analyse()`为每列找出所有非重复值所采用的最大内存大小。

执行返回中的Optimal_fieldtype列是mysql建议采用的列。

> 参考：
> [Procedure Analyse优化表结构 ](https://www.cnblogs.com/duanxz/p/3968639.html)

### 1.6.10. 索引的类型划分

#### 1.6.10.1. 按功能逻辑划分

普通索引、主键索引、唯一索引、全文索引

#### 1.6.10.2. 按物理实现划分

聚集索引、非聚集索引

#### 1.6.10.3. 按字段个数划分

单个索引、联合索引

#### 1.6.10.4. 按索引结构划分

常见的有：BTREE、RTREE、HASH、FULLTEXT、SPATIAL

> 参考：[MySQL索引方法 - 成九 - 博客园 (cnblogs.com)](https://www.cnblogs.com/luyucheng/p/6289048.html)

### 1.6.11. 什么场景下应该使用索引

#### 1.6.11.1. 推荐使用

- WHERE, GROUP BY, ORDER BY 子句中的字段

- 多个单列索引在多条件查询是只会有一个最优的索引生效，因此多条件查询中最好创建联合索引。

联合索引的时候必须满足最左匹配原则，并且最好考虑到 sql 语句的执行顺序，比如 WHERE a = 1 GROUP BY b ORDER BY c, 那么联合索引应该设计为 (a,b,c)，因为在上一篇文章 MySQL 基础语法 中我们介绍过，mysql 查询语句的执行顺序 WHERE > GROUP BY > ORDER BY。

- 多张表 JOIN 的时候，对表连接字段创建索引。

- 当 SELECT 中有不在索引中的字段时，会先通过索引查询出满足条件的主键值，然后通过主键回表查询出所有的 SELECT 中的字段，影响查询效率。因此如果 SELECT 中的内容很少，为了避免回表，可以把 SELECT 中的字段都加到联合索引中，这也就是宽索引的概念。但是需要注意，如果索引字段过多，存储和维护索引的成本也会增加。

#### 1.6.11.2. 不推荐使用或索引失效情况

- 数据量很小的表
- 有大量重复数据的字段
- 频繁更新的字段
- 如果对索引字段使用了函数或者表达式计算，索引失效
- innodb OR 条件没有对所有条件创建索引，索引失效
- 大于小于条件 < >，索引是否生效取决于命中的数量比例，如果命中数量很多，索引生效，命中数量很小，索引失效
- 不等于条件 != <>，索引失效
- LIKE 值以 % 开头，索引失效

### 1.6.12. 分布式id生成器

雪花算法：1bit保留+41bit毫秒时间戳+10bit机器ID+12bit序列号=64bit整数

## 1.7. 其他命令

### 1.7.1. `show index from tb_name`查看表索引详细信息

其中`Cardinality`字段表示这个列有多少种值，这个数是近似的可以用 `ANALYZE TABLE tb_name` or (for `MyISAM` tables)`myisamchk -a`更新


> 参考
> MySQL核心手册：[MySQL Internals Manual ](https://dev.mysql.com/doc/internals/en/innodb-page-overview.html)
>
> MySQL参考手册：[MySQL 5.7 Reference Manual]([MySQL :: MySQL 5.7 Reference Manual](https://dev.mysql.com/doc/refman/5.7/en/))

### 1.7.2. `PROCEDURE ANALYSE`优化表结构

```sql
SELECT ... FROM ... WHERE ... PROCEDURE ANALYSE([max_elements,[max_memory]])
```

