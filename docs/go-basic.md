[回到首页](../README.md)

# 1. Go基础

说明

[TOC]

## 1.1. 变量声明与初始化

### 1.1.1. 类型

基础类型：

- 布尔：bool
- 整型：int8 | byte | int16 | int | uint | intptr ...
- 浮点：float32 | float64
- 复数：complex64 | complex128
- 字符串：string
- 字符：rune
- 错误：error

符合类型：

- 指针：pointer
- 数组：array
- 切片：slice
- 字典：map
- 通道：chan
- 结构体：struct
- 接口：interface

### 1.1.2. 声明与初始化

声明方式：

```go
var val int
```

初始化方式：

```go
val := 100
```

大部分类型在声明时会被系统初始化为零值，整型零值是0，字符串零值是空字符串，布尔零值是false

指针类型不会被自动初始化，不能直接使用，比如：

```go
	var t1 map[int]int
	// t1 = make(map[int]int) // 正确初始化
	t1[2] = 2 // panic
	fmt.Println("t1", t1)


	var t5 *int
	// t5 = new(int) // 正确初始化
	*t5 = 1 // panic
	fmt.Println("t5", *t5)
```

### 1.1.3. var、new与make在初始化时的使用区别

var用于类型声明，对于基本类型会被初始化为零值，包括整型、字符串、array、struct等

new用于指定类型的内存创建，同时把内存置为零值，返回的是内存地址。`map, slice,chan`的零值是nil

make用于`map, slice,chan` 的内存创建，返回的对象是类型本身。创建内存不会初始化为零值，意味着对象一定不是nil


## 1.2. 字符串

重复：`strings.Repeat()`

分割：`strings.Split()`

连接：`strings.Join()`

> 参考：[Go内置常用包](https://www.cnblogs.com/52fhy/p/11295090.html)

## 1.3. 类型判断

### 1.3.1. switch

```go
for k, v := range user5 {
    switch v2 := v.(type) {
        case string:
        fmt.Println(k, "is string", v2)
        case int:
        fmt.Println(k, "is int", v2)
        case bool:
        fmt.Println(k, "is bool", v2)
        case []interface{}:
        fmt.Println(k, "is an array:")
        for i, iv := range v2 {
            fmt.Println(i, iv)
        }
        default:
        fmt.Println(k, "类型未知")
    }
}
```



### 1.3.2. reflect反射

## 1.4. 类型转换

### 1.4.1. 整型与字符串互转

```go
// string转成int
int, err := strconv.Atoi(string)

// string转成int64
int64, err := strconv.ParseInt(string, 10, 64)

// int转成string
string := strconv.Itoa(int)

// int64转成string
string := strconv.FormatInt(int64,10)
```



## 1.5. 正则

### 1.5.1. 正则匹配

```go
name := regexp.MustCompile("[\u4e00-\u9fa5~!@#$%^&*(){}|<>\\\\/+\\-【】:\"?'：；‘’“”，。、《》\\]\\[`]")
if name.MatchString(param["username"]) {
    return errors.New("添加失败, 名字中含有特殊字符或有中文")
}
```

### 1.5.2. 正则匹配子串

```go
re := regexp.MustCompile(`<!--{{TPL_LIST_ITEM_START}}-->([\s\S]*?)<!--{{TPL_LIST_ITEM_END}}-->`)
matches := re.FindSubmatch([]byte(tplContent))
tplListItem := ""
if len(matches) > 1 {
    tplListItem = string(matches[1])
} else {
    err = errors.New("模板错误")
    return
}
```



## 1.6. 时间

### 1.6.1. `time.Now()`返回的是什么？

返回的是当前时间的`time.Time`对象。

### 1.6.2. 获取当前时间的时间戳

```go
time.Now().Unix() // 1653194203
```

### 1.6.3. 时间格式化

```go
const TimeFormat = "2006-01-02 15:04:05"
time.Now().Format(TimeFormat)
```

### 1.6.4. 时间字符串生成时间对象，时间戳生成时间对象

```go
const TimeFormat = "2006-01-02 15:04:05"
time.Unix(1653194203, 0)
fmt.Println(time.Parse(TimeFormat, "2022-04-07 06:43:27"))
```



例：

```go
fmt.Println(time.Now())
// 时间偏移
fmt.Println(time.Now().Add(-10 * time.Minute).Format("2006-01-02 15:04:05"))

// 时间戳生成time
fmt.Println(time.Unix(1649313807, 0))
// 时间字符串生成time
fmt.Println(time.Parse("2006-01-02 15:04:05", "2022-04-07 06:43:27"))
```

输出结果，注意时区的区别

```bash
2022-04-07 14:47:58.162877786 +0800 CST m=+0.014919095
2022-04-07 14:37:58
2022-04-07 14:43:27 +0800 CST
2022-04-07 06:43:27 +0000 UTC <nil>
```



## 1.7. 文件

touch文件：

```go
os.OpenFile(filename, os.O_RDONLY|os.O_CREATE, 0666)
```



## 1.8. 协程

## 1.9. dlv调试

### 1.9.1. 设置字符串可显示长度



## 1.10. 数据库事务处理

```go
db, err := postgreHelper.Open()
if err != nil {
    return err
}
defer postgreHelper.Close(db)
tx := db.Begin()
defer func() {
    if p := recover(); p != nil {
        tx.Rollback()
        panic(p)
    } else if err != nil {
        tx.Rollback()
    } else {
        err = tx.Commit().Error
    }
}()

// tx.Exec()...
```

> 参考：[Golang transaction 事务使用的正确姿势](http://www.mspring.org/2019/03/18/Golang-transaction-事务使用的正确姿势/)

## 1.11. 闭包

```go
package main

import "fmt"

func main() {
    a := Fun()
    b:=a("hello ")
    c:=a("hello ")
    fmt.Println(b)//worldhello 
    fmt.Println(c)//worldhello hello 
}
func Fun() func(string) string {
    a := "world"
    return func(args string) string {
        a += args
        return  a
    }
}
```

## 1.12. 并发锁 sync.Mutex与sync.RWMutex

Mutex是单读写模型，一旦被锁，其他goruntine只能阻塞不能读写

RWMutext是单写多读模型，读锁占用时会阻止写，不会阻止读

## 1.13. 使用避坑

```go
package main

import "fmt"

var AppPath = "/opt/topsec/topihs"
func init() {
    AppPath, err := GetAppPath()
	if err != nil {
		panic(err)
	}
    fmt.Println("AppPath1", AppPath)
}

func GetAppPath() (string, error) {
	return ""/opt/topsec"", nil
}

func main() {
    fmt.Println("AppPath2", AppPath)
}
```

这里输出 /opt/topsec/topihs，因为init中的AppPath会当作一个局部变量。正确的写法是

```go
func init() {
    var err error
    AppPath, err = GetAppPath()
	if err != nil {
		panic(err)
	}
}
```

