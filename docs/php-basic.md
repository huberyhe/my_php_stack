[回到首页](../README.md)

# PHP基础

说明

[TOC]

## 1、常用数组函数

array_push\array_pop
array_shift\array_unshift
array_merge
array_unique

sort/usort/ksort/asort

array_column

array_combine

array_fill/array_fill_keys

array_walk

## 2、时间处理

```php
date('Y-m-d H:i:s');// 2021-08-25 00:43:51

strtotime('2021-08-25 00:43:51');// 1629823431
strtotime("+1 day");// 一天前的时间戳

time();// 1629823534
```

## 3、字符串处理

substr

strstr

implode \ explode \ join \ unjoin

## 4、文件处理

fopen

fgets \ fputs

fgetc \ fputc

fseek

fread \ fwrite

file_get_contents \ file_put_contents

opendir \ readdir \ closedir

filetype

文件遍历例子：

```php
<?php
$dir = "/etc/php5/";

// Open a known directory, and proceed to read its contents
if (is_dir($dir)) {
    if ($dh = opendir($dir)) {
        while (($file = readdir($dh)) !== false) {
            echo "filename: $file : filetype: " . filetype($dir . $file) . "\n";
        }
        closedir($dh);
    }
}
?>
```



## 5、正则函数

作用：分割、查找、匹配、替换

preg_match、preg_match_all、preg_replace、preg_filter、preg_split

## 6、php.ini常见配置

ignore_user_abort：

safe_mode：是否启用安全模式

disable_functions：该指令接受一个用逗号分隔的函数名列表，以禁用特定的函数

allow_url_fopen：是否允许打开远程文件。

log_errors：PHP错误报告日志功能开关。

error_log：PHP错误报告日志文件路径。

error_reporting：设置PHP的报错级别。

display_errors：设定PHP是否将任何错误信息包含在返回给Web服务器的数据流中。

max_execution_time：设定任何脚本所能够运行的最长时间，默认值是30秒。

memory_limit：PHP进程能够占用的内存，单位是M，默认值是128M。

session.save_path：设置session文件存放的位置（文件夹应该是已经存在的）。

date.timezone：设置时区。该设置影响PHP中所有的日期、时间函数。

## 7、php-fpm.conf常用配置

pm = dynamic

pm.max_children 静态方式下开启的php-fpm进程数量。

pm.process_idle_timeout

pm.max_requests = 5000 每个子进程重生之前服务的请求数，主要目的是为了控制请求处理过程中的内存溢出

emergency_restart_threshold = 0

emergency_restart_interval = 0

## 8、其他高级

[PHP Closure(闭包)类详解 - 追风的浪子 - 博客园 (cnblogs.com)](https://www.cnblogs.com/echojson/p/10957362.html)

## 9、PHP7有哪些不同

- 标量类型声明

- 返回值类型声明

- NULL 合并运算符：`$username = $_GET['user'] ?? 'nobody';`

- 太空船操作符（组合比较符）：`echo 1 <=> 2; // -1`

- 通过 define() 定义常量数组

- 匿名类

- Unicode codepoint 转译语法：`echo "\u{9999}";`

- Closure::call()：Closure::call() 现在有着更好的性能，简短干练的暂时绑定一个方法到对象上闭包并调用它。

- 为unserialize()提供过滤：这个特性旨在提供更安全的方式解包不可靠的数据。它通过白名单的方式来防止潜在的代码注入。

- IntlChar：新增加的 IntlChar 类旨在暴露出更多的 ICU 功能。这个类自身定义了许多静态方法用于操作多字符集的 unicode 字符。

- 预期：预期是向后兼用并增强之前的 assert() 的方法。 它使得在生产环境中启用断言为零成本，并且提供当断言失败时抛出特定异常的能力。

  ```php
  <?php
  ini_set('assert.exception', 1);
  
  class CustomError extends AssertionError {}
  
  assert(false, new CustomError('Some error message'));
  ?>
  ```

- use 加强：从同一 namespace 导入的类、函数和常量现在可以通过单个 use 语句 一次性导入了。

- Generator 加强

- 整除：`var_dump(intdiv(10, 3));//int(3)`

> 参考：[PHP 7 新特性 | 菜鸟教程 (runoob.com)](https://www.runoob.com/php/php7-new-features.html)

## 10、nginx与php-fpm通信过程

（1）当 Nginx 收到 http 请求（动态请求），它会初始化 FastCGI 环境。（如果是 Apache 服务器，则初始化 mode*fastcgi 模块、如果是 Nginx 服务器则初始化 ngx*http_fastcgi_module）

（2）我们在配置 nginx 解析 php 请求时，一般会有这样一行配置：

```
fastcgi_pass 127.0.0.1:9000;
```

或者长这样：

```
fastcgi_pass unix:/tmp/php-cgi.sock;
```

它其实是 Nginx 和 PHP-FPM 一个通信载体（或者说通信方式），目的是为了让 Nginx 知道，收到动态请求之后该往哪儿发。（关于这两种配置的区别，后边会专门介绍）

（3）Nginx 将请求采用 socket 的方式转给 FastCGI 主进程

（4）FastCGI 主进程选择一个空闲的 worker 进程连接，然后 Nginx 将 CGI 环境变量和标准输入发送该 worker 进程（php-cgi）

（5）worker 进程完成处理后将标准输出和错误信息从**同一 socket 连接**返回给 Nginx

（6）worker 进程关闭连接，等待下一个连接

> 参考：
>
> 1、https://xie.infoq.cn/article/fa7b39c76e6556f4a23b53cc2
>
> 2、https://shuwoom.com/?p=4366
