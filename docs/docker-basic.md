[回到首页](../README.md)

# 1. Docker基础命令

[TOC]

## 1.1. Docker官方文档：

[docker | Docker Documentation](https://docs.docker.com/engine/reference/commandline/docker/)

## 1.2. 使用镜像运行容器：

```bash
docker run --name c_name -t -i ubuntu:14.04 /bin/bash 
```

## 1.3. 构建镜像：

```
$ cat Dockerfile 
FROM    centos:6.7
MAINTAINER      Fisher "fisher@sudops.com"

RUN     /bin/echo 'root:123456' |chpasswd
RUN     useradd runoob
RUN     /bin/echo 'runoob:123456' |chpasswd
RUN     /bin/echo -e "LANG=\"en_US.UTF-8\"" >/etc/default/local
EXPOSE  22
EXPOSE  80
CMD     /usr/sbin/sshd -D

$ docker build -t runoob/centos:6.7 .
```

## 1.4. 给镜像打上标签：

```bash
docker tag 860c279d2fec runoob/centos:dev
```

## 1.5. 列出容器的id：

```bash
# docker ps --format "table {{.ID}} {{.Names}}"
CONTAINER ID NAMES
d86ac2946c01 zabbix-agent
e53b8917bc48 vh_mdq_proxyd
e7356180b1d1 vh_push
99fbe2cd14da vh_mqtt
f03974f382e9 vh_wxwifi
```

> 支持的占位符：[docker ps | Docker Documentation](https://docs.docker.com/engine/reference/commandline/ps/#formatting)

## 1.6. 列出容器IP：

```bash
docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' $(docker ps -aq)
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
```

## 1.7. 过滤容器：

```bash
# docker ps --filter "name=vh_php"
CONTAINER ID   IMAGE     COMMAND                 CREATED        STATUS        PORTS     NAMES
47ae9866a377   wacc      "/wns/shell/start.sh"   4 months ago   Up 2 months             vh_php
```

## 1.8. 导入导出：

```bash
# 容器
docker export -o postgres-export.tar postgres
docker import postgres-export.tar postgres:latest
# 镜像
docker save -o images.tar postgres:9.6 mongo:3.4
docker load -i images.tar
```



> 支持的过滤条件：[docker ps | Docker Documentation](https://docs.docker.com/engine/reference/commandline/ps/#filtering)
