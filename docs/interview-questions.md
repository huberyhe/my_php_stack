[回到首页](../README.md)

# 1. 常见面试题

说明

[TOC]

## 1.1. 抽象类与接口的区别

- 对接口的使用是通过关键字implements。对抽象类的使用是通过关键字extends。当然接口也可以通过关键字extends继承。
- 接口中不可以声明成员变量（包括类静态变量），但是可以声明类常量。抽象类中可以声明各种类型成员变量，实现数据的封装。（另JAVA接口中的成员变量都要声明为public static final类型）
- 接口没有构造函数，抽象类可以有构造函数。
- 接口中的方法默认都是public类型的，而抽象类中的方法可以使用private,protected,public来修饰。
- 一个类可以同时实现多个接口，但一个类只能继承于一个抽象类。

- **类可以实现多个接口**，前提是这些接口中方法不重复；抽象类中可以包含已实现的方法（非抽象）和抽象方法，抽象方法必须被子类实现

> 参考：
>
> 1、[PHP的抽象类、接口的区别和选择 - SegmentFault 思否](https://segmentfault.com/a/1190000016607792)
>
> 2、[接口和抽象类有什么区别？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/20149818/answer/704355929)

## 1.2. 在浏览器中打开一个url，发生了什么

1. 孤单小弟 —— HTTP

2. 真实地址查询 —— DNS

3. 指南好帮手 —— 协议栈

4. 可靠传输 —— TCP

5. 远程定位 —— IP

6. 两点传输 —— MAC

7. 出口 —— 网卡

8. 送别者 —— 交换机
9. 出境大门 —— 路由器

10. 互相扒皮 —— 服务器 与 客户端

>  参考：
>
> 1、[电脑上打开浏览器，输入 www.baidu.com，回车，到百度页面出现。中间发生了什么？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/437193010/answer/2065582348)

## 1.3. 七层OSI网络模型与TCP/IP网络模型、五层网络模型

OSI体系结构：物理层、数据链路层、网络层、传输层、会话层、表示层、应用层

TCP/IP体系结构：网络接口层、网际层IP、运输层、应用层

五层协议：物理层、数据链路层、网络层（IP协议、ICMP、ARP、RARP）、运输层（TCP/UDP协议）、应用层（DNS、HTTP）

> 参考：[计算机网络的七层结构、五层结构和四层结构 - SegmentFault 思否](https://segmentfault.com/a/1190000039204681)

## 1.4. 缓存穿透、击穿、雪崩

参考：[缓存-常见缓存问题](cache.md)

## 1.5. 并发锁机制

## 1.6. HTTP是长连接还是短连接

http/1.0中默认使用短连接，从http/1.1开始默认使用长连接

参考：[HTTP长连接、短连接究竟是什么？](https://www.cnblogs.com/gotodsp/p/6366163.html)

## 1.7. 查询计划字段的含义

```
MySQL [mysql]> explain select * from user;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------+
|  1 | SIMPLE      | user  | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    4 |   100.00 | NULL  |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------+

```

- id：查询序号
- select_type：查询类型
- table：表名
- partitions：匹配的分区
- type：使用的连接类别，有无使用索引*
- possible_keys：可能会选择的索引
- key：实际选择的索引
- key_len：索引的长度
- ref：与索引作比较的列
- rows：要检索的行数（估算值）*
- filtered：查询条件过滤的行数的百分比
- Extra：额外信息*

> 参考：
>
> 1、[了解MySQL中EXPLAIN解释命令 - SegmentFault 思否](https://segmentfault.com/a/1190000018729502)
>
> 2、[explain结果每个字段的含义说明 - 简书 (jianshu.com)](https://www.jianshu.com/p/8fab76bbf448)

## 1.8. xss与csrf

XSS：跨站脚本（Cross-site scripting，通常简称为XSS）是一种网站应用程序的安全漏洞攻击，是代码注入的一种。它允许恶意用户将代码注入到网页上，其他用户在观看网页时就会受到影响。**这类攻击通常包含了HTML以及用户端脚本语言**。

CSRF:跨站请求伪造（英语：Cross-site request forgery），也被称为 one-click attack 或者 session riding，通常缩写为 CSRF 或者 XSRF， 是一种挟制用户在当前已登录的Web应用程序上**执行非本意的操作的攻击方法**。

>  参考：[用大白话谈谈XSS与CSRF - SegmentFault 思否](https://segmentfault.com/a/1190000007059639)

## 1.9. text等类型的长度，varchar指定长度有什么作用，与text的区别

char的上限为255字节，varchar的上限65535字节，text的上限为65535。

1、char，存定长，速度快，存在空间浪费的可能，会处理尾部空格，上限255。

2、varchar，存变长，速度慢，不存在空间浪费，不处理尾部空格，上限65535，但是有存储长度实际65532最大可用。

3、text，存变长大数据，速度慢，不存在空间浪费，不处理尾部空格，上限65535，会用额外空间存放数据长度，故可以全部使用65535。

varchar与text区别：

1、text没有默认值

2、创建索引时，text只能添加前缀索引，并且前缀索引最大只能达到1000字节。

3、varchar可以指定最大长度，text只能是固定最大长度

4、存储相同数据时，VARCHAR与表内联存储（至少对于MyISAM存储引擎而言），因此在大小合理时可能会更快

>  参考：
>
> 1、[MySQL之char、varchar和text的设计 - billy鹏 - 博客园 (cnblogs.com)](https://www.cnblogs.com/billyxp/p/3548540.html)
>
> 2、[MySQL InnoDB存储引擎的行结构 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/419496579)
>
> 3、[InnoDB存储引擎之 行结构-王者之路-青山依舊 (xiangerfer.com)](http://www.xiangerfer.com/?thread-119.htm)

## 1.10. 实际项目中应用到的设计模式

## 1.11. 动态规划算法

## 1.12. 常见概念：

12.1、 微服务：微服务是一种开发软件的架构和组织方法，其中软件由通过明确定义的 API 进行通信的小型独立服务组成。这些服务由各个小型独立团队负责。微服务架构使应用程序更易于扩展和更快地开发，从而加速创新并缩短新功能的上市时间。

12.2、B+树：叶子节点顺序存储关键字，方便范围查询；

12.3、红黑树：二叉平衡树

12.4、hash表：**散列表**（**Hash table**，也叫**哈希表**），是根据键（Key）而直接访问在内存储存位置的数据结构。也就是说，它通过计算出一个键值的函数，将所需查询的数据映射到表中一个位置来让人访问，这加快了查找速度。这个映射函数称做散列函数，存放记录的数组称做**散列表**。

12.5、单点登录：又称SSO（Single Sign On），在多个应用系统中，用户只需要登录一次就可以访问所有相互信任的应用系统。

## 1.13. PHP数组的底层实现

底层实现为散列表(HashTable，也称作：哈希表)

> 参考：
>
> 1、[PHP7 数组的底层实现 | Laravel China 社区 (learnku.com)](https://learnku.com/articles/33225)
>
> 2、[php7-internal/zend_ht.md at master · pangudashu/php7-internal (github.com)](https://github.com/pangudashu/php7-internal/blob/master/2/zend_ht.md)

## 1.14. ddos攻击防范

1、备份网站：最低限度有一个临时主页，可以发出公告

2、拦截请求，识别异常的流量

3、带宽扩容：多台主机，通过DNS分摊访问量

4、CDN，如cloudflare

>  参考：
>
>  1、[DDOS 攻击的防范教程 - 阮一峰的网络日志 (ruanyifeng.com)](https://www.ruanyifeng.com/blog/2018/06/ddos.html)
>
>  2、[防御DDoS攻击教程_常见DDoS攻击防御方法_DDoS攻击防范方法](https://www.huaweicloud.com/zhishi/dyl41.html)


## 1.15. 如何防止重复提交

表单中带上隐藏域内容是这个表单的token，表单提交时判断这个token有没有使用过：

1. token信息放到session里；
2. token信息放到缓存里

## 1.16. flask的生命周期

## 1.17. 列举索引失效的情况

```sql
create table test {
    a varchar(50),
    b int,
    c int,
    index idx_a_b(`a`,`b`)
}
```

- `select * from test where a = '1' or b = 2;`
- `select * from test where a = 1;`
- `select * from test where b = 2;`
- `select * from test where a like '%hhh';`
- `select * from test where date(b) = '2021-11-02';`
- `select * from test where a not in ('jack','mike');  `
- `select * from test where a is not null;` // `is null`会走索引

## 1.18. redis中字典与hash表的区别

[从HashMap，Redis 字典看【Hash】。。。 - 掘金 (juejin.cn)](https://juejin.cn/post/6844903927524098055)

## 1.19. 大量数据下，如何查最后几条数据

```sql
create table user {
	`id` int(10) unsigned AUTO_INCREMENT,
	`username` varchar(100) DEFAULT NULL,
	`password` char(32) NOT NULL COMMENT '6-20',
	PRIMARY KEY (`id`)
} ENGINE=InnoDB DEFAULT charset=utf8mb4;
```

假设表里有1千万条数据，如何查第1万页数据

方法1：估算起始的主键id，这里一定是id > 10000*20。

```sql
select id,username,`password` from user where id > 200000 limit 0,20;
```

方法2：利用表的**覆盖索引/延迟关联**来加速分页查询。先找到主键，再查主键匹配的记录，只需要一次回表查询

```sql
SELECT * FROM user WHERE id > =(select id from user limit 200000, 1) limit 20;
SELECT * FROM user a JOIN (select id from user limit 200000, 20) b ON a.id = b.id;
```

> 参考：
>
> 1、[MySQL 延迟关联优化超多分页场景](http://qidawu.github.io/2019/11/26/mysql-deferred-join/)
>
> 2、[MySQL 分页查询优化——延迟关联优化](https://www.cnblogs.com/pufeng/p/11750495.html)

## 1.20. 存在大量数据的表，如何添加索引才能不影响业务（锁表）

方法一：创建临时表，导入数据添加索引之后再升级成正式表

方法二：在从库上添加索引，然后切换成主库

方法三：Online DDL，从 MySQL 5.6 开始，引入了 inplace 算法并且默认使用。有一些第三方工具也可以实现 DDL 操作，最常见的是 percona 的 pt-online-schema-change 工具（简称为 pt-osc），和 github 的 [gh-ost](https://github.com/github/gh-ost) 工具，均支持 MySQL 5.5 以上的版本。

一般情况下的建议：

- 如果使用的是 MySQL 5.5 或者 MySQL 5.6，推荐使用 gh-ost
- 如果使用的是 MySQL 5.7，索引等不涉及修改数据的操作，建议使用默认的 inplace 算法。如果涉及到修改数据（例如增加列），不关心主从同步延时的情况下使用默认的 inplace 算法，关心主从同步延时的情况下使用 gh-ost
- 如果使用的是 MySQL 8.0，推荐使用 MySQL 默认的算法设置，在语句不支持 instant 算法并且在意主从同步延时的情况下使用 gh-ost

> 参考：
>
> 1、[加索引可能引发的事故，我们要心中有数](https://juejin.cn/post/6844904193531052040)
>
> 2、[分享一次生产MySQL数据库主备切换演练](https://database.51cto.com/art/201909/602502.htm)
>
> 3、[MySQL 5.7 特性：Online DDL](https://cloud.tencent.com/developer/article/1697076)
>
> 4、[MySQL5.7—在线DDL总结_一个笨小孩](https://blog.51cto.com/fengfeng688/1956827)

## 1.21. 是先导入数据，还是先添加索引

先导入数据，避免每条数据都去维护索引

## 1.22. 进程间通信有哪些方式

- 管道
- 消息队列
- 共享内存
- 信号量
- socket

## 1.23. 面试经验

1、hr要代码截图：直接不要给了，面试官总能挑出毛病，很可能因为代码风格认为不合适

2、面试结束了，面试官问有啥问题要问的：觉得面的还可以的话，问下团队的情况；如果觉得面试一般，可以问下题目的正确答案

## 1.24. 常见web身份认证方式

- Cookie + Session 登录
- Token 登录，常用[JWT](https://www.ruanyifeng.com/blog/2018/07/json_web_token-tutorial.html)，可用于分布式认证，也可解决跨域的问题

形式如：Header.Payload.Signature

header和payload是base64url加密后的json字符串

header包含签名算法，默认算法是HMAC SHA256（写成 HS256）

- SSO 单点登录
- OAuth 第三方登录
- HMAC

> 参考：[前端登录，这一篇就够了](https://juejin.cn/post/6845166891393089544)

SSO整体陈述

1. 单点登录涉及SSO认证中心与多个子系统，子系统与SSO认证中心需要通信（交换令牌、校验令牌及发起注销请求等），子系统中包含SSO的客户端，SSO认证中心是服务端
2. 认证中心与客户端通信可通过 httpClient、web service、rpc、restful api（url是其中一种） 等实现
3. 客户端与服务器端的功能
   1. 客户端：
      1. 拦截子系统未登录用户请求，跳转至sso认证中心
      2. 接收并存储sso认证中心发送的令牌
      3. 与服务器端通信，校验令牌的有效性
      4. 建立局部会话
      5. 拦截用户注销请求，向sso认证中心发送注销请求
      6. 接收sso认证中心发出的注销请求，销毁局部会话
   2. 服务器端：
      1. 验证用户的登录信息
      2. 创建全局会话
      3. 创建授权令牌
      4. 与客户端通信发送令牌
      5. 校验客户端令牌有效性
      6. 系统注册
      7. 接收客户端注销请求，注销所有会话

## 1.25. 系统回答MySQL优化

从一下几个方面回答：

1、字段

2、表引擎

3、索引

4、查询缓存

5、分区和分表

6、集群和读写分离

7、

> 参考：[MySQL优化/面试，看这一篇就够了](https://juejin.cn/post/6844903750839058446)

## 1.26. poll、epoll、select、reactor的IO多路复用

## 1.27. HTTP2的改进之处

1、对于常见的HTTP头部通过静态表和哈夫曼编码的方式，将体积缩小了近一半，而且针对后续的请求头部，还可以建立动态表，将体积压缩近90%

2、HTTP2实现了Stream并发，多个Stream只复用1个TCP连接

3、服务器支持主动推送资源

## 1.28. 如何判断一个二叉树是平衡二叉树

树中每个节点都满⾜左右两个⼦树的⾼度差 <= 1

见[leetcode题目](https://leetcode-cn.com/problems/balanced-binary-tree/)

## 1.29. 谈谈对进程、线程和协程的理解

[进程、线程、协程常见面试题汇总](https://www.nowcoder.com/discuss/600292?type=1)

## 1.30. 微服务的理解，微服务有哪些缺点

https://segmentfault.com/a/1190000020092884

每个敏捷团队都使用可用的框架和所选的技术堆栈构建单独的服务组件，每个服务组件形成一个强大的微服务架构，以提供更好的可扩展性。

敏捷团队可以单独处理每个服务组件的问题，而对整个应用程序没有影响或影响最小。

优点：

- 独立开发
- 独立部署
- 故障隔离
- 混合技术栈
- 粒度缩放，组件易扩展

缺点：

- 故障排查困难
- 远程调用延迟
- 增加了配置部署的工作量

## 1.31. 如何写出高质量的代码

## 1.32. MySQL连表查询的原理是什么

**MySQL的多表查询(笛卡尔积原理)**

1. 先确定数据要用到哪些表。
2. 将多个表先通过笛卡尔积变成一个表。
3. 然后去除不符合逻辑的数据（根据两个表的关系去掉）。
4. 最后当做是一个虚拟表一样来加上条件即可。

注意：列名最好使用表别名来区别。

