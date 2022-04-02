[回到首页](../README.md)

# Go基础

说明

[TOC]

## 1、字符串

重复：strings.Repeat
分割：strings.Split

> 参考：[Go内置常用包](https://www.cnblogs.com/52fhy/p/11295090.html)

## 2、类型判断

### 2.1、switch

switch i.(type)

### 2.2、reflect反射

## 3、正则

正则匹配：

```go
name := regexp.MustCompile("[\u4e00-\u9fa5~!@#$%^&*(){}|<>\\\\/+\\-【】:\"?'：；‘’“”，。、《》\\]\\[`]")
if name.MatchString(param["username"]) {
    return errors.New("添加失败, 名字中含有特殊字符或有中文")
}
```



正则匹配子串：

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



## 4、时间

t := time.Now().Add(-10 * time.Minute).Format("2006-01-02 15:04:05")

## 5、协程

## 6、dlv调试

## 7、数据库事务处理

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

## 8、闭包

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

