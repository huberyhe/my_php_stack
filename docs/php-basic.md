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



## 5、正则函数与正则表达式

作用：分割、查找、匹配、替换

preg_match、preg_match_all、preg_replace、preg_filter、preg_split

### 5.1 分隔符

经常使用的分隔符是正斜线(`/`)、hash符号(`#`) 以及取反符号(`~`)

### 5.2 元字符

#### 1、方括号外的元字符

| 元字符 | 描述                                                         |
| :----- | :----------------------------------------------------------- |
| \      | 一般用于转义字符                                             |
| ^      | 断言目标的开始位置(或在多行模式下是行首)                     |
| $      | 断言目标的结束位置(或在多行模式下是行尾)                     |
| .      | 匹配除换行符外的任何字符(默认)                               |
| [      | 开始字符类定义                                               |
| ]      | 结束字符类定义                                               |
| \|     | 开始一个可选分支                                             |
| (      | 子组的开始标记                                               |
| )      | 子组的结束标记                                               |
| ?      | 作为量词，表示 0 次或 1 次匹配。位于量词后面用于改变量词的贪婪特性。 (查阅[量词](https://www.php.net/manual/zh/regexp.reference.repetition.php)) |
| *      | 量词，0 次或多次匹配                                         |
| +      | 量词，1 次或多次匹配                                         |
| {      | 自定义量词开始标记                                           |
| }      | 自定义量词结束标记                                           |

#### 2、方括号内的元字符

| 元字符 | 描述                                           |
| :----- | :--------------------------------------------- |
| \      | 转义字符                                       |
| ^      | 仅在作为第一个字符(方括号内)时，表明字符类取反 |
| -      | 标记字符范围                                   |

### 5.3 转义序列(反斜线)

#### 用途1、如果紧接着是一个非字母数字字符，表明取消 该字符所代表的特殊涵义

#### 用途2、提供了一种对非打印字符进行可见编码的控制手段

#### 用途3、用来描述特定的字符类

| 字符 | 描述               |
| ---- | ------------------ |
| *\d* | 任意十进制数字     |
| *\D* | 任意非十进制数字   |
| *\h* | 任意水平空白字符   |
| *\H* | 任意非水平空白字符 |
| *\s* | 任意空白字符       |
| *\S* | 任意非空白字符     |
| *\V* | 任意非垂直空白字符 |
| *\w* | 任意单词字符       |
| *\W* | 任意非单词字符     |

### 5.4 Unicode 字符属性

### 5.5 锚

脱字符（`^`） 是一个断言当前匹配点位于目标字符串开始处的断言

美元符(`$`)是用于断言当前匹配点位于目标字符串末尾， 或当目标字符串以换行符结尾时当前匹配点位于该换行符位置(默认情况)

### 5.6 句点

### 5.7 字符类(方括号)

### 5.8 可选路径(|)

### 5.9 内部选项设置

| `i`  | for [PCRE_CASELESS](https://www.php.net/manual/zh/reference.pcre.pattern.modifiers.php) |
| ---- | ------------------------------------------------------------ |
| `m`  | for [PCRE_MULTILINE](https://www.php.net/manual/zh/reference.pcre.pattern.modifiers.php) |
| `s`  | for [PCRE_DOTALL](https://www.php.net/manual/zh/reference.pcre.pattern.modifiers.php) |
| `x`  | for [PCRE_EXTENDED](https://www.php.net/manual/zh/reference.pcre.pattern.modifiers.php) |
| `U`  | for [PCRE_UNGREEDY](https://www.php.net/manual/zh/reference.pcre.pattern.modifiers.php) |
| `X`  | for [PCRE_EXTRA](https://www.php.net/manual/zh/reference.pcre.pattern.modifiers.php) |
| `J`  | for [PCRE_INFO_JCHANGED](https://www.php.net/manual/zh/reference.pcre.pattern.modifiers.php) |

### 5.10 子组(子模式)

将一个模式中的一部分标记为子组(子模式)主要是来做两件事情：

1. 将可选分支局部化。比如，模式`cat(arcat|erpillar|)`匹配 ”cat”， “cataract”， “caterpillar” 中的一个，如果没有圆括号的话，它匹配的则是 ”cataract”， “erpillar” 以及空字符串。
2. 将子组设定为捕获子组(向上面定义的)。当整个模式匹配后， 目标字符串中匹配子组的部分将会通过 **pcre_exec()()** 的 *ovector* 参数回传给调用者。 左括号从左至右出现的次序就是对应子组的下标(从 1 开始)， 可以通过这些下标数字来获取捕获子模式匹配结果。

### 5.11 重复/量词

可以紧跟在下面元素之后：

- 单独的字符, 可以是经过转义的
- 元字符。
- 字符类
- 后向引用
- 子组(除非它是一个断言)

**单字符量词**

| `*`  | 等价于 `{0,}`  |
| ---- | -------------- |
| `+`  | 等价于 `{1,}`  |
| `?`  | 等价于 `{0,1}` |

### 5.12 后向引用

在一个字符类外面， 反斜线紧跟一个大于 0 (可能还有一位数)的数字就是一个到模式中之前出现的某个捕获组的后向引用。

### 5.13 断言

一个断言就是一个对当前匹配位置之前或之后的字符的测试， 它不会实际消耗任何字符。简单的断言代码有\b、\B、 \A、 \Z、\z、 ^、$ 等

### 5.14 一次性子组

对于同时有最大值和最小值量词限制的重复项， 在匹配失败后， 紧接着会以另外一个重复次数重新评估是否能使模式匹配。 当模式的作者明确知道执行上没有问题时， 通过改变匹配的行为或者使其更早的匹配失败以阻止这种行为是很有用的。

语法符号是另外一种特殊的括号， 以 (?> 开始，比如 `(?>\d+)bar`

### 5.15 条件子组

可以使匹配器根据一个断言的结果， 或者之前的一个捕获子组是否匹配来条件式的匹配一个子组或者在两个可选子组中选择。 条件子组的两种语法如下：

```
(?(condition)yes-pattern)
(?(condition)yes-pattern|no-pattern)
```

### 5.16 注释

字符序列(?#标记开始一个注释直到遇到一个右括号。不允许嵌套括号。 注释中的字符不会作为模式的一部分参与匹配。

### 5.17 递归模式

### 5.18 性能



> 参考：[PHP: PCRE - Manual](https://www.php.net/manual/zh/book.pcre.php)

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

- 性能可以达到PHP 5.6的3倍：变量、字符串、数组的数据结构优化

- 标量类型声明和返回值类型声明：`declare(strict_types=1); `

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
> 1、[全面剖析PHP-FPM+Nginx通信原理 - InfoQ 写作平台](https://xie.infoq.cn/article/fa7b39c76e6556f4a23b53cc2)
>
> 2、[Nginx与php-fpm通信原理详解 - shuwoom的博客](https://shuwoom.com/?p=4366)

### 11、PHP8有哪些改进，JIT是什么

- JIT即时编译
- 命名参数
- 联合类型
- Nullsafe运算符：`echo $session?->user?->getAddress()?->country`
- match语法

```php
match(){
	value=>condition1,
	express=>condition2,
	default=>condition3,
}
```



### 12、composer自动加载机制，PSR编码规范

` \<NamespaceName>(\<SubNamespaceNames>)*\<ClassName>`

顶级命名空间+子命名空间+类名

加载时，顶级命名空间对应一个目录，子命名空间是这个目录下的子目录，字母中包含这个类同名的php文件

> 参考：
>
> 1、[深入解析 composer 的自动加载原理](https://segmentfault.com/a/1190000014948542)
>
> 2、[Composer 自动加载原理 |《Laravel 之道 5.6》](https://learnku.com/docs/the-laravel-way/5.6/Tao-3-1/2928)
>
> 3、[PSR-4 自动加载规范 |《PHP PSR 标准规范》](https://learnku.com/docs/psr/psr-4-autoloader/1608)

### 13、php代码运行过程

