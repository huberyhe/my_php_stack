[回到首页](../README.md)

# MySQL常用命令

[TOC]

## 1、查看所有表信息

```bash
##查看所有表信息
SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'apyun'
##查看各个表数据量
SELECT table_name,table_rows FROM information_schema.tables
WHERE TABLE_SCHEMA = 'apyun' ORDER BY table_rows DESC;
```

## 2、导入导出数据

```bash
# 导出表结构
mysqldump -uroot -p -d dbname > dbname.sql
# 导出表数据
mysqldump -uroot -p -t dbname > dbname.sql
# 导出表结构和表数据
mysqldump -uroot -p dbname > dbname.sql
# 导出时指定表
mysqldump -uroot -p dbname --tables tbname1 tbname2 > dbname.sql
# 导出时过滤表
mysqldump -uroot -p dbname --ignore-table=dbname.tbname --ignore-table=dbname.tbname2 > dbname.sql
```

```sql
# 导入
CREATE DATABASE dbname DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
mysql -uroot -p dbname < /path/dbname.sql
# 或者
source dbname.sql

# 导出select后的数据，可用于导出成csv格式
SELECT * INTO OUTFILE '/home/temp.txt'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
FROM table_name
WHERE createtime < 1382716800;

# 导入select后的数据
LOAD DATA INFILE '/home/temp.txt'
INTO TABLE table_name
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n'
(product_id,uuid,mac,monitor,win_version,ip,createtime);
# 注：从本地导入远程服务器需使用LOAD DATA LOCAL INFILE
```

`SELECT ... INTO OUTFILE`导出的结果会放到mysql服务器端，所以实际少用

```sql
mysql -uroot -p dbname -e 'SELECT * FROM table_name WHERE create_time < 1382716800' -N -s > /home/temp.txt
```

> 注：
>
> - -e：执行sql命令
> - -N：去掉抬头
> - -s：去掉标准的分割线