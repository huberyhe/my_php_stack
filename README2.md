# 我的PHP技术栈

梳理自己的技术栈，方便自己回顾和加深学习。可以是自己学习过的觉得比较重要的，或者只是看到过还需要加深印象的

[TOC]

## PHP

- [php基础](docs/php-basic.md)
- [php运行环境搭建](docs/php-env-build.md)
- php垃圾回收机制与生命周期

[引用计数](https://www.php.net/manual/zh/features.gc.refcounting-basics.php)：php变量存在一个叫“zval”的变量容器之中，变量容器除了包含变量的类型和值外，还包括两个字节额额外信息。if_ref标识这个变量是否属于引用集合，用于区分普通变量和引用变量。refcount表示指向这个变量容器的变量个数。

[生命周期](https://www.cnblogs.com/applelife/p/10511837.html)：以php-fpm为例，启动时php加载扩展并调用其模块初始化例程（MINIT）；请求到达时，php调用RINIT，并执行脚本；脚本执行完后，php调用RSHUTDOWN，执行清理和垃圾回收；停止php-fpm时，php调用每个扩展的关闭函数（MSHUTDOWN），并关闭自己。

- [常见MVC框架的设计思想解读](docs/php-mvc.md)
- [常见的设计模式以及项目中的应用](docs/php-design-patterns.md)
- [类的相关概念：类的三个特性、抽象类与接口](docs/php-class.md)
- [编码规范](docs/code-compliance.md)
- [深入解析 composer 的自动加载原理](https://segmentfault.com/a/1190000014948542)
- 一些前端小技巧

## Golang

- [golang基础](docs/go-basic.md)

## Linux与shell

- [linux基本使用](docs/linux-basic.md)
- [linux使用技巧](./docs/linux-skills.md)
- [shell基础](docs/shell-basic.md)
- [shell高级命令使用-三剑客](./docs/shell-advanced-command.md)
- [shell小技巧](docs/shell-tips.md)
- [Bash 脚本教程 - 廖雪峰](https://wangdoc.com/bash/index.html)

## Python

## MySQL

- [MySQL的基本使用](docs/mysql-basic.md)
- [MySQL的高级使用-分区分表、主从复制、读写分离等](docs/mysql-advanced.md)
- [MySQL事务](docs/mysql-transaction.md)
- [MySQL有哪些存储引擎，各自的优缺点，应用场景](https://juejin.im/post/6844903684912971783)
- mysql常用命令

## 其他数据库

- [sqlite](doc/sqlite-basic.md)
- [postgresql](docs/postgresql-basic.md)
- [dgraph基础](docs/dgraph-basic.md)
- [redis基础](docs/redis.md)

## Nginx

- [nginx基本知识](docs/nginx-basic.md)
- 

## 项目部署与Docker

- [docker基础命令](./docs/docker-basic.md)
- [docker技巧](./docs/docker-skills.md)

## 算法与数据结构

- [常见排序算法](https://www.runoob.com/w3cnote/sort-algorithm-summary.html)
- [常见的排序算法——常见的10种排序](https://www.cnblogs.com/flyingdreams/p/11161157.html)
- [十大经典排序算法](https://www.cnblogs.com/itsharehome/p/11058010.html)
- [动态规划经典问题-拼凑面额](https://www.nowcoder.com/questionTerminal/14cf13771cd840849a402b848b5c1c93)
- [LeetCode](https://leetcode.com/)题解-[labuladong 的算法小抄](https://github.com/labuladong/fucking-algorithm)
- 外部排序，解决大数据排序问题：[外部排序&多路归并排序](https://www.cnblogs.com/luo77/p/5838206.html)
- [必会的算法问题](docs/arithmetic-questions.md)

## 并发与缓存问题

- 负载均衡：lvs体系架构
- [缓存机制](docs/cache.md)
- [消息队列](docs/mq.md)

## 软件工程

- 23个设计模式
- [7大设计原则](https://bbs.huaweicloud.com/blogs/312691?utm_campaign=other&utm_source=wechat_session&utm_medium=social&utm_oi=43696514924544)：单一职责原则、开放封闭原则、里氏替换原则、接口隔离原则、依赖倒转原则、组合/聚合复用原则、迪米特原则
- [并发的3个特性](https://zhuanlan.zhihu.com/p/58855599)：原子性、有序性、可见性
- 如何画架构图
- 完整项目开发流程
- 系统设计
- 部署策略：大爆炸（Big Bang）部署、蓝绿（Blue-Green）部署、滚动（Rolling）部署、灰度部署（金丝雀Canary部署）、功能开关（Feature Toggle）发布


## 安全编码

- XSS攻击及防御
- CSRF攻击及防御
- 命令注入
- sql注入
- sdl安全开发：[【软件安全设计】安全开发生命周期（SDL）](http://blog.nsfocus.net/sdl/)
- nginx和php中安全相关的配置：[Linux服务器下nginx的安全配置](https://www.cnblogs.com/chenpingzhao/p/5785416.html)
- 腾讯Go安全指南：[secguide/Go安全指南.md](https://github.com/Tencent/secguide/blob/main/Go%E5%AE%89%E5%85%A8%E6%8C%87%E5%8D%97.md)

## 网络基础

[网络基础](docs/net-basic.md)

- TCP/IP四层，OSI七层协议
- TCP与UDP区别
- http请求的完整过程
- tls握手过程
- tcp三次握手与四次挥手

## 持续集成CI、CD

- jenkins打包
- gitlab-runner

## git与svn

- [git常用命令](./docs/git.md)

## 工具：提升效率利器

- [常用工具](./docs/tools.md)
- [Windows下常用工具](./docs/win-tools.md)

## 常见面试题

- [常见面试题](docs/interview-questions.md)

## 成长规划

1、[【原创】PHP/Go程序员的发展与规划](https://blog.csdn.net/heiyeshuwu/article/details/107193766?ops_request_misc=%7B%22request%5Fid%22%3A%22163515565616780261971774%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fblog.%22%7D&request_id=163515565616780261971774&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~blog~first_rank_v2~rank_v29-1-107193766.pc_v2_rank_blog_default&utm_term=规划&spm=1018.2226.3001.4450)

2、[【原创】PHP程序员的技术成长规划](https://blog.csdn.net/heiyeshuwu/article/details/40098043?ops_request_misc=%7B%22request%5Fid%22%3A%22163515533616780262522777%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fall.%22%7D&request_id=163515533616780262522777&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-40098043.pc_search_result_cache&utm_term=php程序员的技术成长规划&spm=1018.2226.3001.4187)



