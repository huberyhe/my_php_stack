[回到首页](../README.md)

# Linux下打包

说明

[TOC]

## 1、RPM包

下载rpm包：`sudo yum install --downloadonly nginx --downloaddir=./ `

查看包的：`rpm -qpi topihs-server-3.1-0.128b220210.x86_64.rpm`

查看包的脚本：`rpm --scripts -qp topihs-server-3.1-0.128b220210.x86_64.rpm`

重新打包rpm：`rpmrebuild --package --notest-install -e wget-1.14-18.el7_6.1.x86_64.rpm`

查看已安装包的spec：`rpmrebuild -s wget.spec wget`

>  参考：
>
>  1、[使用spec文件语法创建一个rpm](https://www.cnblogs.com/zafu/p/7423758.html)
>
>  2、[升级和安装的rpm过程中 spec 文件中脚本调用顺序和参数](https://blog.csdn.net/kyle__shaw/article/details/115461583)
>
>  3、[RPM 包的构建 - SPEC 基础知识](https://www.cnblogs.com/michael-xiang/p/10480809.html)
>
>  4、[RPM Packaging Guide (rpm-packaging-guide.github.io)](https://rpm-packaging-guide.github.io/#files)
>
>  5、[rpm升级 配置文件处理规则](http://blog.chinaunix.net/uid-11989741-id-3365435.html)
>
>  6、[Building and distributing packages – IBM Developer](https://developer.ibm.com/tutorials/l-rpm1/)

## 2、DEB包

## 3、ssu包（sangfor）

