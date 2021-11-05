[回到首页](../README.md)

# 样例

说明

[TOC]

## 1、分区

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

## 2、分库分表

**使用场景**：一张表的查询速度慢到影响使用；频繁写入影响查询（并发锁）

**目的**：减少一次查询需要扫描的数据量；减少数据写入对查询的影响

**缺点**：增加了编码的复杂度，查询时需要先找出特定表，多个表需要联合查询

分布式事务：柔性事务是目前主流的方案，TCC模式就属于柔性事务。

> 参考：[MySql分库分表与分区的区别和思考](https://www.cnblogs.com/GrimMjx/p/11772033.html)

## 3、读写分离

## 4、主从复制原理

`binlog` -> 主节点 `log dump thread` 线程-> 从节点I/O线程 -> `relay log` -> 从节点sql进程重放sql

## 5、Mycat中间件

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

## 6、常见问题

6.1、什么情况下会生成临时表

1. UNION查询；
2. 用到TEMPTABLE算法或者是UNION查询中的视图；
3. ORDER BY和GROUP BY的子句不一样时；
4. 表连接中，ORDER BY的列不是驱动表中的；
5. DISTINCT查询并且加上ORDER BY时；
6. SQL中用到SQL_SMALL_RESULT选项时；
7. FROM中的子查询；
8. 子查询或者semi-join时创建的表；

6.2、什么情况下需要回表查询

回表查询：先定位主键值，再定位行记录，它的性能较扫一遍索引树更低。

索引覆盖：只需要在一棵索引树上就能获取SQL所需的所有列数据，无需回表，速度更快。explain的输出结果Extra字段为**Using index**时，能够触发索引覆盖。

>  参考：[MySQL优化：如何避免回表查询？什么是索引覆盖？ (转) - myseries - 博客园 (cnblogs.com)](https://www.cnblogs.com/myseries/p/11265849.html)

6.3、聚簇索引、非聚簇索引和辅助索引

- 聚簇索引：将数据存储与索引放到了一块，找到索引也就找到了数据。表数据按照索引的顺序来存储的，也就是说索引项的顺序与表中记录的物理顺序一致。
- 非聚簇索引：将数据存储与索引分开，叶结点包含索引字段值及指向数据页数据行的逻辑指针，其行数量与数据表行数据量一致。

>  参考：[浅谈聚簇索引与非聚簇索引 | Java 技术论坛 (learnku.com)](https://learnku.com/articles/50096)

6.3、MyISAM与InnoDB引擎适用场景，OLTP与OLAP的概念

OLTP（在线事务处理），如Blog、电子商务、网络游戏等；

OLAP（在线分析处理），如数据仓库、数据集市。

6.4、行锁、表锁的使用

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

// 查看枷锁情况
show open tables where in_use > 0;
// 查看表锁
show status like 'table_locks%';
```

> 参考：[MySQL 行锁 表锁机制](https://www.cnblogs.com/itdragon/p/8194622.html)
>
> [INNODB索引实现原理_bohu83的博客-CSDN博客_innodb的索引实现](https://blog.csdn.net/bohu83/article/details/81104432)

> MySQL核心手册：[MySQL Internals Manual ](https://dev.mysql.com/doc/internals/en/innodb-page-overview.html)
>
> MySQL参考手册：[MySQL 5.7 Reference Manual]([MySQL :: MySQL 5.7 Reference Manual](https://dev.mysql.com/doc/refman/5.7/en/))

