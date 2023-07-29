[回到首页](../README.md)

# 1. 软件安全

说明

[TOC]

## 1.1. 常见攻击和防范

- 跨站脚本攻击XSS
- 跨站请求伪造CSRF
- 命令注入
- 代码注入
- SQL注入
- 目录穿越

## 1.2. 扫描工具

- appscan
- Nessus
- sslscan
- Acunetix Security Audit

## 1.3. 许可证协议

- MIT许可证

- Apache许可证

- GNU通用公共许可证（GPL）

  GPL 是一种相对较严格的许可证，要求任何以 GPL 许可证发布的软件及其修改版也必须以 GPL 许可证发布，并且要求在修改的软件中包含原始许可证和版权声明。

  这个要求使用该项目的项目必须开源。

- BSD许可证

## 1.4. 网络安全漏洞信息发布平台

[http://www.exploit-db.com](http://www.exploit-db.com/) [比较及时]
[http://www.securityfocus.com ](http://www.securityfocus.com/)(国际权威漏洞库)
http://www.cnvd.org.cn/ (国家信息安全漏洞共享平台)
[http://www.nsfocus.net](http://www.nsfocus.net/) (国内安全厂商——绿盟科技)
[http://en.securitylab.ru ](http://en.securitylab.ru/)(俄罗斯知名安全实验室)
http://www.securityfocus.com/archive (安全焦点)
[http://cve.mitre.org](http://cve.mitre.org/)

## 1.5. 安全编码规范

1. 语法层面正确使用，不应该因代码问题导致服务不可用。比如go中未初始化的map，并发安全，内存、文件句柄泄漏，数据类型超出范围。
2. 用户输入参数的安全检查。包括表单校验、sql参数绑定、文件名校验等。
3. 最小权限原则。用户不应该访问没有权限的文件和数据，执行不应该执行的脚本。
4. 数据通信安全。对外开放的系统通信应该有TLS加密，应启用证书验证。
5. 敏感数据。不应出现在目标数据库以外的位置，比如日志中；不应明文返回到客户端。
6. HTTP安全。头部设置CORS同源策略；CSRF校验Referer或添加csrf_token；头部设置前端资源源限制；



> 参考：
>
> 1、[腾讯Go安全指南](https://github.com/Tencent/secguide/blob/main/Go安全指南.md)
>
> 2、[Content Security Policy 入门教程](http://www.ruanyifeng.com/blog/2016/09/csp.html)
> 3、[Content-Security-Policy - HTTP | MDN (mozilla.org)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy)
>
> 4、[个人总结的漏洞管理流程分享 - FreeBuf网络安全行业门户](https://www.freebuf.com/articles/es/198324.html)
