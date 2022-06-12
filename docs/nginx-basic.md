[回到首页](../README.md)

# 1. Nginx基础知识

nginx基础知识与常用配置

[TOC]

## 1.1. 标题1

## 1.2. 常用配置

worker_processes auto;

gzip on|off;

expires 30m;

> 参考：https://segmentfault.com/a/1190000015051369

## 1.3. 日志清理

方法1：删除日志后，让nginx重新打开日志文件，改操作不会影响nginx业务处理

```bash
rm access.log
nginx -s reopen
```

方法2：清空日志内容

```bash
cat /dev/null > access.log
```

其他方法可能导致不写日志，谨慎操作。例如删除文件或`cat > access.log`

