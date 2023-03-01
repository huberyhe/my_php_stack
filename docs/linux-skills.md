[回到首页](../README.md)

# 1. Linux技巧

[TOC]

## 1.1. yum update时忽略某些软件
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

## 1.2. 自解压文件：用于制作单文件升级包

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

## 1.3. 进程管理systemd

[官网 System and Service Manager (systemd.io)](https://systemd.io/)


### 1.3.1. 入门使用

```bash
cat > /usr/lib/systemd/system/foo.service<< EOF
[Unit]
Description=Foo

[Service]
ExecStart=/usr/sbin/foo-daemon

[Install]
WantedBy=multi-user.target
EOF

systemctl enable foo.service
systemctl start foo.service
```

Service没有指定Type，默认Type=simple，适用于简单的单体应用，如果是守护进程，应使用Type=forking

Service没有指定ExecStop，systemctl会发送SIGTERM信号来停止服务，超时则发送SIGKILL信号

### 1.3.2. 官方示例

nginx

```yaml
[Unit]
Description=The nginx HTTP and reverse proxy server
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
# Nginx will fail to start if /run/nginx.pid already exists but has the wrong
# SELinux context. This might happen when running `nginx -t` from the cmdline.
# https://bugzilla.redhat.com/show_bug.cgi?id=1268621
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
KillSignal=SIGQUIT
TimeoutStopSec=5
KillMode=process
PrivateTmp=true
Restart=always
MemoryLimit=2048K

[Install]
WantedBy=multi-user.target
```


php-fpm

```yaml
[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=notify
PIDFile=/run/php-fpm/php-fpm.pid
EnvironmentFile=/etc/sysconfig/php-fpm
ExecStart=/usr/sbin/php-fpm --nodaemonize
ExecReload=/bin/kill -USR2 $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

crond

```yaml
[Unit]
Description=Command Scheduler
After=auditd.service systemd-user-sessions.service time-sync.target

[Service]
EnvironmentFile=/etc/sysconfig/crond
ExecStart=/usr/sbin/crond -n $CRONDARGS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=30s

[Install]
WantedBy=multi-user.target
```

uwsgi

```yaml
[Unit]
Description=uWSGI Emperor
After=syslog.target

[Service]
ExecStart=/root/uwsgi/uwsgi --ini /etc/uwsgi/emperor.ini
# Requires systemd version 211 or newer
RuntimeDirectory=uwsgi
Restart=always
KillSignal=SIGQUIT
Type=notify
StandardError=syslog
NotifyAccess=all

[Install]
WantedBy=multi-user.target
```



### 1.3.3. 限制服务资源

利用cgroups防止服务占用过多系统资源，比如内存限制到2G，超出就重启

1、使用`systemctl set-property`命令

```bash
# systemctl set-property mysql@3327.service MemoryLimit=5G       # 5G 内存
# systemctl set-property mysql@3327.service CPUQuota=150%        # 150% cpu 使用率
# systemctl set-property mysql@3327.service BlockIOWeight=1000   # IO 权重

# systemctl show mysql@3327.service -p MemoryLimit # 查看某个参数
```

这个操作会写到配置文件，将永久生效，如果想只生效一次，可加上`--runtime`参数

2、写到配置文件Service

```yaml
[Service]
MemoryLimit=5G
```



### 1.3.4. watchdog软狗

设置Service的Type=notify，服务在运行时定时发送心跳到systemd服务，避免服务卡死

python可以使用`systemd.daemon`包，go可以使用`coreos/go-systemd`包

### 1.3.5. 其他常用命令

列出所有配置文件

```bash
systemctl list-unit-files
```

显示某个unit的底层参数

```bash
systemctl show httpd.service
```

服务是否启动

```bash
systemctl is-active nginx.service
```

查看各服务启动耗时

```bash
systemd-analyze blame
```

### 1.3.6. 管理一组服务

假设app服务组有service1、service2、service3三个子服务，且service3依赖service2
app.service

```bash
[Unit]
Description=Application

[Service]
# The dummy program will exit
Type=oneshot
# Execute a dummy program
ExecStart=/bin/true
# This service shall be considered active after start
RemainAfterExit=yes

[Install]
# Components of this application should be started at boot time
WantedBy=multi-user.target
```

app-srv1.service

```yaml
[Unit]
Description=Application Component 1
# When systemd stops or restarts the app.service, the action is propagated to this unit
PartOf=app.service
# Start this unit after the app.service start
After=app.service

[Service]
# Pretend that the component is running
ExecStart=/bin/sleep infinity
# Restart the service on non-zero exit code when terminated by a signal other than SIGHUP, SIGINT, SIGTERM or SIGPIPE
Restart=on-failure

[Install]
# This unit should start when app.service is starting
WantedBy=app.service
```

app-srv2.service

```yaml
[Unit]
Description=Application Component 2
PartOf=app.service
After=app.service

[Service]
ExecStart=/bin/sleep infinity
Restart=on-failure

[Install]
WantedBy=app.service
```

app-srv3.service

```yaml
[Unit]
Description=Application Component 3
PartOf=app.service
After=app.service
# This unit should start after the app-component2 started
After=app-component2.service

[Service]
ExecStart=/bin/sleep infinity
Restart=on-failure

[Install]
WantedBy=app.service
```



> 参考：
>
> 1、[Systemd 入门教程：命令篇 - 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
>
> 2、[systemd.service](https://www.freedesktop.org/software/systemd/man/systemd.service.html#)
>
> 3、[How do i change property values for a systemd service?](https://www.lightnetics.com/topic/17440/how-do-i-change-property-values-for-a-systemd-service)
>
> 4、[利用 systemd 的 watchdog 功能重启卡住的服务](https://blog.lilydjwg.me/2016/12/22/restart-services-with-watchdog-feature-of-systemd.207942.html)
>
> 5、[Using systemd services of Type=notify with Watchdog in C – Hackeriet](https://blog.hackeriet.no/systemd-service-type-notify-and-watchdog-c/)
>
> 6、[使用 systemd 限制系统资源的使用](https://blog.arstercz.com/使用-systemd-限制系统资源的使用/)
>
> 7 、[Controlling a Multi-Service Application with systemd](https://alesnosek.com/blog/2016/12/04/controlling-a-multi-service-application-with-systemd/)

## 1.4. 进程管理supervisord

## 1.5. 日志文件管理logrotate

## 1.6. 文件增量备份

> 参考:
>
> [rsync 用法教程](https://www.ruanyifeng.com/blog/2020/08/rsync.html)

## 1.7. 代理设置

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

## 1.8. 自定义系统操作历史记录

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



## 1.9. 自定义定时任务

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

## 1.10. iptables基本使用

## 1.11. firewall基本使用

```
firewall-cmd --add-port=19192/tcp
firewall-cmd --remove-port=19196/tcp
firewall-cmd --list-ports
firewall-cmd --runtime-to-permanent
firewall-cmd --permanent --list-ports
```

> 参考：https://docs.fedoraproject.org/en-US/quick-docs/firewalld/

## 1.12. selinux基本使用

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

## 1.13. 查看硬件信息

```bash
# cpu
lscpu
# 内存
dmidecode -t memory
# 硬盘
smartctl -i /dev/sdb
```

## 1.14. 修改文件描述符数量限制

1、查看限制

```bash
[root@localhost hubery]# ulimit -n
1024
[root@localhost hubery]# ulimit -Sn
1024
[root@localhost hubery]# ulimit -Hn
524288
[root@localhost hubery]# cat /proc/sys/fs/file-max
379276
```

2、临时设置限制

用户级

```bash
[root@localhost hubery]# ulimit -Sn 4096
```

内核级

```
[root@localhost hubery]# sysctl -w fs.file-max=100000
fs.file-max = 100000
```

4、设置内核级限制，打开`/etc/sysctl.conf`，加上。`sysctl -p`生效

```bash
fs.file-max = 100000
```

验证是否生效

```bash
cat /proc/sys/fs/file-max
```

5、设置用户级限制，打开`/etc/security/limits.conf`，加上。重新登录有效

```
* soft nofile 8192
* hard nofile 20480
```

6、除了内核和用户级限制外，应用也会受限制

查看：

```bash
cat /proc/pid/limits
```

对于systemd管理的应用，加上字段

```
[Service]
LimitNOFILE=65536
```

应用本身也可能有限制，比如nginx：

```
worker_rlimit_nofile 20000;
```

>  参考：
>  1、[Fixing the “Too many open files” Error in Linux](https://www.baeldung.com/linux/error-too-many-open-files)
>  2、[How to Solve the “Too Many Open Files” Error on Linux](https://www.howtogeek.com/805629/too-many-open-files-linux/)
>  3、[文件描述符(fd)泄漏排查一篇就够了](https://blog.csdn.net/blankti/article/details/100808475)

7、查看文件描述符使用情况

```bash
# cat /proc/sys/fs/file-nr
13440	0	9223372036854775807
# cat  /proc/sys/fs/file-max
9223372036854775807
```

```bash
lsof | awk '{ print $1 " " $2; }' | sort -rn | uniq -c | sort -rn | head -15
cat /proc/sys/fs/file-nr
```

`lsof -p <pid>`看到的是pid进程不包含子进程的fd。由于子进程和子线程可能复用父进程的fd，lsof实际查到的会存在重复，参考：[linux - Number of file descriptors: different between /proc/sys/fs/file-nr and /proc/$pid/fd? - Server Fault](https://serverfault.com/questions/485262/number-of-file-descriptors-different-between-proc-sys-fs-file-nr-and-proc-pi)

查看排行：
```bash
for pid in /proc/[0-9]*; do p=$(basename $pid); printf "%4d FDs for PID %6d; command=%s\n" $(ls $pid/fd | wc -l) $p "$(ps -p $p -o comm=)"; done | sort -nr | head -10


find /proc -maxdepth 1 -type d -name '[0-9]*' \
     -exec bash -c "ls {}/fd/ | wc -l | tr '\n' ' '" \; \
     -printf "fds (PID = %P), command: " \
     -exec bash -c "tr '\0' ' ' < {}/cmdline" \; \
     -exec echo \; | sort -rn | head
```

总数：
```bash
find /proc -maxdepth 1 -type d -name '[0-9]*' -exec bash -c 'ls {}/fd/ | wc -l' \; | awk '{sum+=$1} END {print sum}'

ps -eL | awk 'NR > 1 { print $1, $2 }' | \
while read x; do \
    find /proc/${x% *}/task/${x#* }/fd/ -type l; \
done | wc -l
```

## 1.15. 查看和设置默认编辑器

查看：
```bash
# 方法1
sudo update-alternatives --config editor

# 方法2
echo $EDITOR
```

设置：
```bash
export VISUAL="/usr/bin/nano"
export EDITOR="$VISUAL"
```

ctrl+r ctrl+e 查看效果