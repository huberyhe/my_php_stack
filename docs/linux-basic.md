[回到首页](../README.md)

# Linux基础使用

[TOC]

## 1、操作系统

### 1.1、Alpine

#### 1、使用usermod

```bash
echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories
apk --no-cache add shadow
```

## 

## 2、基础命令

### 2.1、top命令交互指令

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

### 2.2、tar归档

1、切换到指定目录后打包：

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

2、查看归档文件内容

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

3、解压到指定目录

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

4、tar.gz格式文件打包与解压

```bash
tar cvzf test.tar.gz test
tar xvzf test.tat.gz
```

5、tar.xz格式文件打包与解压

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

6、iptables四表五链

数据包到了该链处，会去对应表中查询设置的规则，然后决定是否放行、丢弃、转发还是修改等等操作。

四表：filter（过滤）、nat（网络地址转换）、mangle（修改数据包，可实现QOS）、raw（决定数据包是否被状态跟踪机制处理）

五链：INPUT、OUTPUT、FORWARD、PREROUTING、POSTROUTING

命令格式：`iptables [-t 表名] 选项 [链名] [条件] [-j 控制类型]`，默认filter表

