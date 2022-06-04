[回到首页](../README.md)

# 1. 搭建PHP运行环境

说明

[TOC]

## 1.1. 原生方式

以alpine系统为例，其他系统类似：

```bash
# 安装软件
apk add nginx php7-fpm php7-mysqli mariadb mariadb-client
# 初始化mysql
/etc/init.d/mariadb setup
# 启动服务
service nginx start
service php-fpm7 start
service mariadb start
# 开机启动
rc-update add nginx
rc-update add php-fpm7
rc-update add mariadb
# 创建mysql用户
mysql -uroot -p << EOF
CREATE USER 'user'@'localhost' IDENTIFIED BY '123456';
GRANT ALL ON *.* TO 'user'@'localhost';
CREATE DATABASE my_db;
EOF
# 修改nignx配置以支持php
cat > /etc/nginx/conf.d/default.conf << EOF
server {
	listen 80 default_server;
	listen [::]:80 default_server;
	root /var/www/;

	# Everything is a 404
	location / {
	}

	location  ~ ^(.+\.php)(.*)$ {
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_index  index.php;
		fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
		include        fastcgi_params;
		fastcgi_param        PATH_INFO              $fastcgi_path_info;
		fastcgi_param        PATH_TRANSLATED        $document_root$fastcgi_path_info;
		fastcgi_split_path_info ^(.+\.php)(.*)$;
	}


	# You may need this to prevent return 404 recursion.
	location = /404.html {
		internal;
	}
}
EOF

# 创建测试文件
cat > test_mysql.php << EOF
<?php
$link = mysqli_connect("localhost", "user", "123456", "my_db");

if (!$link) {
	    echo "Error: Unable to connect to MySQL." . PHP_EOL;
	        echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
	        echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
		    exit;
}

echo "Success: A proper connection to MySQL was made! The my_db database is great." . PHP_EOL;
echo "Host information: " . mysqli_get_host_info($link) . PHP_EOL;

mysqli_close($link);
?>
EOF
cat > index.html << EOF
OK
EOF

# 测试服务是否正常
curl 127.0.0.1/index.html
curl 127.0.0.1/test_mysql.php
```



## 1.2. docker快速创建

```bash
# 下载镜像
docker pull php:7.2-fpm
docker pull nginx
docker pull mysql:5.7
docker pull redis:3.2

# 启动各个容器
docker run --name vh_mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7
docker run --name vh_redis -p 6379:6379 -d redis:3.2
docker run --name vh_php -p 9000:9000 -v /wns/host/web/html:/var/www/html -v /wns/host/php/config:/usr/local/etc/php --link vh_redis:vh_redis --link vh_redis:vh_redis --privileged=true -d php:7.2-fpm
# 注意-v 挂载一个空文件夹是会覆盖容器中的内容,所以配置文件要事先准备好
docker run --name vh_web -p 80:80 -v /wns/host/web/html:/usr/share/nginx/html -v /wns/host/web/config:/etc/nginx -v /wns/host/web/log:/var/log/nginx --link vh_php:vh_php -d nginx

# nginx配置文件
server {
	listen 80;
	server_name localhost;

	location / {
		root /usr/share/nginx/html/public;
		index index.htmll index.htm index.php;
	}

	error_page 500 502 503 504 /50x.html
	location = 50x.html {
		root /usr/share/nginx/html;
	}

	location ~ \.php$ {
		root /usr/share/nginx/html/public;
		fastcgi_pass	vh_php:9000;
		fastcgi_index	index.php;
		fastcgi_param	SCRIPT_FILENAME $document_root$fastcgi_scrit_name;
		include			fastcgi_params;
	}
}

# 安装php的mysql、redis扩展
docker exec vh_php docker-php-ext-install pdo pdo_mysql
docker exec vh_php pecl install redis
docker exec vh_php docker-php-ext-enable redis
docker restart vh_php
```

docker run参数解释：

- -i 表示允许我们对容器进行操作
- -t 表示在新容器内指定一个为终端
- -d 表示容器在后台执行
- /bin/bash 这将在容器内启动bash shell
- -p 为容器和宿主机创建端口映射
- --name 为容器指定一个名字
- -v 将容器内路径挂载到宿主机路径
- --privileged=true 给容器特权,在挂载目录后容器可以访问目录以下的文件或者目录
- --link可以用来链接2个容器，使得源容器（被链接的容器）和接收容器（主动去链接的容器）之间可以通过别名通信，解除了容器之间通信对容器IP的依赖

> 参考：[docker 从入门到自动化构建 PHP 环境 | Laravel China 社区 (learnku.com)](https://learnku.com/articles/19504)

## 1.3. docker compose一键部署

将上述方案使用docker compose完成部署，详细见[github地址](https://github.com/huberyhe/docker_php_env)。
