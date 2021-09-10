[回到首页](../README.md)

# 缓存

缓存机制的一些概念和问题

[TOC]

## 1、缓存分类

### 1.1、PHP缓存

1、opcache，将编译后的字节码缓存下来，下次就不需要编译

2、yac内存缓存

3、file文件缓存，框架中一般自己会封装

> 参考：
>
> 1、[PHP Opcache 注意事项以及调优 | PHP 技术论坛 (learnku.com)](https://learnku.com/php/t/34638)

### 1.2、Nginx缓存

### 1、浏览器缓存配置

```http
// 返回头部
cache-control: maxage=2592000
content-encoding: gzip
content-security-policy: script-src https: 'unsafe-inline' 'unsafe-eval' *.baidu.com
content-type: application/x-javascript;charset=utf-8
date: Thu, 19 Aug 2021 11:32:53 GMT
etag: W/1e46de85b877e9fc4f812d5096de8a20
expires: Wed, 08 Sep 2021 03:12:41 GMT
```

```http
// 请求头部
cache-control: max-age=0
if-modified-since: Wed, 08 Sep 2021 03:12:41 GMT
if-none-match: W/1e46de85b877e9fc4f812d5096de8a20
```

nginx通过返回的`Expires`，`Cache-control`等头部字段告诉浏览器是否要缓存及过期的时间；并通过浏览器请求时的`Etag`头部字段判断是返回304，还是重新请求字段

 ![17106515](../imgs/1165731-20190623163949263-298746206.png)

配置语法：

1、expires：添加Cache-Control、Expires头

```nginx
Syntax:	expires [modified] time;
		expires epoch | max | off;
Default:	expires off;
Context:	http, server, location, if in location
```

> 参考：
>
> 1、[nginx 缓存设置 - walkfade - 博客园 (cnblogs.com)](https://www.cnblogs.com/sreops/p/11073277.html)

### 2、proxy_cache缓存：缓存后端的内容，可以是静态或动态资源

配置语法：

1、proxy_cache_path：缓存的路径，空间，占用大小等

```nginx
Syntax:	proxy_cache_path path [levels=levels] [use_temp_path=on|off] keys_zone=name:size [inactive=time] [max_size=size] [min_free=size] [manager_files=number] [manager_sleep=time] [manager_threshold=time] [loader_files=number] [loader_sleep=time] [loader_threshold=time] [purger=on|off] [purger_files=number] [purger_sleep=time] [purger_threshold=time];
Default:	—
Context:	http
```

2、proxy_cache：缓存的开关，使用的空间

```nginx
Syntax:	proxy_cache zone | off;
Default:	proxy_cache off;
Context:	http, server, location
```

3、proxy_cache_methods：哪些HTTP动作才缓存

```nginx
Syntax:	proxy_cache_methods GET | HEAD | POST ...;
Default:	proxy_cache_methods GET HEAD;
Context:	http, server, location
```

4、proxy_cache_valid：缓存有效期

```nginx
Syntax:	proxy_cache_valid [code ...] time;
Default:	—
Context:	http, server, location
```

5、proxy_cache_key：缓存使用的key，用于索引

```nginx
Syntax:	proxy_cache_key string;
Default:	proxy_cache_key $scheme$proxy_host$request_uri;
Context:	http, server, location
```

实例：

```nginx
http {
    # 省略一些配置
    
    upstream imooc {
        server 116.62.103.228:8001;
        server 116.62.103.228:8002;
        server 116.62.103.228:8003;
    }

    proxy_cache_path /opt/app/cache levels=1:2 keys_zone=imooc_cache:10m max_size=10g inactive=60m use_temp_path=off;

	server {
        listen       80;
        server_name  web01.fadewalk.com;

        access_log  /var/log/nginx/test_proxy.access.log  main;

        location / {
            proxy_cache off;
            proxy_pass http://imooc;

            proxy_cache_valid 200 304 12h;
            proxy_cache_valid any 10m;
            proxy_cache_key $host$uri$is_args$args;
            add_header  Nginx-Cache "$upstream_cache_status";

            proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
            include proxy_params;
	   }
    }
}
```

### 3、fastcgi_cache缓存：缓存php返回的内容，减少对php的请求

用的少，不详细写了

### 1.3、浏览器缓存

见1.2.1

## 2、缓存常见问题

### 2.1、缓存穿透

概念：数据库不存在的数据不会被缓存，访问这个数据则每次都会查数据库，给数据库带来压力

解决方案：

1、提高缓存命中率

2、校验前置，过滤非法请求

3、空值防范：查询数据库发现数据不存在时也缓存，设置较短的过期时间（比如60s）

4、Bloom Filter：解决空值防范缓存不更新的问题，并且空间和时间效率高很多

### 2.2、缓存雪崩

概念：当过期时间设置为固定时长时，集中生成的缓存会集中过期，过期后会对后端产生压力

解决方案：尽可能分散缓存过期时间，比如同类商品缓存不同周期，同类商品也加上一个随机因子，热门商品缓存时间长一些，冷门商品缓存时间短一些。

### 2.3、缓存击穿

概念：缓存击穿，是指一个key非常热点，在不停的扛着大并发，大并发集中对这一个点进行访问，当这个key在失效的瞬间，持续的大并发就穿破缓存，直接请求数据库，就像在一个屏障上凿开了一个洞。

解决方案：

1、让爆款商品永不过期

2、数据预载：提前将热数据加载至缓存

3、低速存储器防护：

3.1、过载防护：对于超出处理能力的请求进行拦截

3.2、熔断机制：在数据请求接入层基于拦截响应判断是否需要在上层进行拦截

3.3、消息队列：流量削峰，避免对数据库的高并发查询

> 参考：
>
> 1、[缓存击穿解决方案浅析 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/113432713)
>
> 2、[实例解读什么是Redis缓存穿透、缓存雪崩和缓存击穿 (baidu.com)](https://baijiahao.baidu.com/s?id=1619572269435584821&wfr=spider&for=pc)
>
> 3、[Redis缓存穿透问题及解决方案-布隆过滤器](https://segmentfault.com/a/1190000017305460)

