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

复合类型：

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

查找：`strings.Index()`和`strings.LastIndex()`

> 参考：[Go内置常用包](https://www.cnblogs.com/52fhy/p/11295090.html)

## 1.3. 整型浮点型

### 1.3.1. 四舍五入

go没有原生四舍五入的支持，只有向上取整`math.Floor`和向下取整`math.Ceil`。

```go
// Round 四舍五入，ROUND_HALF_UP 模式实现
// 返回将 val 根据指定精度 precision（十进制小数点后数字的数目）进行四舍五入的结果。precision 也可以是负数或零。
func Round(val float64, precision int) float64 {
    p := math.Pow10(precision)
    return math.Floor(val*p+0.5) / p
}
```

## 1.4. 类型判断

### 1.4.1. switch

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


### 1.4.2. reflect反射

## 1.5. 类型转换

### 1.5.1. 整型与字符串互转

```go
// string转成int
int, err := strconv.Atoi(string)

// string转成int64
int64, err := strconv.ParseInt(string, 10, 64)

// int转成string
string := strconv.Itoa(int)

// int64转成string
string := strconv.FormatInt(int64, 10)
```

注意，go不支持强制转换，使用string()会得到意想不到的结果

```go
s := string(97) // s == "a"
```

## 1.6. 常用常量

### 1.6.1. 整型最值

```go
math.MaxInt32
math.MinInt32
```



## 1.7. 正则

### 1.7.1. 正则匹配

```go
name := regexp.MustCompile("[\u4e00-\u9fa5~!@#$%^&*(){}|<>\\\\/+\\-【】:\"?'：；‘’“”，。、《》\\]\\[`]")
if name.MatchString(param["username"]) {
    return errors.New("添加失败, 名字中含有特殊字符或有中文")
}
```

### 1.7.2. 正则查找子串

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

### 1.7.3. 替换

```go
re, _ := regexp.Compile("a");
rep := re.ReplaceAllStringFunc("abcd", strings.ToUpper);
fmt.Println(rep) // Abcd
```



## 1.8. 时间

### 1.8.1. `time.Now()`返回的是什么？

返回的是当前时间的`time.Time`对象。

### 1.8.2. 获取当前时间的时间戳

```go
time.Now().Unix() // 1653194203
```

### 1.8.3. 时间格式化

```go
const TimeFormat = "2006-01-02 15:04:05"
time.Now().Format(TimeFormat)
```

### 1.8.4. 时间字符串生成时间对象，时间戳生成时间对象

```go
const TimeFormat = "2006-01-02 15:04:05"
time.Unix(1653194203, 0)
fmt.Println(time.Parse(TimeFormat, "2022-04-07 06:43:27"))

ts := time.Now().AddDate(0, 0, -1)
time.Date(ts.Year(), ts.Month(), ts.Day(), 0, 0, 0, 0, ts.Location()).Unix() // 0点
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

var cstSh, _ = time.LoadLocation("Asia/Shanghai")
fmt.Println(time.ParseInLocation("2006-01-02 15:04:05", "2022-04-07 06:43:27", cstSh))

fmt.Println(time.Now().In(cstSh))
```

输出结果，注意时区的区别

```bash
2022-04-07 14:47:58.162877786 +0800 CST m=+0.014919095
2022-04-07 14:37:58
2022-04-07 14:43:27 +0800 CST
2022-04-07 06:43:27 +0000 UTC <nil>

2022-04-07 06:43:27 +0800 CST <nil>
2022-12-23 17:09:29.9312074 +0800 CST
```


## 1.9. 文件

### 1.9.1. touch文件

```go
os.OpenFile(filename, os.O_RDONLY|os.O_CREATE, 0666)
```

### 1.9.2. 读写文件

```go

// 写入一行
func writeByLine(fn string, b string) error  {
	f, err := os.OpenFile(fn, os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0644)
	if err != nil {
		return err
	}
	defer f.Close()

	if _, err := f.Write([]byte(b + "\n")); err != nil {
		return err
	}
	return nil
}

// 按行读
func readByLine(fn string) (bs []string, err error)  {
	f, err := os.OpenFile(fn, os.O_RDONLY|os.O_CREATE, 0644)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	buf := bufio.NewReader(f)
	for {
		line, err := buf.ReadString('\n')
		if err != nil {
			if err == io.EOF { //读取结束，会报EOF
				break
			}
			return nil, err
		}

		line = strings.TrimSpace(line)
		bs = append(bs, line)
	}
	return bs, nil
}

// 读取整个文件
func ioutil.ReadFile(filename string) ([]byte, error)
```

### 1.9.3. 实例：

#### 1.9.3.1. 列出目录文件

```go
func main() {
    dir := os.Args[1]
    listAll(dir,0)
}

func listAll(path string, curHier int){
    fileInfos, err := ioutil.ReadDir(path)
    if err != nil{fmt.Println(err); return}

    for _, info := range fileInfos{
        if info.IsDir(){
            for tmpHier := curHier; tmpHier > 0; tmpHier--{
                fmt.Printf("|\t")
            }
            fmt.Println(info.Name(),"\\")
            listAll(path + "/" + info.Name(),curHier + 1)
        }else{
            for tmpHier := curHier; tmpHier > 0; tmpHier--{
                fmt.Printf("|\t")
            }
            fmt.Println(info.Name())
        }
    }
}
```

#### 1.9.3.2. 拷贝文件和文件夹

```go
func CopyDir(src, dst string) error {
	err := os.MkdirAll(dst, 0777)
	if err != nil {
		return err
	}
	fis, err := ioutil.ReadDir(src)
	if err != nil {
		return err
	}
	for _, fi := range fis {
		err = CopyFile(filepath.Join(dst, fi.Name()), filepath.Join(src, fi.Name()))
		if err != nil {
			return err
		}
	}
	return nil
}

func CopyFile(src, dst string) (err error) {
	var s, d *os.File
	s, err = os.Open(src)
	if err != nil {
		return err
	}
	defer s.Close()
	d, err = os.Create(dst)
	if err != nil {
		return err
	}
	defer func() {
		e := d.Close()
		if err == nil {
			err = e
		}
	}()
	_, err = io.Copy(d, s)
	if err != nil {
		return err
	}
	return nil
}
```

### 1.9.4. 文件名与后缀

```go
fullFilename := "D:/software/Typora/bin/typora.exe"
fmt.Println("fullFilename =", fullFilename)
//获取文件名带后缀
filenameWithSuffix := path.Base(fullFilename)
fmt.Println("filenameWithSuffix =", filenameWithSuffix) // typora.exe
//获取文件后缀
fileSuffix := path.Ext(filenameWithSuffix)
fmt.Println("fileSuffix =", fileSuffix) // .exe

//获取文件名
filenameOnly := strings.TrimSuffix(filenameWithSuffix, fileSuffix)
fmt.Println("filenameOnly =", filenameOnly) // typora
```

### 1.9.5. 删除文件和文件夹

```go
err := os.Remove(file) // 文件夹必须为空
err := os.RemoveAll(path) // 可以删除不为空的文件夹
```

### 1.9.6. 路径存在判断

```go
func IsExists(path string) bool {
	_, err := os.Stat(path)
	if err == nil {
		return true
	}
	if os.IsNotExist(err) {
		return false
	}

	return false
}
```

### 1.9.7. 创建目录

```go
os.Mkdir("abc", os.ModePerm) //创建目录  
os.MkdirAll("dir1/dir2/dir3", os.ModePerm) //创建多级目录
```

## 1.10. 并发，协程与管道

### 1.10.1. 管道

只有可写的管道才能close，close应该在发送方执行

```go
// 初始化
var a chan int
a = make(chan int, 2)

// 写数据
a <- 1
// 读数据
b := <- a
```

管道未初始化或已关闭时的读写情况
- 写未初始化管道：阻塞
- 读未初始化管道：阻塞
- 写关闭的管道：panic
- 读关闭的管道：返回未读完的数据或（0值，ok=false）


### 1.10.2. 协程

#### 1.10.2.1. 协程池示例，用于计算数字各位的和

输入12345，输出15(=1+2+3+4+5)

```go
package main

import (  
    "fmt"
    "math/rand"
    "sync"
    "time"
)

type Job struct {  
    id       int
    randomno int
}
type Result struct {  
    job         Job
    sumofdigits int
}

var jobs = make(chan Job, 10)  
var results = make(chan Result, 10)

// 实际计算方法
func digits(number int) int {  
    sum := 0
    no := number
    for no != 0 {
        digit := no % 10
        sum += digit
        no /= 10
    }
    time.Sleep(2 * time.Second)
    return sum
}

// 一个worker
func worker(wg *sync.WaitGroup) {  
    for job := range jobs {
        output := Result{job, digits(job.randomno)}
        results <- output
    }
    wg.Done()
}

// 创建worker池
func createWorkerPool(noOfWorkers int) {  
    var wg sync.WaitGroup
    for i := 0; i < noOfWorkers; i++ {
        wg.Add(1)
        go worker(&wg)
    }
    wg.Wait()
    close(results)
}

// 分配任务
func allocate(noOfJobs int) {  
    for i := 0; i < noOfJobs; i++ {
        randomno := rand.Intn(999)
        job := Job{i, randomno}
        jobs <- job
    }
    close(jobs)
}

// 获取结果
func result(done chan bool) {  
    for result := range results {
        fmt.Printf("Job id %d, input random no %d , sum of digits %d\n", result.job.id, result.job.randomno, result.sumofdigits)
    }
    done <- true
}

func main() {  
    startTime := time.Now()
    
    noOfJobs := 100
    go allocate(noOfJobs)
    
    done := make(chan bool)
    go result(done)
    
    noOfWorkers := 10
    createWorkerPool(noOfWorkers)
    
    <-done
    endTime := time.Now()
    diff := endTime.Sub(startTime)
    fmt.Println("total time taken ", diff.Seconds(), "seconds")
}
```

#### 1.10.2.2. 控制协程数量

```go
package main

import (
	"fmt"
	"sync"
)

var wg = sync.WaitGroup{}

func main() {
    userCount := 10
    ch := make(chan bool, 2) // 10个协程，并发为2
    for i := 0; i < userCount; i++ {
        wg.Add(1)
        go Read(ch, i)
    }

    wg.Wait()
}

func Read(ch chan bool, i int) {
    defer wg.Done()

    ch <- true
    fmt.Printf("go func: %d, time: %d\n", i, time.Now().Unix())
    time.Sleep(time.Second)
    <-ch
}
```

进化，控制协程数量、并发数量、执行次数

```go
package main

import (
	"fmt"
	"sync"
	"time"
)

var wg sync.WaitGroup

func worker(id, d int) {
	fmt.Printf("go id: %d, func: %d, time: %d\n", id, d, time.Now().Unix())
	time.Sleep(time.Second * time.Duration(d))
}

func main() {
	userCount := 10         // 协程总数量
	ch := make(chan int, 5) // 并发协程数量
	for i := 0; i < userCount; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			for d := range ch {
				worker(id, d)
			}
		}(i)
	}

	for i := 0; i < 10; i++ { // 协程执行次数，总10*2=20次
		ch <- 1
		ch <- 2
		//time.Sleep(time.Second)
	}

	close(ch)
	wg.Wait()
}

```



#### 1.10.2.3. 面试题：交替输出

```go
package main

import (
	"fmt"
	"sync"
)

var wg = sync.WaitGroup{}
var ch = make(chan bool)

func echo(ch chan bool, s string) {
	for {
		<-ch
		fmt.Println(s)
		ch <- true
	}
	wg.Done()
}

func main() {
	go echo(ch, "11111")
	wg.Add(1)
	go echo(ch, "22222")
	wg.Add(1)

	ch <- true
	wg.Wait()
}
```



## 1.11. dlv调试

### 1.11.1. 调试时带上命令行参数，`--`后带上参数

```bash
dlv debug main.go --output ./bin/license -- -c ./etc/license.json
dlv exec ./bin/license -- -c ./etc/license.json
```

### 1.11.2. 设置字符串可显示长度

```
config max-string-len 99999
```

### 1.11.3. 常用命令

```
// 打断点
b main.main
b main.go:18
// 查看断点
breakpoints/bp
// 清除断点
clear 1
// 清除所有断点
clearall
// 启用禁用断点
toggle 1
// 下一步
next/n
// 跳入
step/s
// 跳出
stepout
// 继续
continue/c
// 在断点执行命令
on 1 p i
// 有条件中断断点
condition 1 i==10
// 查看函数参数
args
// 查看所有局部变量
locals
// 打印源代码
list

// 显示协程
goroutines
// 切换协程
goroutine 1
// 显示线程
threads
// 跟踪，运行到此处时打印一条信息并继续
trace
```


## 1.12. 数据库事务处理

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

## 1.13. 匿名函数与闭包

匿名函数中使用外部变量，注意直接使用和通过参数使用的区别

```go
var wg sync.WaitGroup
for _, c := range []string{"a", "b", "c"} {
    go func() {
        time.Sleep(1 * time.Second)
        fmt.Println("func 1: ", c) // 运行时的值
        wg.Done()
    }()
    wg.Add(1)

    go func(c string) {
        time.Sleep(2 * time.Second)
        fmt.Println("func 2: ", c) // 调用时的值
        wg.Done()
    }(c)
    wg.Add(1)

    func(c string) {
        go func() {
            time.Sleep(3 * time.Second)
            fmt.Println("func 3: ", c)
            wg.Done()
        }()
    }(c)
    wg.Add(1)

}
wg.Wait()
```

以上代码输出：

```bash
func 1:  c
func 1:  c
func 1:  c
func 2:  a
func 2:  c
func 2:  b
func 3:  c
func 3:  b
func 3:  a
```

闭包有局部变量，并返回一个函数变量，特点是这个函数可以多次使用局部变量，变量的值在闭包生命周期内可以保持。

```go
package main

import "fmt"

func main() {
	a := Fun()
	b := a("hello ")
	c := a("hello ")
	fmt.Println(b) //worldhello
	fmt.Println(c) //worldhello hello

	a = Fun()
	b = a("hi ")
	c = a("hi")
	fmt.Println(b) //worldhi 
	fmt.Println(c) //worldhello hello

}

func Fun() func(string) string {
	a := "world"
	return func(args string) string {
		a += args
		return a
	}
}

```



## 1.14. 并发锁 sync.Mutex与sync.RWMutex

Mutex是单读写模型，一旦被锁，其他goruntine只能阻塞不能读写

RWMutext是单写多读模型，读锁（RLock）占用时会阻止写，不会阻止读；写锁（Lock）占用时会阻止读和写

## 1.15. 使用避坑

### 1.15.1. 修改全局变量的问题

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
var AppPath = "/opt/topsec/topihs"
func init() {
    var err error
    AppPath, err = GetAppPath()
	if err != nil {
		panic(err)
	}
}
```

再如：
```go
package main

import "fmt"

var b = 1
var d = 1

func init() {
	b, c := 2, 3
	d, c = 4, 5
	fmt.Println(b, c)

	fmt.Printf("b value: %d, point: %p\n", b, &b)
	fmt.Printf("d value: %d, point: %p\n", d, &d)
}

func main() {
	fmt.Printf("b value: %d, point: %p\n", b, &b)
	fmt.Printf("d value: %d, point: %p\n", d, &d)

	b, e := 6, 7
	fmt.Println(b, e)
	fmt.Printf("b value: %d, point: %p\n", b, &b)
}
```
输出：
```bash
2 5
b value: 2, point: 0xc00009c000
d value: 4, point: 0x5131d8
b value: 1, point: 0x5131d0
d value: 4, point: 0x5131d8
6 7
b value: 6, point: 0xc00009c020
```

## 1.16. map并发问题

并发写一个map会出现问题，运行时报错：`fatal error: concurrent map read and map write`

有两个解决方法：

1、sync.RWMutex

```go
type Pool struct {
	sync.RWMutex
	m map[string]int
}

func NewPool() Pool {
	return Pool{
		m: make(map[string]int),
	}
}

func (p Pool) Set(tag string, item int) {
	p.Lock()
	defer p.Unlock()
	p.m[tag] = item
}

func (p Pool) Get(tag string) int {
	p.RLock()
	defer p.RUnlock()
	return p.m[tag]
}

func (p Pool) Range(f func(string, interface{}) bool) {
	p.RLock()
	defer p.RUnlock()
	for k, v := range p.m {
		if !f(k, v) {
			break
		}
	}
}
```

2、sync.Map

```go
var scene sync.Map

// 将键值对保存到sync.Map
scene.Store("greece", 97)
scene.Store("london", 100)
scene.Store("egypt", 200)

// 从sync.Map中根据键取值
fmt.Println(scene.Load("london"))

// 根据键删除对应的键值对
scene.Delete("london")

// 遍历所有sync.Map中的键值对
scene.Range(func(k, v interface{}) bool {
    fmt.Println("iterate:", k, v)
    return true
})
```

## 1.17. logrus使用

logrus是十分常用的第三方日志库，项目地址：[sirupsen/logrus: Structured, pluggable logging for Go](https://github.com/sirupsen/logrus)。其他常用日志库还有[Zerolog](https://github.com/rs/zerolog)、 [Zap](https://github.com/uber-go/zap)和[Apex](https://github.com/apex/log).

项目中任何输出应统一使用日志库，不应该使用print打印，包括第三方库如gorm.

![image-20220526100147494](../imgs/image-20220526100147494.png)

### 1.17.1. 配置formater，指定日志输入格式

```go
type TopLog struct {
	*logrus.Logger
}

func NewLog(logType string, logPath string, logLevel string) (*TopLog, error) {
	logrusLevel, err := logrus.ParseLevel(logLevel)
	if err != nil {
		return nil, err
	}

	log = logrus.New()
	log.SetFormatter(&myFormatter{
		logrus.TextFormatter{
			DisableColors:   true,
			TimestampFormat: "2006-01-02 15:04:05",
			FullTimestamp:   true,
			DisableQuote:    true,
		},
	})
	log.SetReportCaller(true)
	log.SetOutput(os.Stdout)
	log.SetLevel(logrusLevel)

	return &TopLog{
		log,
	}, nil
}

func Logger() *logrus.Entry {
	entry := log.WithFields(logrus.Fields{})
	return entry
}

type myFormatter struct {
	logrus.TextFormatter
}

func (f *myFormatter) Format(entry *logrus.Entry) ([]byte, error) {
	// 给日志等级点颜色看看
	var levelColor int
	switch entry.Level {
	case logrus.DebugLevel, logrus.TraceLevel:
		levelColor = 31 // gray
	case logrus.WarnLevel:
		levelColor = 33 // yellow
	case logrus.ErrorLevel, logrus.FatalLevel, logrus.PanicLevel:
		levelColor = 31 // red
	default:
		levelColor = 36 // blue
	}

	var b *bytes.Buffer
	if entry.Buffer != nil {
		b = entry.Buffer
	} else {
		b = &bytes.Buffer{}
	}

	// 第一行 时间和消息
	b.WriteString(fmt.Sprintf("[%s] \x1b[%dm%s\x1b[0m %s", entry.Time.Format(f.TimestampFormat), levelColor, strings.ToUpper(entry.Level.String()), entry.Message))

	// 第二行 数据体，如有
	var dataStr []string
	for key, value := range entry.Data {
		dataStr = append(dataStr, fmt.Sprint(key, "=", value))
	}
	if len(dataStr) > 0 {
		b.WriteString("\n\t" + strings.Join(dataStr, ","))
	}

	// 第三行和第四行 调用方法和文件，如有
	var funcVal, fileVal string
	if entry.HasCaller() {
		if f.CallerPrettyfier != nil {
			funcVal, fileVal = f.CallerPrettyfier(entry.Caller)
		} else {
			funcVal = entry.Caller.Function
			fileVal = fmt.Sprintf("%s:%d", entry.Caller.File, entry.Caller.Line)
		}
	}
	if funcVal != "" {
		b.WriteString(fmt.Sprintf("\n\t%s", funcVal))
	}
	if fileVal != "" {
		b.WriteString(fmt.Sprintf("\n\t%s", fileVal))
	}

	b.WriteByte('\n')
	return b.Bytes(), nil
}
```

### 1.17.2. 配置gorm使用logrus

```go
type Database struct {
	*gorm.DB
	Error error
}

type Host struct {
	Database  string       `json:"database"`
	Password  string       `json:"password"`
	Host      string       `json:"host"`
	User      string       `json:"user"`
	Port      string       `json:"port"`
	DebugMode bool         `json:"-,optional"`
	Logger    *gorm.Logger `json:"-,optional"`
}

var (
	db   *Database
	once sync.Once
)

func DB() *gorm.DB {
	return db.DB
}

func Open(host Host) (*Database, error) {
	once.Do(
		func() {
			db = new(Database)
			db.connect(host)
		})
	return db, db.Error
}

// 只可关闭一次
func (db *Database) Close() {
	if db.DB != nil {
		_ = db.DB.Close()
		db.DB = nil
	}

	return
}

// 连接数据库
func (db *Database) connect(host Host) {
	var err error

	dbDSN := fmt.Sprintf(`host=%s user=%s password=%s database=%s port=%s sslmode=disable`,
		host.Host, host.User, host.Password, host.Database, host.Port)
	db.DB, err = gorm.Open("postgres", dbDSN)
	if err != nil {
		db.Error = err
		return
	}

	db.DB.LogMode(host.DebugMode)
	if host.Logger != nil {
		db.DB.SetLogger(*host.Logger)
	} else {
		db.DB.SetLogger(&GormLogger{})
	}

	db.DB.DB().SetMaxIdleConns(5)
	db.DB.DB().SetMaxOpenConns(20)
	db.SingularTable(true)

	return
}

type GormLogger struct{}

func (*GormLogger) Print(v ...interface{}) {
	log := runlog.Logger()
	switch v[0] {
	case "sql":
		log.WithFields(
			logrus.Fields{
				"module":        "gorm",
				"type":          "sql",
				"rows_returned": v[5],
				"src":           v[1],
				"values":        v[4],
				"duration":      v[2],
			},
		).Info(v[3])
	case "log":
		log.WithFields(logrus.Fields{"module": "gorm", "type": "log"}).Print(v[2])
	}
}
```

## 1.18. 性能测试pprof

## 1.19. 性能优化

### 1.19.1. 读取上传的xml文件并解析时，造成大量内存占用且长时间不能释放

优化前，直接把上传的文件读到内存并解析

```go
xmlFile, e := os.Open(f)
if e != nil {
    return e
}

defer xmlFile.Close()

b, _ := ioutil.ReadAll(xmlFile)

var xmlHead XmlHeadStruct

reader := bytes.NewReader(b)
decoder := xml.NewDecoder(reader)
decoder.CharsetReader = charset.NewReader

if e = decoder.Decode(&xmlHead); e != nil {
    return e
}
```

使用io.buffer

```go
f, _ := os.Open(fname)
defer f.Close()

var head XmlHeadStruct
decoder := xml.NewDecoder(bufio.NewReader(f))
_ = decoder.Decode(&head)

```

> 参考：
>
> 1、[XML parsing and memory usage : golang (reddit.com)](https://www.reddit.com/r/golang/comments/7a4dxw/xml_parsing_and_memory_usage/)
>
> 2、[go - How to read multiple times from same io.Reader - Stack Overflow](https://stackoverflow.com/questions/39791021/how-to-read-multiple-times-from-same-io-reader)

### 1.19.2. 内存泄露问题

> 参考：
> 
> 1、[Go程序内存泄露问题快速定位](https://www.hitzhangjie.pro/blog/2021-04-14-go%E7%A8%8B%E5%BA%8F%E5%86%85%E5%AD%98%E6%B3%84%E9%9C%B2%E9%97%AE%E9%A2%98%E5%BF%AB%E9%80%9F%E5%AE%9A%E4%BD%8D/)
> 
> 2、[内存泄漏的在线排查](https://panzhongxian.cn/cn/2020/12/memory-leak-problem-1/)

## 1.20. 多协程并发的优秀实现

几个原则：

- 保持自己忙碌或做自己的工作：如果当前方法启动了一个协程并立即等待，则应该让当前方法去做协程里的事情
- 将并发性留给调用者
- 永远不要启动一个停止不了的goroutine

```go
func serve(addr string, handler http.Handler, stop <-chan struct{}) error {
	s := http.Server{
		Addr:    addr,
		Handler: handler,
	}

	go func() {
		<-stop // wait for stop signal
		s.Shutdown(context.Background())
	}()

	return s.ListenAndServe()
}

func serveApp(stop <-chan struct{}) error {
	mux := http.NewServeMux()
	mux.HandleFunc("/", func(resp http.ResponseWriter, req *http.Request) {
		fmt.Fprintln(resp, "Hello, QCon!")
	})
	return serve("0.0.0.0:8080", mux, stop)
}

func serveDebug(stop <-chan struct{}) error {
	return serve("127.0.0.1:8001", http.DefaultServeMux, stop)
}

func main() {
	done := make(chan error, 2)
	stop := make(chan struct{})
	go func() {
		done <- serveDebug(stop)
	}()
	go func() {
		done <- serveApp(stop)
	}()

	var stopped bool
	for i := 0; i < cap(done); i++ {
		if err := <-done; err != nil {
			fmt.Println("error: %v", err)
		}
		if !stopped {
			stopped = true
			close(stop)
		}
	}
}
```

该实现中，任何一个服务遇到错误时另外一个服务都能干净地退出，由系统的进程管理器来重启

## 1.21. 错误处理

### 1.21.1. 错误处理注意三点：

- 错误只处理一次，避免出现重复的日志
- 错误应该包含相关信息，从错误文字上就能大概判断错误位置
- 使用`github.com/pkg/errors`保留原始错误信息

```go
package main

import (
	"log"
	"os"

	"github.com/pkg/errors"
)

func testError() error {
	f, err := os.Open("/tmp/ll")
	if err != nil {
		//log.Printf("open failed: %s", err.Error()) // 1、错误交由调用者处理，避免处理/记录多次，此错误在main中已有处理
		return errors.Wrap(err, "open failed") // 2、为错误添加相关信息；3、另外，errors.Wrap保留了原始错误的信息
	}
	f.Close()
	return nil
}

func main() {
	err := testError()
	if err != nil {
		log.Printf("testError: %s", err.Error())
		log.Printf("original error: %T %v\n", errors.Cause(err), errors.Cause(err))
		log.Printf("stack trace:\n%+v\n", err)
		os.Exit(1)
	}
}
```

输出：

```bash
 $ go run test.go
2022/06/05 00:01:16 testError: open failed: open /tmp/ll: no such file or directory
2022/06/05 00:01:16 original error: *fs.PathError open /tmp/ll: no such file or directory
2022/06/05 00:01:16 stack trace:
open /tmp/ll: no such file or directory
open failed
main.testError
        /Volumes/FILE/Workspace/go_test/terror/test.go:14
main.main
        /Volumes/FILE/Workspace/go_test/terror/test.go:21
runtime.main
        /usr/local/Cellar/go/1.18.2/libexec/src/runtime/proc.go:250
runtime.goexit
        /usr/local/Cellar/go/1.18.2/libexec/src/runtime/asm_amd64.s:1571
exit status 1
```

### 1.21.2. 自定义错误

根据error接口定义，自定义错误只要实现了Error方法即可
```go
type error interface {
	Error() string
}
```

例：
```go
package main

import (
	"fmt"
)

type DivisorZeroError struct {
	Divisor int
}

func (e *DivisorZeroError) Error() string {
	return "除数不能为0"
}

func div(a, b int) (float64, error) {
	if b == 0 {
		return 0, &DivisorZeroError{Divisor: b}
	}

	return float64(a) / float64(b), nil
}

func main() {
	res, err := div(4, 1)
	if e, ok := err.(*DivisorZeroError); ok {
		panic(e.Error())
	}
	fmt.Println("res: ", res)
	
	res, err = div(5, 0)
	switch err.(type) {
	case *DivisorZeroError:
		panic(err.Error())
	}
	fmt.Println("res: ", res)
}
```

## 1.22. go build参数

```
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags "-w -s" -gcflags "-N -l" -mod=vendor -o runtime/bin/license-srv cmd/main.go
```

1、gcflags编译参数：`go tool compile --help`查看可用参数

-N 禁用优化

-l 禁用内联

-m 打印出逃逸分析的优化策略

2、ldflags链接参数：`go tool link –help`查看可用参数

-w 禁用DWARF

-s 禁用符号表

## 1.23. go语言中init函数执行顺序

`import --> const --> var --> init()`

1. 如果一个包导入了其他包，则首先初始化导入的包。
2. 然后初始化当前包的常量。
3. 接下来初始化当前包的变量。
4. 最后，调用当前包的 `init()` 函数。

> 参考：[一张图了解 Go 语言中的 init () 执行顺序](https://learnku.com/go/t/47135)

## 1.24. context的使用

### 1.24.1. 停止协程

```go
package main

import (
    "context"
    "log"
    "os/exec"
    "sync"
    "time"
)

func Run(ctx context.Context) {
    cmd := exec.CommandContext(ctx, "sleep", "300")
    err := cmd.Start()
    if err != nil {
        // Run could also return this error and push the program
        // termination decision to the `main` method.
        log.Fatal(err)
    }

    err = cmd.Wait()
    if err != nil {
        log.Println("waiting on cmd:", err)
    }
}

func main() {
    var wg sync.WaitGroup
    ctx, cancel := context.WithCancel(context.Background())

    // Increment the WaitGroup synchronously in the main method, to avoid
    // racing with the goroutine starting.
    wg.Add(1)
    go func() {
        Run(ctx)
        // Signal the goroutine has completed
        wg.Done()
    }()

    <-time.After(3 * time.Second)
    log.Println("closing via ctx")
    cancel()

    // Wait for the child goroutine to finish, which will only occur when
    // the child process has stopped and the call to cmd.Wait has returned.
    // This prevents main() exiting prematurely.
    wg.Wait()
}
```

> 参考：[go - how to call cancel() when using exec.CommandContext in a goroutine](https://stackoverflow.com/questions/52346262/how-to-call-cancel-when-using-exec-commandcontext-in-a-goroutine)

### 1.24.2. 协程超时

`context.WithTimeout`返回上下文和一个取消方法。`ctx.Done`会在超时时间到达，或执行取消方法时收到消息。

```go
ctx, cancel := context.WithTimeout(context.Background(), 3*time.Second)

go func(ctx context.Context) {
    for {
        select {
        case <-ctx.Done():
            done = true
        default:
            // do something
        }
    }
}(ctx)

time.Sleep(5*time.Second)
cancel()
```

## 1.25. 值类型、引用类型

golang中分为值类型和引用类型

值类型分别有：int系列、float系列、bool、string、数组和结构体

引用类型有：指针、slice切片、管道channel、接口interface、map、函数等

值类型的特点是：变量直接存储值，内存通常在栈中分配

引用类型的特点是：变量存储的是一个地址，这个地址对应的空间里才是真正存储的值，内存通常在堆中分配

## 1.26. go中函数传参都是值传递

> 参考：
> 
> [Go语言参数传递是传值还是传引用](https://www.flysnow.org/2018/02/24/golang-function-parameters-passed-by-value)

## 1.27. go build缓存目录

缓存目录：`~/.cache/go-build`，使用docker容器编译打包时将这个目录做个卷映射可加速编译

## 1.28. 编码规范

### 1.28.1. 命名规范

- 文件名全部小写，除单元测试外避免使用下划线
- 变量名、常量、函数名使用驼峰式命名，不建议使用下划线和数字

> 参考：[命名规范 | go-zero](https://go-zero.dev/cn/docs/develop/naming-spec/)

## 1.29. 错误处理，error与panic

### 1.29.1. 自定义error

error接口定义：
```go
type error interface {
	Error() string
}
```

所以只要实现了Error方法，就是一个error
```go
type PathExistError struct {
	path string
}

func (e *PathExistError)Error() string {
	return "path exist"
}

// 目录不存在时创建
func CheckPath(path string) error {
	// 判断是否为绝对路径
	if !filepath.IsAbs(path) {
		return errors.New("请输入绝对路径")
	}
	//存在且为空则创建路径
	_, err := os.Stat(path)
	if os.IsNotExist(err) {
		err := os.MkdirAll(path, os.ModePerm)
		if err != nil {
			return errors.New("创建目录失败")
		}
		return nil
	}
	dir, _ := ioutil.ReadDir(path)
	if len(dir) != 0 {
		return &PathExistError{path: path}
	}
	return nil
}
```

判断error类型是否是指定的error
```go
err := CheckPath("/tmp/1234")
if pe, ok := err.(*PathExistError); ok { // 是路径存在错误
	fmt.Println(pe.path)
}

switch err.(type)
{
	case *PathExistError:
		fmt.Println(err)
	default:
		panic(err)
}
```

### 1.29.2. panic恢复

1. 程序中非致命的问题应避免使用panic，除非目的就是要中断程序（当前协程）
2. 守护型协程应该使用recover捕获panic并恢复，避免协程由于异常退出

```go
go func() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("recovered from ", r) // r是panic的原因，即panic()的参数
			debug.PrintStack()
		}
	}
}()
```

```go
// You can edit this code!
// Click here and start typing.
package main

import (
	"fmt"
	"time"
)

func test() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("panic: ", r)
			// 默认协程会继续执行，子协程不会中止，会继续打印timer
			// panic(r) // 协程外抛panic
		}
	}()

	go func() {
		for {
			select {
			case <-time.After(1 * time.Second):
				fmt.Println("timer")
			}
		}
	}()

	time.Sleep(10 * time.Second)
	panic("test")
}

func main() {
	go test()
	time.Sleep(15 * time.Second)
}

```
## 1.30. 内置排序方法

使用内置排序需要实现`sort.Interface`接口
```go
type Interface interface {
        // 获取数据集合元素个数
        Len() int
        // 如果 i 索引的数据小于 j 索引的数据，返回 true，且不会调用下面的 Swap()，即数据升序排序。
        Less(i, j int) bool
        // 交换 i 和 j 索引的两个元素的位置
        Swap(i, j int)
}
```

使用示例：
```go
package main

import (
    "fmt"
    "sort"
)

// 学生成绩结构体
type StuScore struct {
    name  string    // 姓名
    score int   // 成绩
}

type StuScores []StuScore

//Len()
func (s StuScores) Len() int {
    return len(s)
}

//Less(): 成绩将有低到高排序
func (s StuScores) Less(i, j int) bool {
    return s[i].score < s[j].score
}

//Swap()
func (s StuScores) Swap(i, j int) {
    s[i], s[j] = s[j], s[i]
}

func main() {
    stus := StuScores{
                {"alan", 95},
                {"hikerell", 91},
                {"acmfly", 96},
                {"leao", 90},
                }

    // 打印未排序的 stus 数据
    fmt.Println("Default:\n\t",stus)
    //StuScores 已经实现了 sort.Interface 接口 , 所以可以调用 Sort 函数进行排序
    sort.Sort(stus)
    // 判断是否已经排好顺序，将会打印 true
    fmt.Println("IS Sorted?\n\t", sort.IsSorted(stus))
    // 打印排序后的 stus 数据
    fmt.Println("Sorted:\n\t",stus)
}
```

## 1.31. GMP模型与调度流程

### 1.31.1. GMP模型

- G（Goroutine）：协程
- M（Machine）：对内核级线程的封装
- P（Processor）：即为G和M的调度对象，用来调度G和M之间的关联关系，其数量可通过GoMAXPROCS()来设置，默认为核心数

### 1.31.2. 调度流程

1. 存在一个全局G队列
2. 每个P有一个局部G队列，
3. 每个P和一个M绑定，M从绑定的P中获取G来执行
4. 若P中局部G队列为空，则从全局G队列获取或从其他P的局部G队列偷取
5. 



## 1.32. GC垃圾回收

### 1.32.1. 三色标记法

### 1.32.2. GC触发时机

### 1.32.3. GC流程




## 1.33. 变量分配在堆上还是栈上，内存逃逸分析

### 1.33.1. 哪些情况会分配到堆上

1. Go 中声明一个函数内局部变量时，当编译器发现变量的作用域没有逃出函数范围时，就会在栈上分配内存，反之则分配在堆上，逃逸分析由编译器完成，作用于编译阶段
2. 指针类型的变量
3. 栈空间不足：对于有声明类型的变量大小超过 10M 会被分配到堆上，隐式变量默认超过64KB 会被分配在堆上
4. 动态类型：返回返回一个interface{}类型
5. 闭包引用对象

### 1.33.2. 检查该变量是在栈上分配还是堆上分配

有两种方式可以确定变量是在堆还是在栈上分配内存:
-   通过编译后生成的汇编函数来确认，在堆上分配内存的变量都会调用 runtime 包的 `newobject` 函数；
```bash
	go tool compile -S main.go
```
-   编译时通过指定选项显示编译优化信息，编译器会输出逃逸的变量；
```bash
go tool compile -l -m -m main.go
# 或者
go build -gcflags "-m -m -l" main.go
```

> 参考：
> 1. [Frequently Asked Questions (FAQ) - The Go Programming Language](https://go.dev/doc/faq#stack_or_heap)
> 2. [golang 中函数使用值返回与指针返回的区别，底层原理分析](https://cloud.tencent.com/developer/article/1890639)
## 1.34. 内部包internal

内部包的规范约定：导出路径包含`internal`关键字的包，只允许`internal`的父级目录及父级目录的子包导入，其它包无法导入。

例如：

```text
.
|-- resources
|   |-- internal
|   |   |-- cpu
|   |   |   `-- cup.go
|   |   `-- mem
|   |       `-- mem.go
|   |-- input
|   |   |-- input.go
|   `-- mainboard.go
|-- prototype
|   `-- professional.go 
|-- go.mod
|-- go.sum 
```

如上包结构的程序，`resources/internal/cpu`和`resources/internal/mem`只能被`resources`包及其子包`resources/input`中的代码导入，不能被`prototype`包里的代码导入。

# 2. 第三方包

## 2.1. Gorm

相对更新：

```go
Db.Model(xy).Where("id = ? ", id).Update("sign_up_num", gorm.Expr("sign_up_num+ ?", 1))
```

# 3. 开发环境

## 3.1. vscode

### 3.1.1. 配置调试当前go文件

```json
{
    // 使用 IntelliSense 了解相关属性。 
    // 悬停以查看现有属性的描述。
    // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug with dlv",
            "type": "go",
            "request": "launch",
            "mode": "debug",
            "program": "${file}",
            "cwd": "${workspaceFolder}",
            "env": {},
            "args": [],
            "showLog": true
        }
    ]
}
```





