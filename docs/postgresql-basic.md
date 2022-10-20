[回到首页](../README.md)

# 1. postgresql基础

说明

[TOC]

## 1.1. 应用场景

## 1.2. 基本概念

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



## 1.3. 终端使用技巧

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

## 1.4. 检查表、表字段是否存在

表字段可以通过检查`INFORMATION_SCHEMA.COLUMNS`表，表可以通过`INFORMATION_SCHEMA.TABLES`表或`to_regclass('${tb_name}')`命令

如果表存在但字段不存在，则执行字段添加语句

```bash
DO
\$do\$
BEGIN
IF (SELECT COUNT(*) AS ct1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '${tb_name}' AND COLUMN_NAME = '${column_name}' ) = 0
AND to_regclass('${tb_name}') IS NOT NULL
THEN
    ALTER TABLE ${tb_name} ADD COLUMN ${column_name} ${column_define};
END IF;
END;
\$do\$;
```

## 1.5. 导入导出

导出：`pg_dump -t table_name db_name > db.sql`

导入：`psql -d db_name -f db.sql`或者`pg_restore -d db_name db.sql`

> 参考：
>
> 1、[PostgreSQL 角色管理](https://www.cnblogs.com/mchina/archive/2013/04/26/3040440.html)
>
> 2、[How to Dump and Restore PostgreSQL Database (netguru.com)](https://www.netguru.com/blog/how-to-dump-and-restore-postgresql-database)

## 1.6. 常用内置函数

### 1.6.1. 格式转换

```sql
select to_timestamp('2022-10-10 15:37:36.401', 'yyyy-MM-dd hh24:mi:ss.MS')::timestamp at time zone 'Asia/Shanghai' > to_timestamp(1665387456);
```