[回到首页](../README.md)

# 1. Shell小技巧

[TOC]

## 1.1. Shell 脚本如何输出帮助信息？

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

## 1.2. 上级管道的输出作为下级

## 1.3. EOF的用法

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

## 1.4. 脚本单例执行

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

## 1.5. 获取脚本当前目录

```bash
script_dir=$(cd $(dirname $0) && pwd)
script_dir=$(dirname $(readlink -f $0))
```

## 1.6. 脚本严格模式 -e

```bash
set -euo pipefail
```

- `-e`：当程序返回非0状态码时报错退出
- `-u`：使用未初始化的变量时报错，而不是当成NULL。 这个比较有用，有点高级编程的感觉
- `-o pipefail`：使用Pipe中出错命令的状态码（而不是最后一个）作为整个Pipe的状态码。

## 1.7. 获取IP地址

```bash
ip addr show dev eth0 | awk '/^[0-9]+: / {}; /inet.*global/ {print gensub(/(.*)\/(.*)/, "\\1", "g", $2)}'
ifconfig -a eth0|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"
```

> 参考：[Linux - Shell 脚本中获取本机 ip 地址方法 - 小菠萝测试笔记 - 博客园 (cnblogs.com)](https://www.cnblogs.com/poloyy/p/12212868.html)

## 1.8. 交互式确认询问

```bash
#!/bin/bash

# default no(1)
function askNY ()
{
	ret=0
	timeout=5
	while
		echo -n "$1[y/N]"
	do
		read -t $timeout ans
		if [[ -z $ans ]]; then
			ret=1
			break
		elif [[ "$ans"x = "y"x || "$ans"x = "Y"x ]]; then
			ret=0
			break
		elif [[ "$ans"x = "n"x || "$ans"x = "N"x ]]; then
			ret=1
			break
		else
			continue
		fi
	done
	return $ret
}
# default yes(0)
function askYN ()
{
	ret=0
	timeout=5
	while
		echo -n "$1[Y/n]"
	do
		read -t $timeout ans
		if [[ -z $ans ]]; then
			ret=0
			break
		elif [[ "$ans"x = "y"x || "$ans"x = "Y"x ]]; then
			ret=0
			break
		elif [[ "$ans"x = "n"x || "$ans"x = "N"x ]]; then
			ret=1
			break
		else
			continue
		fi
	done
	return $ret
}

iptablesFile='/etc/iptables.rule'
if [[ -f $iptablesFile ]] && askYN "Already configured, restore(Y) or continue(N)?" ; then
	echo "Already configured, restore."
else
	echo "Start to configure and save rules."
fi
```

## 1.9. 判断是否为root身份

```bash
#!/bin/bash

if [[ $USER != 'root' ]];then
    echo "Must be run as root!"
    exit 1
fi

if [[ `whoami` != 'root' ]]; then
	echo "Permission Denied."
	exit 1
fi

if [ $(echo "$UID") = "0" ]; then
	sudo_cmd=''
else
	sudo_cmd='sudo'
fi
```

## 1.10. ls显示绝对路径

```bash
#!/bin/bash
set +e
if [[ $1 != '' ]]; then
    cd $1
fi

ls | sed "s:^:`pwd`/:"

## 11、函数多值返回和接收

原生是不支持多值返回的，但可以通过小技巧模拟实现

```bash
function get_load()
{
	echo $(uptime | tr -d " " | awk -F "[:,]" '{print $8" "$9" "$10}')
}
read load1 load5 load15 < <(get_load)

read load1 load5 load15 <<< $(echo $(uptime | tr -d " " | awk -F "[:,]" '{print $8" "$9" "$10}'))
```

## 1.11. 获取一个未占用的端口

```bash
#!/bin/bash
PORT=0
#判断当前端口是否被占用，没被占用返回0，反之1
function Listening {
   TCPListeningnum=`netstat -an | grep ":$1 " | awk '$1 == "tcp" && $NF == "LISTEN" {print $0}' | wc -l`
   UDPListeningnum=`netstat -an | grep ":$1 " | awk '$1 == "udp" && $NF == "0.0.0.0:*" {print $0}' | wc -l`
   (( Listeningnum = TCPListeningnum + UDPListeningnum ))
   if [ $Listeningnum == 0 ]; then
       echo "0"
   else
       echo "1"
   fi
}

#指定区间随机数
function random_range {
   shuf -i $1-$2 -n1
}

#得到随机端口
function get_random_port {
   templ=0
   while [ $PORT == 0 ]; do
       temp1=`random_range $1 $2`
       if [ `Listening $temp1` == 0 ] ; then
              PORT=$temp1
       fi
   done
   echo "port=$PORT"
}

get_random_port 1 10000; #这里指定了1~10000区间，从中任取一个未占用端口号
```

## 1.12. shell脚本同时打印到终端和日志文件

### 1.12.1. exec & tee

```bash
[ -f "$log_file" ] || touch "$log_file"
exec &> >(tee -a "$log_file")
```

### 1.12.2. exec & tail

```bash
exec >> $log_file 2>&1 && tail $log_file
```

这个方法有个缺点，终端会包含一小段上次执行后的日志，因为这里用了tail

> 参考：[bash - Using exec and tee to redirect logs to stdout and a log file in the same time](https://unix.stackexchange.com/questions/145651/using-exec-and-tee-to-redirect-logs-to-stdout-and-a-log-file-in-the-same-time)

## 1.13. exec的使用方法

## 1.14. 函数返回多个参数及其接收

```bash
# 输入：V3.1-0.128b220210
# 输出：3.1 0.128
function get_ver()
{
	echo $1 | sed -r "s/V([0-9\.]+)\-([0-9\.]+)\w?[0-9]{6}/\1 \2/g"
}

read v1_big v1_little < <(get_ver "V3.1-0.128b220210")
```

## 1.15. 去掉字符

```bash
tr -d "\r"
```

## 1.16. 输出到日志时添加时间

```bash
./script.sh | while IFS= read -r line; do printf '%s %s\n' "$(date)" "$line"; done >>/var/log/logfile
```

或

```bash
adddate() {
    while IFS= read -r line; do
        printf '%s %s\n' "$(date)" "$line";
    done
}

./thisscript.sh | adddate >>/var/log/logfile
./thatscript.sh | adddate >>/var/log/logfile
./theotherscript.sh | adddate >>/var/log/logfile
```

