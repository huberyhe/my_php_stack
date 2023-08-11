[回到首页](../README.md)

# 1. Docker基础命令

[TOC]

## 1.1. Docker官方文档

优先查阅官方文档

1、[手册，概念性知识](https://docs.docker.com/desktop/)

2、[参考，命令和API等](https://docs.docker.com/engine/reference/commandline/docker/)

## 1.2. 使用镜像运行容器

```bash
docker run --name c_name -t -i ubuntu:14.04 /bin/bash 
```

## 1.3. 构建镜像

```bash
$ cat Dockerfile 
FROM    centos:6.7
MAINTAINER      Fisher "fisher@sudops.com"

RUN     /bin/echo 'root:123456' |chpasswd
RUN     useradd runoob
RUN     /bin/echo 'runoob:123456' |chpasswd
RUN     /bin/echo -e "LANG=\"en_US.UTF-8\"" >/etc/default/local

EXPOSE  22 80
CMD     /usr/sbin/sshd -D

$ docker build -t runoob/centos:6.7 .
```

> 参考：[Dockerfile 中的 CMD 与 ENTRYPOINT](https://www.cnblogs.com/sparkdev/p/8461576.html)

## 1.4. 给镜像打上标签

```bash
docker tag 860c279d2fec runoob/centos:dev
```

## 1.5. 列出容器的id

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

## 1.6. 列出容器IP

```bash
docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' $(docker ps -aq)
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
```

## 1.7. 过滤容器

```bash
# docker ps --filter "name=vh_php"
CONTAINER ID   IMAGE     COMMAND                 CREATED        STATUS        PORTS     NAMES
47ae9866a377   wacc      "/wns/shell/start.sh"   4 months ago   Up 2 months             vh_php
```

> 支持的过滤条件：[docker ps | Docker Documentation](https://docs.docker.com/engine/reference/commandline/ps/#filtering)

## 1.8. 导入导出

```bash
# 容器
docker export -o postgres-export.tar postgres
docker import postgres-export.tar postgres:latest
# 镜像
docker save -o images.tar postgres:9.6 mongo:3.4
docker load -i images.tar
```

## 1.9. 查看和清理docker占用的磁盘空间

1、查看占用：`docker system df`

```bash
alpine-v:~# docker system df 
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          5         0         484.3MB   484.3MB (100%)
Containers      0         0         0B        0B
Local Volumes   0         0         0B        0B
Build Cache     0         0         0B        0B
```

2、清理停止的容器：`docker container prune`

```bash
alpine-v:~# docker ps --filter "status=exited" --format "table {{.ID}} {{.Names}}"
CONTAINER ID NAMES
977e4d5a51a6 vh_web
alpine-v:~# docker container prune
WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y
Deleted Containers:
977e4d5a51a6d8e95f6d6a3069b38a25aa24c3b95f911514c2d72218567d75d3

Total reclaimed space: 1.093kB
```

3、清理悬挂的镜像：`docker image prune`

```bash
alpine-v:~# docker image ls -f dangling=true
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
alpine-v:~# docker image prune
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B
```

4、清理不再使用的卷：`docker volume prune`

```bash
alpine-v:~# docker volume ls -q
alpine-v:~# docker volume prune
WARNING! This will remove all local volumes not used by at least one container.
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B
```

5、清理build cache：`docker builder prune`

6、一键清理以上所有：`docker system prune`

> 参考：[如何清理 Docker 占用的磁盘空间](https://segmentfault.com/a/1190000021473320)

## 1.10. 修改容器属性

禁用开机自启：

```bash
docker update --restart=no topihsdocwork-topihs-1
```

## 1.11. 时区问题

docker容器默认0时区

1、修改容器时区

```bash
docker run -it -e TZ=Asia/Shanghai ...
```

2、共享宿主机时区

```bash
docker run -it -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro ...
```

3、制作镜像时指定时区

```dockerfile
FROM centos
ENV TZ Asia/Shanghai

RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone
```

> 参考：[Docker 时区调整方案)](https://cloud.tencent.com/developer/article/1626811)

## 1.12. 网络驱动

1.12.1. bridge桥接网络。使用NAT转发端口流量

1.12.2. overlay多机覆盖网络

1.12.3. host主机共享网络

1.12.4. macvlan网络。直接接入虚拟网卡，可划分vlan

## 1.13. CMD和ENTRYPOINT的区别

docker run时可带或不带命令参数，ENTRYPOINT都会执行，CMD只有不带参数才会执行。

```
# Dockerfile
ENTRYPINT ["ping"]
CMD ["www.google.com"]

# 不带参数，实际执行ping www.google.com
docker run -d xxx 

# 带参数，实际执行ping www.youtube.com
docker run -d xxx www.youtube.com

```


> 参考：[How are CMD and ENTRYPOINT different in a Dockerfile? (educative.io)](https://www.educative.io/answers/how-are-cmd-and-entrypoint-different-in-a-dockerfile)

# 2. Docker技巧



## 2.1. 使用宿主机的系统状态

参考`zabbix-agent`的容器启动方式：

```bash
docker run --name zabbix-agent -p 10050:10050 -v /wns/host/zabbix//zabbix_agentd.d:/etc/zabbix/zabbix_agentd.d -v /wns/host/zabbix//wns:/wns -v /proc:/data/proc -v /sys:/data/sys -v /dev:/data/dev -v /var/run/docker.sock:/var/run/docker.sock -e ZBX_HOSTNAME=192.168.1.101 -e ZBX_SERVER_HOST=192.168.1.111 --net=host --pid=host --restart=always --privileged -d zabbix/zabbix-agent:latest
```

- --net=host：使用宿主机的网络命名空间
- --pid=host：使用宿主机的进程命名空间
- --privileged：获取宿主机root权限

## 2.2. 镜像加速

编辑配置文件`/etc/docker/daemon.json`，添加

```bash
{"registry-mirrors":["https://reg-mirror.qiniu.com/"]}
```

重启docker服务

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 2.3. 普通用户使用docker

把普通用户加到docker组即可

```bash
sudo usermod -aG docker hubery
```

## 2.4. 使用多阶段Dockerfile对Go服务容器化

```Dockerfile
FROM golang:1.11 as builder
# ...
RUN CGO_ENABLED=0 GOOS=linux go build -o /link_service -a -tags netgo -ldflags '-s -w'

FROM scratch
COPY --from=builder /link_service /app/link_service
EXPOSE 7070
ENTRYPOINT ["/app/link_service"]
```

得到了一个最小、最安全的镜像。

## 2.5. 容器中使用docker

```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker centos:7 /bin/bash
```

## 2.6. 查看进程所属的容器

```
docker ps -q | xargs docker inspect --format '{{.State.Pid}}, {{.Name}}' | grep "PID"
```