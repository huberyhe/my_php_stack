[回到首页](../README.md)

# Linux技巧

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
