[回到首页](../README.md)

# postgresql基础

说明

[TOC]

## 1、应用场景

## 2、基本概念

1.1、权限控制：角色与用户

1.2、数据的导入导出

导出：

```bash
pg_dump database_name > database_name_20160527.sql
```

导入：

```bash
psql template1 -c 'drop database database_name;'
psql template1 -c 'create database database_name with owner your_user_name;
psql database_name < database_name_20160527.sql
```



## 3、终端使用技巧

2.1、帮助文档使用`\?`命令

2.2、按列展示使用`\x`命令，类似mysql的`\G`结尾和sqlite的`.mode column`设置

```bash
mydb=# select * from test;
 id | name 
----+------
  1 | mike
(1 row)

mydb=# \x
Expanded display is on.
mydb=# select * from test;
-[ RECORD 1 ]
id   | 1
name | mike

mydb=# 

```



> 参考：
>
> 1、[PostgreSQL 角色管理](https://www.cnblogs.com/mchina/archive/2013/04/26/3040440.html)
>
> 2、[How to Dump and Restore PostgreSQL Database (netguru.com)](https://www.netguru.com/blog/how-to-dump-and-restore-postgresql-database)
