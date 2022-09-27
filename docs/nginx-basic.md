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

## 1.4. 最大文件打开数量限制

nginx默认只只能打开1024个文件，超出后报错*Too many open files*

查看限制：

```bash
$ cat /proc/`ps -ef | grep nginx | grep master | awk '{print $2}'`/limits | grep -E "^Limit|open files"
Limit                     Soft Limit           Hard Limit           Units     
Max open files            1024                 4096                 files
```

修改限制：

1、systemd限制，修改nginx的systemd文件，添加字段，然后重新加载

```
[Service]
LimitNOFILE=20480
```

2、nginx限制，修改nginx配置文件，添加全局字段，然后重启服务

```
worker_rlimit_nofile 20000;
```

3、为有更好的并发，修改ningx worker的连接数限制

```
events {
    worker_connections  10240;
}
```

对于系统级限制可以参考[Linux技巧 1.14. 修改文件描述符数量限制](./linux-sills.md)

## 1.5. url代理去掉前缀

需求：访问http://example.com/v1/api/test，后端接口路由为`/api/test`

1、方法1：

```
server {
    location ^~/v1/ {
    	proxy_pass http://localhost:8080/;
    }
}
```

`^~/v1/`匹配v1开头的url，proxy_pass后加`/`可去掉`/v1/`前缀

2、方法2:

```
server {
    location ^~/v1/ {
    	rewrite ^/v1/(.*)$ /$1 break;
    	proxy_pass http://localhost:8080;
    }
}
```

> 参考：[Nginx 配置反向代理去除前缀](https://segmentfault.com/a/1190000037601092)
