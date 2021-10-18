[回到首页](../README.md)

# 常见面试题

说明

[TOC]

## 1、抽象类与接口的区别

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

## 2、在浏览器中打开一个url，发生了什么

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

## 3、七层OSI网络模型与TCP/IP网络模型、五层网络模型

OSI体系结构：物理层、数据链路层、网络层、传输层、会话层、表示层、应用层

TCP/IP体系结构：网络接口层、网际层IP、运输层、应用层

五层协议：物理层、数据链路层、网络层（IP协议、ICMP、ARP、RARP）、运输层（TCP/UDP协议）、应用层（DNS、HTTP）

> 参考：[计算机网络的七层结构、五层结构和四层结构 - SegmentFault 思否](https://segmentfault.com/a/1190000039204681)

## 4、缓存穿透、击穿、雪崩

参考：[缓存-常见缓存问题](cache.md)

## 5、并发锁机制

## 6、HTTP是长连接还是短连接

http/1.0中默认使用短连接，从http/1.1开始默认使用长连接

## 7、查询计划字段的含义

```
MySQL [mysql]> explain select * from user;
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------+
| id | select_type | table | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------+
|  1 | SIMPLE      | user  | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    4 |   100.00 | NULL  |
+----+-------------+-------+------------+------+---------------+------+---------+------+------+----------+-------+

```

> 参考：[了解MySQL中EXPLAIN解释命令 - SegmentFault 思否](https://segmentfault.com/a/1190000018729502)

## 8、xss与csrf

XSS：跨站脚本（Cross-site scripting，通常简称为XSS）是一种网站应用程序的安全漏洞攻击，是代码注入的一种。它允许恶意用户将代码注入到网页上，其他用户在观看网页时就会受到影响。**这类攻击通常包含了HTML以及用户端脚本语言**。

CSRF:跨站请求伪造（英语：Cross-site request forgery），也被称为 one-click attack 或者 session riding，通常缩写为 CSRF 或者 XSRF， 是一种挟制用户在当前已登录的Web应用程序上**执行非本意的操作的攻击方法**。

>  参考：[用大白话谈谈XSS与CSRF - SegmentFault 思否](https://segmentfault.com/a/1190000007059639)



参考：[HTTP长连接、短连接究竟是什么？ - dai.sp - 博客园 (cnblogs.com)](https://www.cnblogs.com/gotodsp/p/6366163.html)

