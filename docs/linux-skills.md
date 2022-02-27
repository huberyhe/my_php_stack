[回到首页](../README.md)

# Linux技巧

[TOC]

## 1、yum update时忽略某些软件
生产环境应避免升级linux内核和关键应用，例如之前遇到过docker与centos版本不兼容引发容器网络异常

1.1、临时：

```bash
yum update --exclude=kernel
```
或者
```bash
yum update -x 'kernel'
```
1.2、永久，修改配置`/etc/yum.conf`，添加`exclude=kernel* php*`
1.3、永久，命令添加

```bash
yum versionlock add freetype
yum versionlock list
```

## 2、自解压文件：用于制作单文件升级包

假设我们要制作一个名字叫`pkg_20210714.csu`的升级包，直接`sh pkg_20210714.csu`可以完成升级。这个文件本身是一个shell脚本，但尾部又包含升级所需的文件

```bash
$ cat release/pkg_20210714.csu
#!/bin/sh
set -e
UPGRADE_DIR="/tmp/unpkg"
line=`wc -l $0 | awk '{print $1}'`;
line=`expr $line - 12`; #减去的数值为exit所在行号
mkdir -p $UPGRADE_DIR
tail -n $line $0 | tar x -C $UPGRADE_DIR
cd $UPGRADE_DIR
./start_upgrade.sh
RET=$?
if [ $RET -eq 0 ]; then rm -rf $UPGRADE_DIR; fi
exit $RET
#-------tar file---begin
./0000755000175000017500000000000014073337366010605 5ustar  huberyhubery./src/0000755000175000017500000000000014073330616011363 5ustar  huberyhubery./src/index.php0000644000175000017500000000003114073330635013176 0ustar  huberyhubery<?php
echo 'test ok';
?>
./start_upgrade.sh0000755000175000017500000000027214073337366014011 0ustar  huberyhubery#!/bin/sh
# 示例升级,替换文件
INSTALL_ROOT=/tmp/www
UNPKG_DIR=/tmp/unpkg
SRC_ROOT=${UNPKG_DIR}/src

rm -rf $INSTALL_ROOT
mkdir -p $INSTALL_ROOT
cp $SRC_ROOT/* $INSTALL_ROOT/ -Ra
```

如何将一个脚本和其他文件放到一起，而脚本又可以正确执行？cat拼接即可

```
cat aaa.sh bbb.tar > ccc.csu
```

具体参考下面的内容，重点是`self_exec.sh`这个文件。文件放到了[这里](../attach/mk_pkg_demo/)

```bash
$ tree
.
├── Makefile
├── release
│   ├── self_exec.sh
│   └── start_upgrade.sh
└── src
    └── index.php

2 directories, 4 files
$ cat Makefile
all:
        rm -rf output_self
        mkdir -p output_self
        dos2unix release/self_exec.sh
        chmod a+x release/start_upgrade.sh
        cp release/start_upgrade.sh output_self/
        cp src output_self/ -Ra
        tar -cf app_self.tar -C output_self .
        cat release/self_exec.sh app_self.tar > release/pkg_`date +%Y%m%d`.csu

clean:
        rm -rf output_self
        rm -f app_self.tar
$ cat release/self_exec.sh
#!/bin/sh
set -e
UPGRADE_DIR="/tmp/unpkg"
line=`wc -l $0 | awk '{print $1}'`;
line=`expr $line - 12`; #减去的数值为exit所在行号
mkdir -p $UPGRADE_DIR
tail -n $line $0 | tar x -C $UPGRADE_DIR
cd $UPGRADE_DIR
./start_upgrade.sh
RET=$?
if [ $RET -eq 0 ]; then rm -rf $UPGRADE_DIR; fi
exit $RET
#-------tar file---begin
$ cat release/start_upgrade.sh
#!/bin/sh
# 示例升级,替换文件
INSTALL_ROOT=/tmp/www
UNPKG_DIR=/tmp/unpkg
SRC_ROOT=${UNPKG_DIR}/src

rm -rf $INSTALL_ROOT
mkdir -p $INSTALL_ROOT
cp $SRC_ROOT/* $INSTALL_ROOT/ -Ra
$ 
```

> 参考：[Linux 下自解压文件的制作](https://www.cnblogs.com/pied/p/5016529.html)

## 3、进程管理systemd

## 4、进程管理supervisord

## 5、日志文件管理logrotate

## 6、文件增量备份

> 参考:
>
> [rsync 用法教程](https://www.ruanyifeng.com/blog/2020/08/rsync.html)

## 7、代理设置

wget可能没法直接下载github上的文件，可能需要代理

- 设置系统全局使用代理：

加入到`/etc/profile`或`~/.bashrc `或`~/.bash_profile `

```bash
export http_proxy="http://127.0.0.1:8118"
export https_proxy="http://127.0.0.1:8118"
```

- 设置git使用代理：

```bash
git config --global http.proxy 'socks5://127.0.0.1:19820'
git config --global https.proxy 'socks5://127.0.0.1:19820'
```

`git@github.com`类的url使用的是ssh协议，需要修改`ssh config`


```bash
ProxyCommand connect -H 127.0.0.1:19820 %h %p
#ProxyCommand ncat --proxy-type http --proxy 127.0.0.1:8118 %h %p
#ProxyCommand ncat --proxy-type socks5 --proxy 127.0.0.1:19820 %h %p
```

- 设置ssh临时使用代理：

```bash
ssh -T github -o ProxyCommand="ncat --proxy-type http --proxy 127.0.0.1:19820 %h %p"
```

- 设置apt使用代理：

加入到`/etc/apt/apt.conf.d/10proxy`

```bash
Acquire::http::Proxy "http://user:pwd@127.0.0.1:8118";
```


- 设置wget使用代理：

加入到`~/.wgetrc`

```bash
http_proxy=http://127.0.0.1:8118
https_proxy=http://127.0.0.1:8118
use_proxy = on
wait = 30
```

临时代理：

```
wget -c -r -np -k -L -p -e "http_proxy=http://127.0.0.1:8118" http://www.subversion.org.cn/svnbook/1.4/
```



wget不支持socks5协议的代理，可以使用Privoxy转换成http代理，编辑添加配置：

```
forward-socks5 / 127.0.0.1:19820 .
```

Privoxy默认监听8118端口

## 8、自定义系统操作历史记录

修改`/etc/profile`，添加如下内容：

```bash
export HISTORY_FILE=/var/log/CommandHistory.log
export PROMPT_COMMAND='{ thisHistID=`history 1|awk "{print \\$1}"`;lastCommand=`history 1| awk "{\\$1=\"\" ;print}"`;time=`date +%Y%m%d-%H%M%S` user=`id -un`;realUser=${LOGNAME} ; ip=${SSH_CONNECTION};if [ ${thisHistID}x != ${lastHistID}x ];then echo -E [$time] $user\($realUser\)    $ip  $lastCommand;fi; }>> $HISTORY_FILE'

export HISTFILE="/wns/history"
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
#export HISTTIMEFORMAT='%F %T '
#export HISTIGNORE="pwd:ls:ls -ltr:ls -l:"
export HISTSIZE=1000
export HISTFILESIZE=1000

```



## 9、自定义定时任务

```bash
[root@gj ~]# cat /etc/crontab
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
* * * * *          /wns/shell/cron_run.sh       min
5 * * * *          /wns/shell/cron_run.sh       hourly
10 3 * * *         /wns/shell/cron_run.sh       daily
0 13 * * *         /wns/shell/cron_run.sh       daily_13
15 2 * * 0         /wns/shell/cron_run.sh       weekly
20 3 1 * *         /wns/shell/cron_run.sh       monthly
*/10 * * * *   /wns/shell/cron_run.sh   10min
[root@gj ~]# cat /wns/shell/cron_run.sh
#!/bin/sh

. /etc/profile

[ -d /wns/etc/cron/cron.$1 ] || exit 1

cd /wns/etc/cron/cron.$1
for i in `ls`; do
    sh ./$i
done
cd -
[root@gj ~]# ls -l /wns/etc/cron/cron.*
/wns//etc/cron/cron.daily:
总用量 12
-rwxr-xr-x. 1 root root 83 12月 18 2020 container_exec.sh
-rwxr-xr-x. 1 root root 77 12月 18 2020 token_update.sh
-rwxr-xr-x. 1 root root 63 12月 18 2020 webui_exec.sh

/wns//etc/cron/cron.hourly:
总用量 12
-rwxr-xr-x. 1 root root  474 12月 18 2020 backup_exec.sh
-rwxr-xr-x. 1 root root 1781 12月 18 2020 db_external_backup_easy_deploy.sh
-rwxr-xr-x. 1 root root 1665 12月 18 2020 db_external_backup.sh

```

把脚本放到对应的目录即可

## 10、iptables基本使用

## 11、firewall基本使用

## 12、selinux基本使用

```bash
#!/usr/bin/env bash

#selinux
semanage fcontext -a -t httpd_sys_script_exec_t '/var/wwws(/.*)?'
restorecon -Rv /var/wwws
semanage fcontext -l | grep '/var/wwws'

#firewall
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload
```

