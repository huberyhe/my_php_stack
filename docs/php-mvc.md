[回到首页](../README.md)

# php常见框架

[TOC]

## 1、框架级的函数

```php
error_reporting();//设置或获取错误报告级别
set_exception_handler();//设置用户自定义的异常处理函数
set_error_handler();//设置用户自定义的错误处理函数
set_time_limit();//设置脚本最大执行时长
set_include_path();//设置包含文件时查找文件的路径
register_shutdown_function();//注册一个会在php中止时执行的函数
trigger_error();//产生一个用户级别的 error/warning/notice 信息
ini_set('display_errors', 0);//不显示错误信息
```

> 参考：
>
> 1、[php异常以及错误捕获 - Json的博客 (fxjson.com)](http://www.fxjson.com/archives/28/)
>
> 

## 2、MVC框架的理解

### 2.1、需要关注框架哪些基本功能

- 路由配置
- 数据库连接
- cookie与session使用
- 运行日志与调试日志，如何开调试模式
- 全局常量如何定义
- 全局配置如何定义
- 参数校验

## 3、常见框架

### 3.1、Codeigniter

[文档地址](https://codeigniter.com/user_guide/index.html)

### 3.2、Laravel

[文档地址](https://learnku.com/docs/laravel/8.5)

依赖注入与控制反转：

### 3.3、ThinkPHP

[文档地址](https://www.kancloud.cn/manual/thinkphp5_1)

AOP（面向切面编程）：在软件业，AOP为Aspect Oriented Programming的缩写，意为：[面向切面编程](https://baike.baidu.com/item/面向切面编程/6016335)，通过[预编译](https://baike.baidu.com/item/预编译/3191547)方式和运行期间动态代理实现程序功能的统一维护的一种技术。AOP是[OOP](https://baike.baidu.com/item/OOP)的延续，是软件开发中的一个热点，也是[Spring](https://baike.baidu.com/item/Spring)框架中的一个重要内容，是[函数式编程](https://baike.baidu.com/item/函数式编程/4035031)的一种衍生范型。利用AOP可以对业务逻辑的各个部分进行隔离，从而使得业务逻辑各部分之间的[耦合度](https://baike.baidu.com/item/耦合度/2603938)降低，提高程序的可重用性，同时提高了开发的效率。

门面模式：门面为容器中的类提供了一个静态调用接口，相比于传统的静态方法调用， 带来了更好的可测试性和扩展性，你可以为任何的非静态类库定义一个`facade`类。说的直白一点，Facade功能可以让类无需实例化而直接进行静态方式调用。

依赖注入：

[Thinkphp5.1中用到的设计模式（依赖注入，容器，Facade门面模式）](https://cloud.tencent.com/developer/article/1795111)

### 3.4、Yii

[文档地址](https://www.yiiframework.com/doc/guide/2.0/zh-cn)

### 3.5、phalcon

[文档地址](https://docs.phalcon.io/4.0/zh-cn/introduction)

### 3.6、yaf

[文档地址](https://www.php.net/manual/zh/book.yaf.php)

[源码地址](https://github.com/laruence/yaf)

### 3.7、CakePHP

[文档地址]([Contents - 3.10 (cakephp.org)](https://book.cakephp.org/3/zh/contents.html))

## 4、自动加载配置

[laravel的启动过程解析](https://www.cnblogs.com/lpfuture/p/5578274.html)

[CodeIgniter4 - 启动流程](https://www.jianshu.com/p/3838381bf2e5?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)

