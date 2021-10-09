[回到首页](../README.md)

# Shell小技巧

[TOC]

## 1、Shell 脚本如何输出帮助信息？

作者展示了一个技巧，将帮助信息写在 Bash 脚本脚本的头部，然后只要执行“脚本名 + help”，就能输出这段帮助信息。

```bash
#!/bin/bash
###
### my-script — does one thing well
###
### Usage:
###   my-script <input> <output>
###
### Options:
###   <input>   Input file to read.
###   <output>  Output file to write. Use '-' for stdout.
###   -h        Show this message.

function help() {
    sed -rn 's/^### ?//;T;p' "$0"
}

if [[ $# == 0 ]] || [[ "$1" == "-h" ]]; then
    help
    exit 1
fi

# task code...
```
> 参考：
>
> [Shell 脚本如何输出帮助信息？](https://samizdat.dev/help-message-for-shell-scripts/)（英文）

## 2、上级管道的输出作为下级

## 3、EOF的用法

```bash
#!/bin/bash
cat > /etc/security/limits.conf<< EOF
#tsedb SETTING
tsedb soft nproc 16384
tsedb hard nproc 16384
tsedb soft nofile 16384
tsedb hard nofile 65536
tsedb soft stack 10240
tsedb hard stack 32768
tsedb hard memlock 8000000
tsedb soft memlock 8000000
EOF
```

## 4、脚本单例执行

定时任务防止脚本同时执行的方法：
1、原理就是使用flock加锁，加锁不成功时（已被枷锁）直接退出脚本

`flock -xn /tmp/test_single.lock -c /wns/shell/test_single.sh`
2、做成了一个脚本，使用时包含即可，内容如下

`cat /wns/shell/keep_singleton.sh`

```bash
#!/bin/sh

#函数描述：保证脚本单例运行
#参数1：想要单例运行的脚本名字
#返回值：如果该脚本已经在运行，则退出本次执行，返回 1
function keep_singleton()
{
    local _argv1=$1
    [ -z "${_argv1}" ] && _argv1=$(basename $0)

    local _lock_file="/var/tmp/${_argv1}"
    [ ! -f "${_lock_file}" ] && touch ${_lock_file}

    exec 1020<>"${_lock_file}"
    flock -n 1020
    if [ "$?" -eq 1 ];then
        exit 0
    fi
    return 0
}

#脚本是否单例执行
# 存在参数，使用参数作为锁文件
# 不存在参数，使用脚本名称作为锁文件
is_singleton()
{
    local _argv1=$1
    [ -z "${_argv1}" ] && _argv1=$(basename $0)

    local _lock_file="/var/tmp/${_argv1}"
    [ ! -f "${_lock_file}" ] && touch ${_lock_file}

    exec 1020<>"${_lock_file}"
    flock -n 1020
    if [ "$?" -eq 1 ];then
        return 1
    fi
    return 0
}
```
在自己的脚本中包含这段代码即可：
```bash
. /wns/shell/keep_singleton.sh
keep_singleton `basename $0`

sleep 60
```

## 5、获取脚本当前目录

```bash
script_dir=$(cd $(dirname $0) && pwd)
script_dir=$(dirname $(readlink -f $0))
```

## 6、脚本严格模式 -e

```bash
set -euo pipefail
```

- `-e`：当程序返回非0状态码时报错退出
- `-u`：使用未初始化的变量时报错，而不是当成NULL。 这个比较有用，有点高级编程的感觉
- `-o pipefail`：使用Pipe中出错命令的状态码（而不是最后一个）作为整个Pipe的状态码。

## 7、获取IP地址

```bash
ip addr show dev eth0 | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}'
ifconfig -a eth0|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"
```

> 参考：[Linux - Shell 脚本中获取本机 ip 地址方法 - 小菠萝测试笔记 - 博客园 (cnblogs.com)](https://www.cnblogs.com/poloyy/p/12212868.html)

