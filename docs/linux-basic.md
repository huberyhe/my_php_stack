[回到首页](../README.md)

# 1. Linux基础使用

[TOC]

## 1.1. 操作系统

### 1.1.1. Alpine

#### 1.1.1.1. 使用usermod

```bash
echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
apk --no-cache add shadow
```

### 1.1.2. CentOS

#### 1.1.2.1. 网络管理

```bash
# 交互式网卡配置修改
nmtui
```



## 1.2. 

## 1.3. 基础命令

### 1.3.1. top命令交互指令

```
c： 显示完整的命令
d： 更改刷新频率
f： 增加或减少要显示的列(选中的会变成大写并加*号)
F： 选择排序的列
h： 显示帮助画面
H： 显示线程
i： 忽略闲置和僵死进程
k： 通过给予一个PID和一个signal来终止一个进程。（默认signal为15。在安全模式中此命令被屏蔽）
l:  显示平均负载以及启动时间（即显示影藏第一行）
m： 显示内存信息
M： 根据内存资源使用大小进行排序
N： 按PID由高到低排列
o： 改变列显示的顺序
O： 选择排序的列，与F完全相同
P： 根据CPU资源使用大小进行排序
q： 退出top命令
r： 修改进程的nice值(优先级)。优先级默认为10，正值使优先级降低，反之则提高的优先级
s： 设置刷新频率（默认单位为秒，如有小数则换算成ms）。默认值是5s，输入0值则系统将不断刷新
S： 累计模式（把已完成或退出的子进程占用的CPU时间累计到父进程的MITE+ ）
T： 根据进程使用CPU的累积时间排序
t： 显示进程和CPU状态信息（即显示影藏CPU行）
u： 指定用户进程
W： 将当前设置写入~/.toprc文件，下次启动自动调用toprc文件的设置
<： 向前翻页
>： 向后翻页
?： 显示帮助画面
1(数字1)： 显示每个CPU的详细情况
```

### 1.3.2. tar归档

#### 1.3.2.1. 切换到指定目录后打包：

如果我想打包`/mnt/d/Workspace/业务@云平台/script_tools`目录下的`wac_login`目录，

可以先cd切换到目录，然后对`wac_login`打包

```bash
cd /mnt/d/Workspace/业务@云平台/script_tools && tar cf /tmp/test_wac_login.tar wac_login
```

或者使用`-C`参数

```bash
tar cf /tmp/test_wac_login.tar -C /mnt/d/Workspace/业务@云平台/script_tools wac_login
```

例：

```bash
[  9:29AM ]  [ hubery@PC-33521:/tmp ]
 $ ls -l /mnt/d/Workspace/业务@云平台/script_tools/wac_login
total 260
-rwxrwxrwx 1 hubery hubery   6694 Aug 11 17:21 dig.php
drwxrwxrwx 1 hubery hubery   4096 Aug 10 17:07 pem_files
-rwxrwxrwx 1 hubery hubery    833 Aug 11 18:51 phar_build.php
-rwxrwxrwx 1 hubery hubery   2760 Aug 11 21:03 sundray_yun.php
-rwxrwxrwx 1 hubery hubery 232103 Aug 11 21:03 test_wac_login.phar
-rwxrwxrwx 1 hubery hubery   1937 Aug 11 21:02 test_wac_login.php
-rwxrwxrwx 1 hubery hubery  10240 Aug 12 09:16 test_wac_login.tar
[  9:29AM ]  [ hubery@PC-33521:/tmp ]
 $ tar cf test_wac_login.tar -C /mnt/d/Workspace/业务@云平台/script_tools wac_login
[  9:29AM ]  [ hubery@PC-33521:/tmp ]
 $ ls -l /tmp/test_wac_login.tar
-rw-r--r-- 1 hubery hubery 491520 Aug 12 09:29 /tmp/test_wac_login.tar
```

#### 1.3.2.2. 查看归档文件内容

```bash
tar -tf test_wac_login.tar
```

例：

```bash
[  9:29AM ]  [ hubery@PC-33521:/tmp ]
 $ tar -tf test_wac_login.tar
wac_login/
wac_login/dig.php
wac_login/pem_files/
wac_login/pem_files/CAchain.pem
wac_login/pem_files/clientcert.pem
wac_login/pem_files/clientkey.pem
wac_login/phar_build.php
wac_login/sundray_yun.php
wac_login/test_wac_login.phar
wac_login/test_wac_login.php
wac_login/test_wac_login.tar
```

#### 1.3.2.3. 解压到指定目录

```bash
tar xf /tmp/test_wac_login.tar -C ~/
```

例：

```bash
[  9:34AM ]  [ hubery@PC-33521:/tmp ]
 $ tar xf /tmp/test_wac_login.tar -C ~/
[  9:37AM ]  [ hubery@PC-33521:/tmp ]
 $ ls -l ~/wac_login
total 352
-rwxr-xr-x 1 hubery hubery   6694 Aug 11 17:21 dig.php
drwxr-xr-x 1 hubery hubery    512 Aug 10 17:07 pem_files
-rwxr-xr-x 1 hubery hubery    833 Aug 11 18:51 phar_build.php
-rwxr-xr-x 1 hubery hubery   2760 Aug 11 21:03 sundray_yun.php
-rwxr-xr-x 1 hubery hubery 232103 Aug 11 21:03 test_wac_login.phar
-rwxr-xr-x 1 hubery hubery   1937 Aug 11 21:02 test_wac_login.php
-rwxr-xr-x 1 hubery hubery  10240 Aug 12 09:16 test_wac_login.tar
```

#### 1.3.2.4. tar.gz格式文件打包与解压

```bash
tar cvzf test.tar.gz test
tar xvzf test.tat.gz
```

#### 1.3.2.5. tar.xz格式文件打包与解压

```bash
tar cvf test.tar test
xz -z test.tar
# 或一步完成
tar cvJf test.tar.xz test

xz -d node-v8.11.1-linux-x64.tar.xz
tar xvf node-v8.11.1-linux-x64.tar.xz123
# 或一步完成
tar xvJf node-v8.11.1-linux-x64.tar.xz1
```

#### 1.3.2.6. 利用tar备份文件

```bash
 $ tar -cpf - /etc/init.d/README -C / | tar -xpf - -C /tmp
tar: Removing leading `/' from member names
 $ ls /tmp/etc/init.d/README
/tmp/etc/init.d/README
```

#### 1.3.2.7. 按行读取文件

```bash
cat data.dat | while read line
do
    echo "File:${line}"
done

while read line
do
    echo "File:${line}"
done < data.dat
```

> 注意：这种方法可能丢失最后一行

#### 1.3.2.8. 指定解压文件的前缀路径

```bash
       --strip-components=NUMBER
              strip NUMBER leading components from file names on extraction
```

该参数可以去掉归档文件的前缀路径，配合`-C`可以修改前缀路径。例：

```bash
 $ mkdir tar_test && cd tar_test
 $ wget -O mysql-5.6.15.tar.gz  http://oss.aliyuncs.com/aliyunecs/onekey/mysql/mysql-5.6.15-linux-glibc2.5-i686.tar.gz
 $ tar xvzf mysql-5.6.15.tar.gz
 $ ls -l
total 289484
drwxr-xr-x 13 hubery hubery      4096 Apr 14 09:03 mysql-5.6.15-linux-glibc2.5-i686
-rw-r--r--  1 hubery hubery 296419798 Dec 26  2013 mysql-5.6.15.tar.gz
 $ mkdir ./mysql-5.6.15 && tar -xzvf mysql-5.6.15.tar.gz -C ./mysql-5.6.15 --strip-components 1
 $ ls -l mysql-5.6.15
total 156
-rw-r--r--  1 hubery hubery 17987 Nov 18  2013 COPYING
-rw-r--r--  1 hubery hubery 88388 Nov 18  2013 INSTALL-BINARY
-rw-r--r--  1 hubery hubery  2496 Nov 18  2013 README
drwxr-xr-x  2 hubery hubery  4096 Apr 14 09:04 bin
drwxr-xr-x  3 hubery hubery  4096 Apr 14 09:04 data
drwxr-xr-x  2 hubery hubery  4096 Apr 14 09:04 docs
drwxr-xr-x  3 hubery hubery  4096 Apr 14 09:04 include
drwxr-xr-x  3 hubery hubery  4096 Apr 14 09:04 lib
drwxr-xr-x  4 hubery hubery  4096 Apr 14 09:04 man
drwxr-xr-x 10 hubery hubery  4096 Apr 14 09:04 mysql-test
drwxr-xr-x  2 hubery hubery  4096 Apr 14 09:04 scripts
drwxr-xr-x 28 hubery hubery  4096 Apr 14 09:04 share
drwxr-xr-x  4 hubery hubery  4096 Apr 14 09:04 sql-bench
drwxr-xr-x  3 hubery hubery  4096 Apr 14 09:04 support-files
```

#### 1.3.2.9. 归档时使用绝对路径

```bash
       -P, --absolute-names
              don't strip leading `/'s from file names
```

用于保留绝对路径。默认归档解解开使用的相对路径，解开时需要加`-C`参数指定路径，更好的方法是归档和解开时都加`-P`参数。例：

```bash
 $ tar cf tar_test.tar /home/hubery/tar_test
tar: Removing leading `/' from member names
 $ tar xvf tar_test.tar
home/hubery/tar_test/
home/hubery/tar_test/123
 $ ls -l ./home/hubery/tar_test
total 0
-rw-r--r-- 1 hubery hubery 0 Apr 14 09:18 123
 $ tar xvf tar_test.tar -C /
home/hubery/tar_test/
home/hubery/tar_test/123
 $ tar cfP tar_test.tar /home/hubery/tar_test
 $ tar xvfP tar_test.tar
/home/hubery/tar_test/
/home/hubery/tar_test/123
```

#### 1.3.2.10. 归档时修改文件路径

```bash
       --transform=EXPRESSION, --xform=EXPRESSION
              use sed replace EXPRESSION to transform file names

              File name matching options (affect both exclude and include patterns):
```

可以修改文件路径，语法同sed。例：

```bash
# 将 ./ 替换成 usr/
tar -cf archive.tar --transform 's,^\./,usr/,'
# 添加 new 后缀
tar -cf archive.tar --transform 's/$/new/'
```



### 1.3.3. iptables四表五链

数据包到了该链处，会去对应表中查询设置的规则，然后决定是否放行、丢弃、转发还是修改等等操作。

四表：filter（过滤）、nat（网络地址转换）、mangle（修改数据包，可实现QOS）、raw（决定数据包是否被状态跟踪机制处理）

五链：INPUT、OUTPUT、FORWARD、PREROUTING、POSTROUTING

命令格式：`iptables [-t 表名] 选项 [链名] [条件] [-j 控制类型]`，默认filter表

### 1.3.4. zip和unzip

命令格式：`zip -r <zip name> <files>`

#### 1.3.4.1. 排除目录

`-x`参数，参数为文件路径，须用引号

例如：

```bash
zip -r backend_3party.zip /go/gopath/src/ -x '/go/gopath/src/backup_20220107.zip' -x '/go/gopath/src/cloud.google.com/*'
```

#### 1.3.4.2. 不包含路径

```bash
[root@14148d2ac790 ~]# zip -r /dockertmp/package/0.130b220616/do_upgrade_3-1-0.130b220616.zip /dockertmp/package/0.130b220616/do_upgrade.sh /dockertmp/package/0.130b220616/upgrade_pkgs.tar.gz -j
  adding: do_upgrade.sh (deflated 65%)
  adding: upgrade_pkgs.tar.gz (deflated 1%)
[root@14148d2ac790 ~]# unzip -t /dockertmp/package/0.130b220616/do_upgrade_3-1-0.130b220616.zip 
Archive:  /dockertmp/package/0.130b220616/do_upgrade_3-1-0.130b220616.zip
    testing: do_upgrade.sh            OK
    testing: upgrade_pkgs.tar.gz      OK
No errors detected in compressed data of /dockertmp/package/0.130b220616/do_upgrade_3-1-0.130b220616.zip.
```



### 1.3.5. `free -m`中各字段的意义

``` bash
 $ free -m
              total        used        free      shared  buff/cache   available
Mem:           1837         251        1205          19         380        1422
Swap:          3071           0        3071
```

Mem行表示：从操作系统看到总共1837M物理内存，使用了251M，另外进程共享使用19M，缓冲和缓存使用380M，剩余1205M（total=used+free+buff/cache）。以及从应用程序看到的可用内存1422M。

Swap行表示：交换分区总共3701M，使用0M，剩余3701M

> 参考：[Linux free字段解析](https://www.cnblogs.com/likui360/p/6263987.html)

### 1.3.6. ps使用

#### 1.3.6.1. 查看程序启动时间

```bash
ps -eo pid,lstart,etime,cmd | grep nginx
```

#### 1.3.6.2. 进程状态

D            不可中断睡眠（通常进程在进行I/O）
R            运行中或者可运行状态（在运行队列中）
S            可中断睡眠（等待event，进程idle中）
T            进程停止（进程被trace或者进程被信号停止）
X            进程死亡（应该永不可见）
Z            僵尸进程（结束，但是父进程没有wait该子进程）

对于BSD格式，状态码可以附加额外的字符（如S+）：
<            高优先级进程
N            低优先级进程
L             进程进行了内存锁定 (避免swap)
s             进程是session leader
l              多线程（using CLONE_THREAD, like NPTL pthreads do）
`+`             属于前台进程组

简单的进程状态切换图：

![进程状态切换图](../imgs/271837056063571.png)

### 1.3.7. 安装开发常用软件

```bash
# debian 系
apt install build-essential 

# redhat 系
yum groupinstall "Development Tools"
```

### 1.3.8. 系统强制重启

```bash
reboot -nf
```

> 参考：[强制重启Linux系统的几种方法%%%%](https://zohead.com/archives/linux-force-reboot/)

## 1.4. 日志截断

```bash
truncate -s 0 logfile
```

## 1.5. 时间和时区设置

### 1.5.1. 设置时间

```bash
date -s "20220530 11:30:00"
```

### 1.5.2. 设置硬件时钟

```bash
hwclock --set --date="11/03/17 14:55"
hwclock --show
```

### 1.5.3. 设置时区

```bash
# 用户环境时区,tzselect命令帮助生成一个环境变量设置命令
TZ='Asia/Shanghai'; export TZ

# 系统时区
echo "ZONE=Asia/Shanghai" >> /etc/sysconfig/clock
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
reboot

# centos系统时区
timedatectl set-timezone Asia/Shanghai
reboot
```

## 1.6. 网络设置

### 1.6.1. ip配置

### 1.6.2. dns配置

### 1.6.3. 网卡状态

可查看网卡是否接了网线

```bash
ethtool enp0s3
```

## 1.7. 文件权限

最常见的，每个文件有ugo三类，每类rwx共九个属性

### 1.7.1. 隐藏属性

通过`lsattr`查看隐藏属性，`chattr`修改隐藏属性。例如i属性让文件不能删除和修改

```bash
 $ cd /tmp                                                                                                              
 $ touch 123
 $ sudo chattr +i 123
 $ sudo rm 123
rm: cannot remove ‘123’: Operation not permitted
```

### 1.7.2. 文件特殊权限： SUID, SGID, SBIT

SUID：普通用户没有`/etc/passwd`的修改权限，但是可以通过`passwd`修改自己的密码
SGID：普通用户没有`/var/lib/mlocate/mlocate.db`的可读权限，但是可以通过`locate`找到这个文件
SBIT：普通用户可以在`/tmp`目录下创建文件，但不能删除其他人创建的文件

```bash
 $ ls -l /usr/bin/passwd 
-rwsr-xr-x. 1 root root 27856 Apr  1  2020 /usr/bin/passwd
 $ ls -l /etc/passwd
-rw-r--r-- 1 root root 1384 Oct 24 14:30 /etc/passwd

# ll /usr/bin/locate /var/lib/mlocate/mlocate.db
-rwx--s--x. 1 root slocate   40496 Jun 10  2014 /usr/bin/locate
-rw-r-----. 1 root slocate 2349055 Jun 15 03:44 /var/lib/mlocate/mlocate.db

 $ ls -ld /tmp      
drwxrwxrwt. 11 root root 4096 Apr  7 14:58 /tmp
```

> 参考：《鸟哥的私房菜》






