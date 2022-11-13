[回到首页](../README.md)

# 1. 高并发、高可用

说明

[TOC]

## 1.1. 分布式事务
XA是一个协议，是X/Open组织制定的关于分布式事务的一组标准接口，实现这些接口，便意味支持XA协议。
### 1.1.1. 二阶段提交
二阶段提交（2PC）是XA分布式事务协议的一种实现。其实在XA协议定义的函数中，通过xa_prepare,xa_commit已经能发现XA完整提交分准备和提交两个阶段。
### 1.1.2. TCC
TCC本质上是一个业务层面上的2PC，他要求业务在使用TCC模式时必须实现三个接口Try()、Confirm()和Cancel()

> 参考：[分布式事务-2PC与TCC](https://juejin.cn/post/7017333689109446670)

## 1.2. 标题2
