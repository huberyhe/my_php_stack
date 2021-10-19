[回到首页](../README.md)

# 样例

说明

[TOC]

## 1、分区

指将同一表中不同行的记录分配到不同的物理文件中，几个分区就有几个.idb文件

目前MySQL支持一下几种类型的分区，RANGE分区，LIST分区，HASH分区，KEY分区。如果表存在主键或者唯一索引时，分区列必须是唯一索引的一个组成部分。实战十有八九都是用RANGE分区。

1.1 RANGE分区

RANGE分区是实战最常用的一种分区类型，行数据基于属于一个给定的连续区间的列值被放入分区。

当插入的数据不在一个分区中定义的值的时候，会抛异常

```sql
CREATE TABLE `m_test_db`.`Order` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `partition_key` INT NOT NULL,
  `amt` DECIMAL(5) NULL,
  PRIMARY KEY (`id`, `partition_key`)) PARTITION BY RANGE(partition_key) PARTITIONS 5( PARTITION part0 VALUES LESS THAN (201901),  PARTITION part1 VALUES LESS THAN (201902),  PARTITION part2 VALUES LESS THAN (201903),  PARTITION part3 VALUES LESS THAN (201904),  PARTITION part4 VALUES LESS THAN (201905)) ;
```

1.2 LIST分区

LIST分区和RANGE分区很相似，只是分区列的值是离散的，不是连续的。LIST分区使用VALUES IN，因为每个分区的值是离散的，因此只能定义值。

1.3 HASH分区

说到哈希，那么目的很明显了，将数据均匀的分布到预先定义的各个分区中，保证每个分区的数量大致相同。

1.4 KEY分区

KEY分区和HASH分区相似，不同之处在于HASH分区使用用户定义的函数进行分区，KEY分区使用数据库提供的函数进行分区。



> 参考：[搞懂MySQL分区](https://www.cnblogs.com/GrimMjx/p/10526821.html)

## 2、分库分表

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

> MySQL核心手册：[MySQL Internals Manual ](https://dev.mysql.com/doc/internals/en/innodb-page-overview.html)
>
> MySQL参考手册：[MySQL 5.7 Reference Manual]([MySQL :: MySQL 5.7 Reference Manual](https://dev.mysql.com/doc/refman/5.7/en/))

