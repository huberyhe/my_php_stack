[回到首页](../README.md)

# 工具

openssl获取证书信息：

```bash
openssl x509 -in cert.pem -noout -text
```

> 参考：
>
> [openssl 查看证书细节](https://www.cnblogs.com/shenlinken/p/9968274.html)

## wireshark与tcpdump

1、抓https的tls握手包

```bash
tcpdump -ni eth0 "tcp port 443 and (tcp[((tcp[12] & 0xf0) >> 2)] = 0x16)"
```

>  参考：[仅使用tcpdump捕获ssl握手](https://www.thinbug.com/q/39624745)

2、wireshark常用过滤条件

- ip过滤：`ip.addr`过滤源或目的ip，`ip.src`过滤源ip，`ip.dst`过滤目的ip，如`ip.addr==45.77.245.161`
- 端口过滤：`tcp.port`过滤源或目的端口，`tcp.srcport`过滤源端口，`tcp.dstport`过滤目的端口，如`tcp.srcport==443`
- 协议过滤：直接输入协议名即可，例如`icmp`
- http模式过滤：`http.request.method=="GET"`过滤GET请求
- 连接符：`and`、`or`、`&&`、`||`

3、http三次握手

发送端发送一个SYN=1，ACK=0标志的数据包给接收端，请求进行连接；

接收端收到请求并允许连接的话，会发送一个SYN=1，ACK=1标志的数据包给发送端，告诉它可以通讯了；

发送端发送一个SYN=0，ACK=1标志的数据包给接收端，告诉它连接已确认。之后tcp连接建立，开始通讯。

![image-20210716001431662](../imgs/image-20210716001431662.png)

4、TCP标志位

在TCP层，有个FLAGS字段，这个字段有以下几个标识：SYN, FIN, ACK, PSH, RST, URG。其中，对于我们日常的分析有用的就是前面的五个字段。它们的含义是：SYN表示建立连接，FIN表示关闭连接，ACK表示响应，PSH表示有 DATA数据传输，RST表示连接重置。

其中，ACK是可能与SYN，FIN等同时使用的，比如SYN和ACK可能同时为1，它表示的就是建立连接之后的响应，如果只是单个的一个SYN，它表示的只是建立连接。

TCP的几次握手就是通过这样的ACK表现出来的。但SYN与FIN是不会同时为1的，因为前者表示的是建立连接，而后者表示的是断开连接。

> 参考：
>
> [Wireshark常用过滤使用方法](https://www.cnblogs.com/nmap/p/6291683.html)
