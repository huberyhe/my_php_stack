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
