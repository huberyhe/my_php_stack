[回到首页](../README.md)

# Docker基础命令

使用镜像运行容器：

```bash
docker run --name c_name -t -i ubuntu:14.04 /bin/bash 
```

构建镜像：

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

给镜像打上标签：

```bash
docker tag 860c279d2fec runoob/centos:dev
```

