[回到首页](../README.md)

# 1. make与Makefile

说明

[TOC]

## 1.1. 基本格式

```
<target> : <prerequisites> 
[tab]  <commands>
```

- 目标：是一个文件，或一个操作名（伪目标）
- 前置条件：一组文件名，用空格分隔，可以为空。只要有一个前置文件不存在，或者有过更新（前置文件的last-modification时间戳比目标的时间戳新），"目标"就需要重新构建。
- 命令：每行一条shell命令，每行之间默认不共享shell

## 1.2. 语法

### 1.2.1. 注释

#号开头

### 1.2.2. 回声

默认每行都会打印，包括注释。在行前加@可关闭回声。

### 1.2.3. 通配符

使用与bash相同的通配符，如*、？、[...]

### 1.2.4. 模式匹配

Make命令允许对文件名，进行类似正则运算的匹配，主要用到的匹配符是%。

### 1.2.5. 变量与赋值符

```makefile
txt = Hello World
test:
	# 变量
    @echo $(txt)
    # shell变量
	@echo $$HOME
```

### 1.3.6. 内置变量

### 1.3.7. 自动变量

### 1.3.8. 判断与循环

```makefile
ifeq ($(CC),gcc)
  libs=$(libs_for_gcc)
else
  libs=$(normal_libs)
endif
LIST = one two three
all:
    for i in $(LIST); do \
        echo $$i; \
    done
```

### 1.3.9. 函数



> 参考：
>
> 1. [Make 命令教程](https://www.ruanyifeng.com/blog/2015/02/make.html)
> 2. [GNU make](https://www.gnu.org/software/make/manual/make.html)
> 3. [Makefile](https://gist.github.com/isaacs/62a2d1825d04437c6f08)

