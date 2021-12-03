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

`SELECT ... INTO OUTFILE`导出的结果会放到mysql服务器端，所以实际少用。

```sql
mysql -uroot -p dbname -e 'SELECT * FROM table_name WHERE create_time < 1382716800' -N -s > /home/temp.txt
```

> 注：
>
> - -e：执行sql命令
> - -N：去掉抬头
> - -s：去掉标准的分割线

## 3、数据类型

### 数字型

| **类型**     | **大小**                                 | **范围（有符号）**                                           | **范围（无符号）**                                           | **用途**        |
| ------------ | ---------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | --------------- |
| TINYINT      | 1 字节                                   | (-128，127)                                                  | (0，255)                                                     | 小整数值        |
| SMALLINT     | 2 字节                                   | (-32 768，32 767)                                            | (0，65 535)                                                  | 大整数值        |
| MEDIUMINT    | 3 字节                                   | (-8 388 608，8 388 607)                                      | (0，16 777 215)                                              | 大整数值        |
| INT或INTEGER | 4 字节，2^32                             | (-2 147 483 648，2 147 483 647)                              | (0，4 294 967 295)                                           | 大整数值        |
| BIGINT       | 8 字节                                   | (-9 233 372 036 854 775 808，9 223 372 036 854 775 807)      | (0，18 446 744 073 709 551 615)                              | 极大整数值      |
| FLOAT        | 4 字节                                   | (-3.402 823 466 E+38，1.175 494 351 E-38)，0，(1.175 494 351 E-38，3.402 823 466 351 E+38) | 0，(1.175 494 351 E-38，3.402 823 466 E+38)                  | 单精度 浮点数值 |
| DOUBLE       | 8 字节                                   | (1.797 693 134 862 315 7 E+308，2.225 073 858 507 201 4 E-308)，0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308) | 0，(2.225 073 858 507 201 4 E-308，1.797 693 134 862 315 7 E+308) | 双精度 浮点数值 |
| DECIMAL      | 对DECIMAL(M,D) ，如果M>D，为M+2否则为D+2 | 依赖于M和D的值                                               | 依赖于M和D的值                                               | 小数值          |

无符号整数用法:

```sql
CREATE TABLE t7(
    id INT AUTO_INCREMENT PRIMARY KEY,
    url VARCHAR(40),
    crcurl INT UNSIGNED NOT NULL DEFAULT 0
);
```

### 字符类型

| CHAR       | 0-255字节             | 定长字符串                      |
| ---------- | --------------------- | ------------------------------- |
| VARCHAR    | 0-255字节/0-65535字节 | 变长字符串                      |
| TINYBLOB   | 0-255字节             | 不超过 255 个字符的二进制字符串 |
| TINYTEXT   | 0-255字节             | 短文本字符串                    |
| BLOB       | 0-65 535字节          | 二进制形式的长文本数据          |
| TEXT       | 0-65 535字节          | 长文本数据                      |
| MEDIUMBLOB | 0-16 777 215字节      | 二进制形式的中等长度文本数据    |
| MEDIUMTEXT | 0-16 777 215字节      | 中等长度文本数据                |
| LOGNGBLOB  | 0-4 294 967 295字节   | 二进制形式的极大文本数据        |
| LONGTEXT   | 0-4 294 967 295字节   | 极大文本数据                    |

### 枚举集合

ENUM （最多65535个成员）                    64KB
SET （最多64个成员）                      64KB

### 时间类型

一般用datetime和bigint存储时间戳，不受时区影响。

| **类型**  | **大小 (字节)** | **范围**                                | **格式**            | **用途**                 |
| --------- | --------------- | --------------------------------------- | ------------------- | ------------------------ |
| DATE      | 3               | 1000-01-01/9999-12-31                   | YYYY-MM-DD          | 日期值                   |
| TIME      | 3               | '-838:59:59'/'838:59:59'                | HH:MM:SS            | 时间值或持续时间         |
| YEAR      | 1               | 1901/2155                               | YYYY                | 年份值                   |
| DATETIME  | 8               | 1000-01-01 00:00:00/9999-12-31 23:59:59 | YYYY-MM-DD HH:MM:SS | 混合日期和时间值         |
| TIMESTAMP | 4               | 1970-01-01 00:00:00/2037 年某时         | YYYYMMDD HHMMSS     | 混合日期和时间值，时间戳 |

## 4、MySQL官方示例数据库

[MySQL :: Other MySQL Documentation](https://dev.mysql.com/doc/index-other.html)

## 5、数据库设计三大范式

1. 第一范式(确保每列保持原子性)

   所有字段值都是不可分解的原子值

2. 第二范式(确保表中的每列都和主键相关)

   第二范式在第一范式的基础之上更进一层。第二范式需要确保数据库表中的每一列都和主键相关，而不能只与主键的某一部分相关（主要针对联合主键而言）。也就是说在一个数据库表中，一个表中只能保存一种数据，不可以把多种数据保存在同一张数据库表中。

3. 第三范式(确保每列都和主键列直接相关,而不是间接相关)

   第三范式需要确保数据表中的每一列数据都和主键直接相关，而不能间接相关。

优点：采用范式可以降低数据的冗余性。

缺点：获取数据时，需要通过Join拼接出最后的数据。

> 参考：
>
> 1、[数据库设计三大范式 - Ruthless - 博客园 (cnblogs.com)](https://www.cnblogs.com/linjiqin/archive/2012/04/01/2428695.html)
>
> 2、[数据库逻辑设计之三大范式通俗理解，一看就懂，书上说的太晦涩 - SegmentFault 思否](https://segmentfault.com/a/1190000013695030)

## 6、哪些列适合创建索引

1. 在where条件常使用的字段 。
2. 该字段的内容不是唯一的几个可选值，而是有较丰富的取值选项的字段 。
3. 该字段内容不是频繁变化的。
