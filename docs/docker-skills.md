[回到首页](../README.md)

# 1. Docker技巧

[TOC]

## 1.1. 使用宿主机的系统状态

参考`zabbix-agent`的容器启动方式：

```bash
docker run --name zabbix-agent -p 10050:10050 -v /wns/host/zabbix//zabbix_agentd.d:/etc/zabbix/zabbix_agentd.d -v /wns/host/zabbix//wns:/wns -v /proc:/data/proc -v /sys:/data/sys -v /dev:/data/dev -v /var/run/docker.sock:/var/run/docker.sock -e ZBX_HOSTNAME=192.168.1.101 -e ZBX_SERVER_HOST=192.168.1.111 --net=host --pid=host --restart=always --privileged -d zabbix/zabbix-agent:latest
```

- --net=host：使用宿主机的网络命名空间
- --pid=host：使用宿主机的进程命名空间
- --privileged：获取宿主机root权限

## 1.2. 镜像加速

编辑配置文件`/etc/docker/daemon.json`，添加

```bash
{"registry-mirrors":["https://reg-mirror.qiniu.com/"]}
```

重启docker服务

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## 1.3. 普通用户使用docker

把普通用户加到docker组即可

```bash
sudo usermod -aG docker hubery
```

## 1.4. 使用多阶段Dockerfile对Go服务容器化

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

## 1.5. 容器中使用docker

```bash
docker run -it -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker centos:7 /bin/bash
```