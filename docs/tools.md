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


参考：[仅使用tcpdump捕获ssl握手](https://www.thinbug.com/q/39624745)
