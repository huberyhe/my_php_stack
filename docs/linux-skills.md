[回到首页](../README.md)

# Linux技巧

## 1、yum update时忽略某些软件：
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

> 参考：[Linux 下自解压文件的制作](https://www.cnblogs.com/pied/p/5016529.html)

## 3、进程管理systemd

## 4、进程管理supervisord

## 5、日志文件管理logrotate
