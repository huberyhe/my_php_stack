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

根据经验，如果需要声明初始值为零值的变量，应该使用var关键字声明变量；如果提供确切的非零值初始化变量或者使用函数返回值创建变量，应该使用简化变量声明运算符。

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

new用于指定类型（也包括整型、字符串等）的内存创建，同时把内存置为零值，返回的是内存地址。`map, slice,chan`的零值是nil

make用于`map,slice,chan` 的内存创建，返回的对象是类型本身。创建内存不会初始化为零值，意味着对象一定不是nil

### 1.1.4. map需要初始化吗，使用new和make创建的区别

map的声明的时候默认值是nil ，此时进行取值，返回的是对应类型的零值（不存在也是返回零值）；对nil的map赋值会panic，需要先make

使用**new**来创建**map**时，返回的内容是一个指针，这个指针指向了一个所有字段全为0的值**map**对象，需要初始化后才能使用，而使用**make**来创建**map**时，返回的内容是一个引用，可以直接使用。

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
    p := math.Pow10(precision) // 10^precision
    return math.Floor(val*p+0.5) / p
}
```

注意：`fmt.Sprintf("%.1f", 0.25) == "0.2"`

## 1.4. 数组

在函数间传递大数组时，应该使用指针

## 1.5. 切片

### 1.5.1. nil切片与空切片

```go
# 空切片不是nil
emptySlice := []int{}
emptySlice != nil
```

在需要描述一个不存在的切片时，nil切片会很好用。想表示空集合时空切片很好用。

### 1.5.2. append时切片容量增长机制

在切片的容量小于1000个元素时，总是会成倍地增加容量。一旦元素个数超过1000，容量的增长因子会设为1.25，也就是会每次增加25%的容量。

### 1.5.3. 安全复制切片

一般情况下，切片的切片会引用原切片的底层数组。

```go
a := []int{1, 2, 3, 4, 5}
b := a[1:3]
b = append(b, 6)
fmt.Println(a) // 1,2,3,6,5。改变了原切片的值
fmt.Println(b) // 2,3,6
```

如果在创建切片时设置切片的容量和长度一样，就可以强制让新切片的第一个append操作创建一个新的底层数组，与原有的底层数组分离。分离后，可以安全地进行后续修改。

```go
// 部分复制，指定容量，append会分离底层数组
a := []int{1, 2, 3, 4, 5}
b := a[1:3:3]
b = append(b, 6)
fmt.Println(a) // 1,2,3,4,5
fmt.Println(b) // 2,3,6


// 整个复制，没有指定容量，所以如果a本身容量有多余，则c与a的底层数组可能还是同一个
a = make([]int, 0, 5)
a = append(a, 2)
a = append(a, 1)
d := a[:]
d = append(d, 6)
sort.Ints(d) // 对d排序，改变了a的值
fmt.Printf("%p %p %v %v\n", &a[0], &d[0], a, d) // 0xc00007a000 0xc00007a000 [1 2] [1 2 6]
```

也可以使用copy来创建一个独立副本

```go
originalSlice := []int{1, 2, 3, 4, 5}
copiedSlice := make([]int, len(originalSlice))
copy(copiedSlice, originalSlice)
```

## 1.6. 接口

在接口上调用方法时，必须有和方法定义时相同的接收者类型或者是可以从具体类型 P 直接可以辨识的：

- 指针方法可以通过指针调用
- 值方法可以通过值调用
- 接收者是值的方法可以通过指针调用，因为指针会首先被解引用
- **接收者是指针的方法不可以通过值调用**，因为存储在接口中的值没有地址

> 参考：https://learnku.com/docs/the-way-to-go/116-usage-set-and-interface/3652

## 1.7. 映射

映射是无序的集合，无序的原因是映射的实现使用了散列表。


## 1.8. 常量

常量中的数据类型只可以是布尔型、数字型（整数型、浮点型和复数）和字符串型
### 1.8.1. 整型最值

```go
math.MaxInt32
math.MinInt32
```

### 1.8.2. 模拟枚举

go没有提供枚举类型，但可以使用常量模拟

```go
type EnumPolicyType int // 枚举类型

const (
    PolicyTypeAgent EnumPolicyType = iota // 0
    _
    PolicyTypeGroup // 2
)

func typeToName(_type EnumPolicyType) string {
	switch _type {
	case PolicyTypeAgent:
		return "终端策略"
	case PolicyTypeGroup:
		return "部门策略"
	default:
		return "未知策略"
	}
}
```

> 参考：[iota: Golang 中优雅的常量](https://segmentfault.com/a/1190000000656284)

## 1.9. 匿名函数与闭包

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

闭包一般有局部变量（也可以是函数参数和全局 变量），并返回一个函数值，特点是这个函数可以多次使用局部变量，变量的值在闭包生命周期内可以保持。

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

## 1.10. switch的使用

1、switch后可不跟变量
2、case隐式break，只要匹配上就break不再匹配。如果需要匹配多个case，可使用fallthrough

```go
package main

import (
	"fmt"
)

func main() {
	today := 6

	switch {
	case today < 5:
		fmt.Println("Clean your house.")
	case today < 8:
		fmt.Println("Clean your house.")
		fallthrough
	case today <= 10:
		fmt.Println("Buy some wine.")
	case today > 15:
		fmt.Println("Visit a doctor.")
	case today == 25:
		fmt.Println("Buy some food.")
	default:
		fmt.Println("No information available for that day.")
	}
}

```
输出
```
Clean your house.
Buy some wine.
```

## 1.11. 通道

1、 只有可写的通道才能close，close应该在发送方执行

```go
// 初始化
var a chan int
a = make(chan int, 2)

// 写数据
a <- 1
// 读数据
b := <- a
```

2、 通道未初始化或已关闭时的读写情况

- 写未初始化通道：阻塞
- 读未初始化通道：阻塞
- 写关闭的通道：panic
- 读关闭的通道：返回未读完的数据（ok=true）或（零值，ok=false）

3、 基于上述特性，可以通过判断通道是否关闭来决定（多个）协程退出

4、 无缓冲通道与长度为1的有缓冲通道的区别

无缓冲通道必须有接收方准备好接收数据时数据才能发送进去，可以保证同步；有缓冲通道只要缓冲区没满就可以发送消息

## 1.12. 协程



### 1.12.1. 协程池示例，用于计算数字各位的和

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

### 1.12.2. 控制协程数量

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



### 1.12.3. 面试题：交替输出

```go
package main

import (
	"fmt"
	"sync"
	"time"
)

func echo(name string, c chan int) {
	for {
		num := <-c
		time.Sleep(time.Second)
		fmt.Println(name, num)
		c <- num + 1
	}
}

func main() {
	c := make(chan int, 1) // 不带缓冲，或带一个缓冲
	wg := sync.WaitGroup{}

	wg.Add(1)
	go func(idx string, c chan int) {
		echo(idx, c)
		wg.Done()
	}("routine1", c)

	wg.Add(1)
	go func(idx string, c chan int) {
		echo(idx, c)
		wg.Done()
	}("routine2", c)

	c <- 1
	wg.Wait()
	close(c)
}

```

# 2. 高级

## 2.1. 类型判断

### 2.1.1. switch

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


### 2.1.2. reflect反射

## 2.2. 类型转换

### 2.2.1. 整型与字符串互转

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

### 2.2.2. byte转字符串

```go
string('a') // "a"
int('a') // 97
```

### 2.2.3. 断言

```go
type MyStruct struct {
    Field1 string
    Field2 int
}

func main() {
    var i interface{} = MyStruct{"Hello", 42}

    // 使用类型断言将 interface{} 转换为 MyStruct
    s, ok := i.(MyStruct)
    if !ok {
        // 类型断言失败，处理错误
        fmt.Println("Type assertion failed")
        return
    }

    // 现在 s 是 MyStruct 类型的变量，可以安全地访问其字段
    fmt.Println(s.Field1, s.Field2)
}

```



## 2.3. 错误与异常

一般来说，一旦Go程序部署后，在任何情况下发生的异常都不应该导致程序异常退出。

错误转换成异常：

```go
func funcOne() (err error) {
    defer func() {
        if p := recover(); p != nil {
            fmt.Println("异常恢复！p", p)
            if str, ok := p.(string); ok {
                err = errors.New(str)
            } else {
                err = errors.New("success")
            }
            debug.PrintStack()
        }
    }
    
    return funcTwo()
}

func funcTwo() error {
    panic("模拟异常")
    return errors.New("success")
}

func main() {
    err := funcOne()
    if err != nil {
        fmt.Printf("error is nil\n")
    } else {
        fmt.Printf("error is %v\n", err)
    }
}
```



## 2.4. 值类型、引用类型

golang中分为值类型和引用类型

值类型分别有：int系列、float系列、bool、string、数组和结构体

引用类型有：指针、slice切片、管道channel、接口interface、map、函数等

值类型的特点是：变量直接存储值，内存通常在栈中分配

引用类型的特点是：变量存储的是一个地址，这个地址对应的空间里才是真正存储的值，内存通常在堆中分配

值类型在函数传递后不会修改原数据，而引用类型会同时修改

```go
package main

import "fmt"

type ts struct {
    A int
}

func t(st ts, s []int, m map[string]int) {
    st.A = 11
    s[0] = 11
    m["a"] = 11

    return
}

func main() {
    st := ts{
        A: 1,
    }
    s := []int{1,2,3}
    m := map[string]int{
        "a": 1,
        "b": 2,
        "c": 3,
    }
    t(st, s, m)
    fmt.Println(st, s, m) // {1} [11 2 3] map[a:11 b:2 c:3]
}
```

```go
// You can edit this code!
// Click here and start typing.
package main

import "fmt"

func test(nums []int) {
	nums[0] = 11
	nums = append(nums, 4)
}

func test2(nums *[]int) {
	(*nums)[0] = 11
	*nums = append(*nums, 4)
}

func main() {
	nums1 := []int{1, 2, 3}
	nums2 := []int{1, 2, 3}
	test(nums1)
	test2(&nums2)
	fmt.Println(nums1, nums2) // [11 2 3] [11 2 3 4]
}
```



## 2.5. go中函数传参都是值传递

在Go语言中，所有变量都以值的方式传递。因为指针变量的值是所指向的内存地址，在函数之间传递指针变量，是在传递这个地址值，所以依旧被看作以值的方式在传递。

> 参考：
> 
> [Go语言参数传递是传值还是传引用](https://www.flysnow.org/2018/02/24/golang-function-parameters-passed-by-value)


## 2.6. 正则

### 2.6.1. 正则匹配

```go
name := regexp.MustCompile("[\u4e00-\u9fa5~!@#$%^&*(){}|<>\\\\/+\\-【】:\"?'：；‘’“”，。、《》\\]\\[`]")
if name.MatchString(param["username"]) {
    return errors.New("添加失败, 名字中含有特殊字符或有中文")
}
```

### 2.6.2. 正则查找子串

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

### 2.6.3. 替换

```go
re, _ := regexp.Compile("a");
rep := re.ReplaceAllStringFunc("abcd", strings.ToUpper);
fmt.Println(rep) // Abcd
```



## 2.7. 时间

### 2.7.1. `time.Now()`返回的是什么？

返回的是当前时间的`time.Time`对象。

### 2.7.2. 获取当前时间的时间戳

```go
time.Now().Unix() // 1653194203
```

### 2.7.3. 时间格式化

```go
const TimeFormat = "2006-01-02 15:04:05"
time.Now().Format(TimeFormat)
```

### 2.7.4. 时间字符串生成时间对象，时间戳生成时间对象

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

### 2.7.5. 判断是否时零值

```go
tn := time.Now()
tn.IsZero()
```

## 2.8. 文件

### 2.8.1. touch文件

```go
os.OpenFile(filename, os.O_RDONLY|os.O_CREATE, 0666)
```

### 2.8.2. 读写文件

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

### 2.8.3. 实例：

#### 2.8.3.1. 列出目录文件

```go
func main() {
    dir := os.Args[1]
    listAll(dir,0)
}

func listAll(path string, curHier int){
    fileInfos, err := ioutil.ReadDir(path)
    if err != nil{
        fmt.Println(err)
        return
    }

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

#### 2.8.3.2. 拷贝文件和文件夹

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

### 2.8.4. 移动与复制文件

```go
// 移动文件
os.Rename("./aa/bb/c1/file.go", "./aa/bb/c2/file.go")

// 复制文件。没有直接方法，就是读和写文件
```

### 2.8.5. 文件名与后缀

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

### 2.8.6. 删除文件和文件夹

```go
err := os.Remove(file) // 文件夹必须为空
err := os.RemoveAll(path) // 可以删除不为空的文件夹
```

### 2.8.7. 路径存在判断

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

### 2.8.8. 创建目录

```go
os.Mkdir("abc", os.ModePerm) //创建目录  
os.MkdirAll("dir1/dir2/dir3", os.ModePerm) //创建多级目录
```

### 2.8.9. 临时目录和文件

1.14版本新增

```go
ioutil.TempDir("", "example")
ioutil.TempFile(tempDir, "example")
```

1.16版本新增

```go
os.MkdirTemp("", "sampledir")
os.CreateTemp("", "sample")
```

### 2.8.10. 文件md5

```go
func GetFileMD5(filePath string) (string, error) {
	file, err := os.Open(filePath)
	if err != nil {
		return "", err
	}
	hash := md5.New()
	_, _ = io.Copy(hash, file)
	return hex.EncodeToString(hash.Sum(nil)), nil
}
```

### 2.8.11. zip文件解压

```go
package fileHelper

import (
	"archive/zip"
	"fmt"
	"io"
	"mime/multipart"
	"os"
	"path"
	"strings"
)

type Unzip struct {
	closer io.Closer
	files  []*zip.File
}

// 从页面上传解压
func NewUnzipFromRequestFile(file *multipart.FileHeader) (uz *Unzip, err error) {
	f, err := file.Open()
	if err != nil {
		return nil, err
	}

	r, err := zip.NewReader(f, file.Size)
	if err != nil {
		return nil, err
	}

	uz = new(Unzip)
	uz.closer = f
	uz.files = r.File
	return uz, nil
}

// 从文件解压
func NewUnzipFromFile(file string) (uz *Unzip, err error) {
	r, err := zip.OpenReader(file)
	if err != nil {
		return nil, err
	}

	uz = new(Unzip)
	uz.closer = r
	uz.files = r.File
	return uz, nil
}

func (uz *Unzip) Unzip(dest string) error {
	defer uz.closer.Close()

	os.MkdirAll(dest, 0755)

	// Closure to address file descriptors issue with all the deferred .Close() methods
	extractAndWriteFile := func(f *zip.File) error {
		rc, err := f.Open()
		if err != nil {
			return err
		}
		defer func() {
			if err := rc.Close(); err != nil {
				panic(err)
			}
		}()

		fPath := path.Join(dest, f.Name)

		// Check for ZipSlip (Directory traversal)
		if !strings.HasPrefix(fPath, path.Clean(dest)+string(os.PathSeparator)) {
			return fmt.Errorf("illegal file path: %s", fPath)
		}

		if f.FileInfo().IsDir() {
			os.MkdirAll(fPath, f.Mode())
		} else {
			os.MkdirAll(path.Dir(fPath), f.Mode())
			f, err := os.OpenFile(fPath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
			if err != nil {
				return err
			}
			defer func() {
				if err := f.Close(); err != nil {
					panic(err)
				}
			}()

			_, err = io.Copy(f, rc)
			if err != nil {
				return err
			}
		}
		return nil
	}

	for _, f := range uz.files {
		err := extractAndWriteFile(f)
		if err != nil {
			return err
		}
	}

	return nil
}
```


## 2.9. dlv调试

### 2.9.1. 调试时带上命令行参数，`--`后带上参数

```bash
dlv debug main.go --output ./bin/license -- -c ./etc/license.json
dlv exec ./bin/license -- -c ./etc/license.json
```

### 2.9.2. 设置字符串可显示长度

```
config max-string-len 99999
```

### 2.9.3. 常用命令

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

> 参考：[delve/README.md at master · go-delve/delve · GitHub](https://github.com/go-delve/delve/blob/master/Documentation/cli/README.md)


## 2.10. 数据库事务处理

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


## 2.11. 锁

### 2.11.1. 并发锁 sync.Mutex与sync.RWMutex

Mutex是单读写模型，一旦被锁，其他goruntine只能阻塞不能读写。适用于读写不确定的场景，即读写次数没有明显的区别，并且只允许右一个读或者写的场景

RWMutext是单写多读模型，读锁（RLock）占用时会阻止写，不会阻止读；写锁（Lock）占用时会阻止读和写。经常用于读次数远远多于写次数的场景

### 2.11.2. 锁的实现原理

原子的比较交换操作：`atomic.CompareAndSwapInt32`

### 2.11.3. channel实现互斥锁

使用缓冲长度为1的channel，加锁为读，解锁为写。

```go
package main

import (
    "sync"
)

// Lock 锁结构
type Lock struct {
    c chan struct{}
}

// NewLock 生成一个锁
func NewLock() Lock {
    var l Lock
    l.c = make(chan struct{}, 1)
    l.c <- struct{}{} // 放入一把锁用于获取
    return l
}

// TryLock 尝试加锁,成功返回true,失败返回false，不会阻塞等待
func (l Lock) TryLock() bool {
    var lockResult bool
    select {
    case <-l.c:
        lockResult = true
    default:
    }
    return lockResult
}

// 加锁,会阻塞竞争
func (l Lock) Lock() {
    <-l.c
}

// 解锁,重复解锁会阻塞
func (l Lock) Unlock() {
    l.c <- struct{}{}
}

var counter int

func main() {
    l := NewLock()
    var wg sync.WaitGroup
    for i := 0; i < 10; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            if !l.TryLock() {
                println("lock failed")
                return
            }
            counter++
            println("try lock counter ", counter)
            l.Unlock()
        }()
    }
    for i := 0; i < 10; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            l.Lock()
            counter++
            println("lock counter ", counter)
            l.Unlock()
        }()
    }
    wg.Wait()
}
```

### 2.11.4. 文件锁

```go
func main() {
    var f = "/var/logs/app.log"
    file, err := os.OpenFile(f, os.O_RDWR, os.ModeExclusive)
    if err != nil {
        panic(err)
    }
    defer file.Close()

    // 调用系统调用加锁
    err = syscall.Flock(int(file.Fd()), syscall.LOCK_EX|syscall.LOCK_NB)
    if err != nil {
        panic(err)
    }
    defer syscall.Flock(int(file.Fd()), syscall.LOCK_UN)
    // 读取文件内容
    all, err := ioutil.ReadAll(file)
    if err != nil {
        panic(err)
    }

    fmt.Printf("%s", all)
    time.Sleep(time.Second * 10) //模拟耗时操作
}
```



## 2.12. 使用避坑

### 2.12.1. 修改全局变量的问题

```go
package main

import "fmt"

func init() {
var AppPath = "/opt/topsec/topihs"
  AppPath, err := GetAppPath()
	if err != nil {
		panic(err)
	}
  fmt.Println("AppPath1", AppPath)
}

func GetAppPath() (string, error) {
	return "/opt/topsec", nil
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

## 2.13. map并发问题

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

缺点：

1、不适用于大量写的场景，容易导致读操作频繁无法命中，而进一步加锁读取

## 2.14. logrus使用

logrus是十分常用的第三方日志库，项目地址：[sirupsen/logrus: Structured, pluggable logging for Go](https://github.com/sirupsen/logrus)。其他常用日志库还有[Zerolog](https://github.com/rs/zerolog)、 [Zap](https://github.com/uber-go/zap)和[Apex](https://github.com/apex/log).

项目中任何输出应统一使用日志库，不应该使用print打印，包括第三方库如gorm.

![image-20220526100147494](../imgs/image-20220526100147494.png)

### 2.14.1. 配置formater，指定日志输入格式

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

### 2.14.2. 配置gorm使用logrus

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

## 2.15. 性能问题分析与相关工具

### 2.15.1. pprof

#### 2.15.1.1. 修改代码启用pprof

```go
package data

import (
	"fmt"
	"log"
	"net/http"
)

type PprofServer struct{}

func (PprofServer) Start() {
	addr := "0.0.0.0:6060"
	fmt.Printf("Start pprof server, listen addr %s\n", addr)
	err := http.ListenAndServe(addr, nil)
	if err != nil {
		log.Fatal(err)
	}
}

func (PprofServer) Stop() {
	fmt.Printf("Stop pprof server\n")
}
```

```go
import _ "net/http/pprof"

func main() {
    pp := PprofServer{}
	go pp.Start()
	defer pp.Stop()
    
    // ...
}
```

#### 2.15.1.2. 页面查看pprof

[192.168.56.103:6060/debug/pprof/heap?debug=1](http://192.168.56.103:6060/debug/pprof/heap?debug=1)

#### 2.15.1.3. go tool pprof 命令行查看

```bash
go tool pprof -inuse_space  http://127.0.0.1:6060/debug/pprof/heap
```

#### 2.15.1.4. go tool pprof 图形化查看

```bash
go tool pprof -http=0.0.0.0:8081  http://127.0.0.1:6060/debug/pprof/heap
```

类型：

- inuse_space: 分析应用程序的常驻内存占用情况
- alloc_objects: 分析应用程序的内存临时分配情况
- inuse_objects: 查看每个函数所分别的对象数量
- alloc_space: 查看分配的内存空间大小

> 参考：[golang 内存分析/动态追踪](https://lrita.github.io/2017/05/26/golang-memory-pprof/#go-tool)


### 2.15.2. gops进程诊断工具

在go 1.17以上版本下安装

```bash
go get github.com/google/gops
```

且和pprof一样需要改动项目代码，监听一个端口

```go
package main

import (
	"log"
	"time"

	"github.com/google/gops/agent"
)

func main() {
	if err := agent.Listen(agent.Options{}); err != nil {
		log.Fatal(err)
	}
	time.Sleep(time.Hour)
}
```



```bash
 $ gops help
gops is a tool to list and diagnose Go processes.

Usage:
  gops [flags]
  gops [command]

Examples:
  gops <cmd> <pid|addr> ...
  gops <pid> # displays process info
  gops help  # displays this help message

Available Commands:
  completion  Generate the autocompletion script for the specified shell
  gc          Runs the garbage collector and blocks until successful.
  help        Help about any command
  memstats    Prints the allocation and garbage collection stats.
  pprof-cpu   Reads the CPU profile and launches "go tool pprof".
  pprof-heap  Reads the heap profile and launches "go tool pprof".
  process     Prints information about a Go process.
  setgc       Sets the garbage collection target percentage. To completely stop GC, set to 'off'
  stack       Prints the stack trace.
  stats       Prints runtime stats.
  trace       Runs the runtime tracer for 5 secs and launches "go tool trace".
  tree        Display parent-child tree for Go processes.
  version     Prints the Go version used to build the program.

Flags:
  -h, --help   help for gops

Use "gops [command] --help" for more information about a command.
```

> 参考：[Go 进程诊断工具 gops](https://golang2.eddycjy.com/posts/ch6/06-gops/)


### 2.15.3. 开启gc状态打印

```bash
GODEBUG=gctrace=1 /opt/topsec/topihs/TopIHS/debug/patch-srv
```

显示的gc日志

```
gc 43 @811.799s 0%: 0.011+22+0.004 ms clock, 0.089+0/11/18+0.038 ms cpu, 39->39->2 MB, 64 MB goal, 8 P
```

日志字段含义如下

```
    gc # @#s #%: #+#+# ms clock, #+#/#/#+# ms cpu, #->#-># MB, # MB goal, # P
where the fields are as follows:
    gc #        the GC number, incremented at each GC
    @#s         time in seconds since program start
    #%          percentage of time spent in GC since program start
    #+...+#     wall-clock/CPU times for the phases of the GC
    #->#-># MB  heap size at GC start, at GC end, and live heap
    # MB goal   goal heap size
    # P         number of processors used
```

内存占用

```bash
 $ cat /proc/`ps aux | grep '/opt/topsec/topihs/TopIHS/debug/patch-srv' | grep -v 'grep' | awk '{print $2}'`/status | grep '^Vm'
VmPeak:	 1475668 kB
VmSize:	 1475668 kB
VmLck:	       0 kB
VmPin:	       0 kB
VmHWM:	  762044 kB
VmRSS:	  762044 kB
VmData:	 1459848 kB
VmStk:	     132 kB
VmExe:	    6696 kB
VmLib:	       0 kB
VmPTE:	    1584 kB
VmSwap:	       0 kB
```

主动触发gc：`runtime.GC`
触发将内存归还给操作系统的行为：`debug.FreeOSMemory`

### 2.15.4. 打印内存状态

```go
func print_heap_info() {
    var m runtime.MemStats
    runtime.ReadMemStats(&m)
    fmt.Printf("env: %v, sys: %4d MB, alloc: %4d MB, idel: %4d MB, released: %4d MB, inuse: %4d MB\n",
               os.Getenv("GODEBUG"), m.HeapSys/meg, m.HeapAlloc/meg, m.HeapIdle/meg, m.HeapReleased/meg, m.HeapInuse/meg)
}
```

### 2.15.5. 竞态检测，提前发现内存并发问题

```bash
go run -race mysrc.go
```

> 参考：[Go 译文之竞态检测器 race](https://juejin.cn/post/6844903918233714695)

### 2.15.6. 内存逃逸分析

指的是一个变量或对象在其作用域之外仍然被引用或访问的情况

1. 内存分配到堆上的影响

- 垃圾回收（GC）的压力不断增大
- 申请、分配、回收内存的系统开销增大（相对于栈）
- 动态分配产生一定量的内存碎片

2. 分析内存逃逸的方法

```bash
# 通过编译器指令
go build -gcflags '-m -l' main.go
```

- `-m` 会打印出逃逸分析的优化策略，实际上最多总共可以用 4 个 `-m`，但是信息量较大，一般用 1 个就可以了
- `-l` 会禁用函数内联，在这里禁用掉 inline 能更好的观察逃逸情况，减少干扰

```
# 通过反编译命令
go tool compile -S main.go
```

看是否执行了 `runtime.newobject` 方法

> 参考：[1.9 我要在栈上。不，你应该在堆上](https://eddycjy.gitbook.io/golang/di-1-ke-za-tan/stack-heap)

## 2.16. 高并发与性能优化

### 2.16.1. sync.Pool

```go
package main
import (
	"fmt"
	"sync"
)

var pool *sync.Pool

type Person struct {
	Name string
}

func initPool() {
	pool = &sync.Pool {
		New: func()interface{} {
			fmt.Println("Creating a new Person")
			return new(Person)
		},
	}
}

func main() {
	initPool()

	p := pool.Get().(*Person)
	fmt.Println("首次从 pool 里获取：", p)

	p.Name = "first"
	fmt.Printf("设置 p.Name = %s\n", p.Name)

	pool.Put(p)

	fmt.Println("Pool 里已有一个对象：&{first}，调用 Get: ", pool.Get().(*Person))
	fmt.Println("Pool 没有对象了，调用 Get: ", pool.Get().(*Person))
}

```

> 参考：[深度解密 Go 语言之 sync.Pool](https://www.cnblogs.com/qcrao-2018/p/12736031.html)

### 2.16.2. 变量的线程安全问题

对于变量的并发访问往往会产生竞态问题，不同类型由于实现方式不同产生竞态问题的条件也不同，具体可在运行或编译时加`--race`参数检测

对于竞态问题，通用的解决办法时加锁，但加锁后性能会有较大损失，更好的方式时使用atomic包来进行原子化操作

> 参考：[go - Can I concurrently write different slice elements - Stack Overflow](https://stackoverflow.com/questions/49879322/can-i-concurrently-write-different-slice-elements)

#### 2.16.2.1. 并发安全的数据类型

- 原子操作
- 通道Channel
- WaitGroup
- 互斥锁Mutex
- 读写锁RWMutex

基础数据类型整型、字符串、数组、切片、map等都**不是**线程安全的



> 参考：[Golang中，有哪些常见的数据结构是线程安全的？](https://juejin.cn/post/7184308263276511293)

#### 2.16.2.2. sync/atomic


#### 2.16.2.3. sync.Map，支持线程安全的map

```go
package main

import (
	"fmt"
	"sync"
)

func main()  {
	var m sync.Map
	// 1. 写入
	m.Store("qcrao", 18)
	m.Store("stefno", 20)

	// 2. 读取
	age, _ := m.Load("qcrao")
	fmt.Println(age.(int))

	// 3. 遍历
	m.Range(func(key, value interface{}) bool {
		name := key.(string)
		age := value.(int)
		fmt.Println(name, age)
		return true
	})

	// 4. 删除
	m.Delete("qcrao")
	age, ok := m.Load("qcrao")
	fmt.Println(age, ok)

	// 5. 读取或写入
	m.LoadOrStore("stefno", 100)
	age, _ = m.Load("stefno")
	fmt.Println(age)
}

```

> 参考：[深度解密 Go 语言之 sync.map](https://www.cnblogs.com/qcrao-2018/p/12833787.html)


### 2.16.3. bytes.Buffer

```
# 丢弃一个io.Reader
io.Copy(ioutil.Discard, dataIn)
```


### 2.16.4. 实例：读取上传的xml文件并解析时，造成大量内存占用且长时间不能释放

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



> 参考：
> 
> 1、[Go程序内存泄露问题快速定位](https://www.hitzhangjie.pro/blog/2021-04-14-go%E7%A8%8B%E5%BA%8F%E5%86%85%E5%AD%98%E6%B3%84%E9%9C%B2%E9%97%AE%E9%A2%98%E5%BF%AB%E9%80%9F%E5%AE%9A%E4%BD%8D/)
> 
> 2、[内存泄漏的在线排查](https://panzhongxian.cn/cn/2020/12/memory-leak-problem-1/)

## 2.17. 并发设计模式

### 2.17.1. 屏障模式

就是一种屏障，用来阻塞goroutine直到聚合所有goroutine返回结果，可以使用通道来实现

### 2.17.2. 未来模式

也称为承诺模式，主进程不等子进程执行完就直接返回，然后等到未来执行完的时候再去取结果。

### 2.17.3. 管道模式

也称为流水线模式。每一道工序的输出，就是下一道工序的输入，在工序之间传递的东西就是数据，而传递的数据称为数据流

### 2.17.4. 扇出扇入模式

扇出是指多个函数可以从同一通道读取数据，直到该通道关闭。

扇入是指一个函数可以从多个输入中读取数据并继续执行，直到所有输入都关闭。

### 2.17.5. 协程池模式

### 2.17.6. 发布-订阅模式

## 2.18. 多协程并发的优秀实现

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

## 2.19. 并发控制的方法

### 2.19.1. 消息队列+worker

### 2.19.2. 利用带缓冲的通道

### 2.19.3. Semaphore（信号量）

```go
package main

import (
	"context"
	"fmt"
	"golang.org/x/sync/semaphore"
	"sync"
	"time"
)

func main() {
	ctx := context.TODO()

	// 创建一个信号量，最多允许两个并发
	sem := semaphore.NewWeighted(2)

	var wg sync.WaitGroup

	for i := 0; i < 5; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			// 获取信号量
			if err := sem.Acquire(ctx, 1); err != nil {
				fmt.Printf("goroutine %d: %v\n", id, err)
				return
			}
			defer sem.Release(1)

			// 模拟一些工作
			fmt.Printf("goroutine %d: Working\n", id)
			time.Sleep(time.Second)

		}(i)
	}

	wg.Wait()
}
```

### 2.19.4. Singleflight

`golang.org/x/sync/singleflight` 包提供了一个确保只有一个请求执行某个函数的机制，即使这个函数同时被多个 goroutine 请求。

```go
package main

import (
	"fmt"
	"golang.org/x/sync/singleflight"
	"sync"
	"time"
)

func main() {
	var g singleflight.Group

	var wg sync.WaitGroup

	for i := 0; i < 5; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()

			// 使用 singleflight.Do 保证只有一个 goroutine 执行某个函数
			val, err, _ := g.Do("key", func() (interface{}, error) {
				fmt.Printf("goroutine %d: Executing\n", id)
				time.Sleep(time.Second)
				return "result", nil
			})

			if err != nil {
				fmt.Printf("goroutine %d: %v\n", id, err)
				return
			}

			// 所有 goroutine 都会打印相同的结果，而只有一个执行了真正的函数
			fmt.Printf("goroutine %d: Result: %v\n", id, val)
		}(i)
	}

	wg.Wait()
}
```



## 2.20. 错误处理

### 2.20.1. 错误处理注意三点：

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

### 2.20.2. 自定义错误

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

## 2.21. go build参数

```
GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags "-w -s" -gcflags "-N -l" -mod=vendor -o runtime/bin/license-srv cmd/main.go
```

1、gcflags编译参数：`go tool compile --help`查看可用参数

- `-N`：禁用优化。使用 `-N` 标志可以禁用大部分编译器的优化，适用于调试代码时。

- `-l`：禁用内联。使用 `-l` 标志可以禁用编译器的函数内联优化。

- `-m`：打印内存分配统计信息。使用 `-m` 标志可以让编译器输出关于内存分配的统计信息，用于分析程序的内存使用情况，可看到逃逸分析。
- `-m=1`：打印内存分配详细信息。使用 `-m=1` 标志可以让编译器输出更详细的内存分配信息，包括每个函数的内存分配情况。
- `-m=2`：打印内存分配和回收详细信息。使用 `-m=2` 标志可以让编译器输出更详细的内存分配和回收信息，包括每次内存分配和回收的位置和大小。
- `-S`： 输出汇编代码。使用 `-S` 标志可以让编译器输出编译后的汇编代码，用于分析程序的性能和效率。

2、ldflags链接参数：`go tool link –help`查看可用参数

- `-s`： 禁止符号表。使用 `-s` 标志可以在生成的可执行文件中移除符号表和调试信息，减小可执行文件的大小。
- `-w`： 禁止调试信息。使用 `-w` 标志可以在生成的可执行文件中移除调试信息，减小可执行文件的大小。

### 2.21.1. cgo交叉编译

在[Index of /x86_64-linux-musl/](https://more.musl.cc/x86_64-linux-musl/)下载对应平台的`*-linux-musl-cross.tgz / `，解压后添加到PATH。

编译时需要指定对应平台的c编译器，另外要添加`--extldflags "-static -fpic"`以实现静态链接。

```bash
CGO_ENABLED=1 CC=aarch64-linux-musl-gcc CXX=aarch64-linux-musl-g++ GOOS=linux GOARCH=arm64 go build -o server -ldflags '-s -w --extldflags "-static -fpic"' main.go
```

> 参考：[CGO 交叉静态编译 · Issue #27 · eyasliu/blog (github.com)](https://github.com/eyasliu/blog/issues/27)

### 2.21.2. 查看初始化过程

```bash
go build --ldflags=--dumpdep main.go 2>&1 | grep inittask
```

### 2.21.3. 编译时为变量赋值

用于编译时为程序注入git等信息，类似dgraph

```go
package main

import (
    "fmt"
    "os"
)
var (
    gitHash   string
    buildTime string
    goVersion string
)
func main() {
    args := os.Args
    if len(args) == 2 && (args[1] == "--version" || args[1] == "-v") {
        fmt.Printf("Git Commit Hash: %s \n", gitHash)
        fmt.Printf("Build TimeStamp: %s \n", buildTime)
        fmt.Printf("GoLang Version: %s \n", goVersion)
        return
    }
}
```

```bash
go build -ldflags "-X 'main.goVersion=$(go version)' -X 'main.gitHash=$(git show -s --format=%H)' -X 'main.buildTime=$(git show -s --format=%cd)'" -o main.exe version.go
```

### 2.21.4. 指定包时使用通配符

3个点表示匹配所有的字符串。下面命令会编译chapter3目录下的所有包：

```go
go build github.com/goinaction/code/chapter3/...
```




## 2.22. go build缓存目录

缓存目录：`~/.cache/go-build`，使用docker容器编译打包时将这个目录做个卷映射可加速编译


## 2.23. init函数

### 2.23.1. 执行顺序

`import --> const --> var --> init()`

1. 如果一个包导入了其他包，则首先初始化导入的包。
2. 然后初始化当前包的常量。
3. 接下来初始化当前包的变量。
4. 最后，调用当前包的 `init()` 函数。

> 参考：[一张图了解 Go 语言中的 init () 执行顺序](https://learnku.com/go/t/47135)

### 2.23.2. 使用原则

init 函数通常用于：

-   变量初始化
-   检查 / 修复状态
-   注册器
-   运行计算

使用原则：

1.  一个包的 `init()` 不应该依赖包外的环境
2.  一个包的 `init()` 不应该对包外的环境造成影响

尽量避免使用init，只在必要的时候使用，init应该放到显眼的位置，一个包只应出现一次init。

> 参考：[答应我，别在go项目中用init()了](https://studygolang.com/articles/34488)

## 2.24. context的使用

context 用来解决 goroutine 之间*退出通知*、*元数据传递*的功能。

### 2.24.1. 停止协程

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

### 2.24.2. 协程超时

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

### 2.24.3. 元数据传递

```go
package main

import (
	"context"
	"fmt"
)

func main() {
	ctx := context.Background()
	process(ctx)

	ctx = context.WithValue(ctx, "traceId", "qcrao-2019")
	process(ctx)
}

func process(ctx context.Context) {
	traceId, ok := ctx.Value("traceId").(string)
	if ok {
		fmt.Printf("process over. trace_id=%s\n", traceId)
	} else {
		fmt.Printf("process over. no trace_id\n")
	}
}
```

## 2.25. 编码规范

### 2.25.1. 命名规范

- 文件名全部小写，除单元测试外避免使用下划线
- 变量名、常量、函数名使用驼峰式命名，不建议使用下划线和数字
- 命名接口。如果接口类型只包含一个方法，那么这个类型的名字以er结尾。如果接口类型内部声明了多个方法，其名字需要与其行为关联。

> 参考：[命名规范 | go-zero](https://go-zero.dev/cn/docs/develop/naming-spec/)

## 2.26. 错误处理，error与panic

### 2.26.1. 自定义error

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

### 2.26.2. panic恢复

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
## 2.27. 内置排序方法

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

## 2.28. GMP模型与调度流程

### 2.28.1. GMP模型

- G（Goroutine）：协程
- M（Machine）：对内核级线程的封装
- P（Processor）：即为G和M的调度对象，用来调度G和M之间的关联关系，其数量可通过GoMAXPROCS()来设置，默认为核心数

### 2.28.2. 调度流程

1. 存在一个全局G队列
2. 每个P有一个局部G队列，
3. 每个P和一个M绑定，M从绑定的P中获取G来执行
4. 若P中局部G队列为空，则从全局G队列获取或从其他P的局部G队列偷取
5. 

> 参考：[用 GODEBUG 看调度跟踪](https://golang2.eddycjy.com/posts/ch6/04-godebug-sched/)

## 2.29. GC垃圾回收

### 2.29.1. 三色标记法

### 2.29.2. GC触发时机

自动GC

可以通过设置 GOGC 变量来调整初始垃圾收集器的目标百分比值，其对比的规则为当新分配的数值与上一次收集后剩余的实时数值的比例达到设置的目标百分比时，就会触发 GC。而 GOGC 的默认值为 GOGC=100，如果将其设置为 GOGC=off 可以完全禁用垃圾回收器。

手动GC：`runtime.GC`

### 2.29.3. GC流程

1. **标记（Mark）阶段**：
   - 在这个阶段，垃圾回收器会从根对象出发，标记所有能够访问到的对象。根对象通常是全局变量、栈上的变量以及正在执行的 goroutine 的栈上的变量。垃圾回收器会追踪所有与根对象直接或间接相关的对象，并对它们进行标记。标记过程通常使用的是三色标记法（Tri-color Marking），将对象分为白色（未标记）、灰色（已标记但子对象未标记）和黑色（已标记且子对象已标记）三种状态。
2. **标记终止（Mark Termination）阶段**：
   - 在标记阶段结束后，垃圾回收器会扫描所有堆上的对象，将未被标记的对象释放并返回给堆空闲链表，以便后续的分配。这个过程叫做标记终止。通过这一步，垃圾回收器会将所有无法访问到的对象标记为垃圾，并释放它们所占用的内存。
3. **清扫（Sweep）阶段**：
   - 在清扫阶段，垃圾回收器会扫描堆空闲链表，将其中的垃圾对象的内存归还给操作系统。这个阶段的主要工作是清理标记终止阶段释放出来的内存空间，使得这些空间可以被重新分配。
4. **可选的压缩（Optional Compaction）阶段**：
   - 在某些情况下，垃圾回收器还可能会执行可选的压缩阶段。这个阶段的目的是将存活的对象移动到内存堆的一端，以便于后续的内存分配更加高效。在 Go 1.5 版本之后，Go 的标准垃圾回收器不再执行内存压缩，但是在某些特殊情况下（如内存碎片严重），一些第三方实现的垃圾回收器可能会执行内存压缩。


> 参考：[用 GODEBUG 看 GC](https://golang2.eddycjy.com/posts/ch6/05-godebug-gc/)

## 2.30. 变量分配在堆上还是栈上，内存逃逸分析

### 2.30.1. 哪些情况会分配到堆上

1. Go 中声明一个函数内局部变量时，当编译器发现变量的作用域没有逃出函数范围时，就会在栈上分配内存，反之则分配在堆上，逃逸分析由编译器完成，作用于编译阶段
2. 指针类型的变量
3. 栈空间不足：对于有声明类型的变量大小超过 10M 会被分配到堆上，隐式变量默认超过64KB 会被分配在堆上
4. 动态类型：返回返回一个interface{}类型
5. 闭包引用对象

### 2.30.2. 检查该变量是在栈上分配还是堆上分配

有两种方式可以确定变量是在堆还是在栈上分配内存:
-   通过编译后生成的汇编函数来确认，在堆上分配内存的变量都会调用 runtime 包的 `newobject` 函数；
```bash
	go tool compile -S main.go
```
-   编译时通过指定选项显示编译优化信息，编译器会输出逃逸的变量；
```bash
go tool compile -l -m main.go
# 或者
go build -gcflags "-m -l" main.go
```

> 参考：
> 1. [Frequently Asked Questions (FAQ) - The Go Programming Language](https://go.dev/doc/faq#stack_or_heap)
> 2. [golang 中函数使用值返回与指针返回的区别，底层原理分析](https://cloud.tencent.com/developer/article/1890639)

## 2.31. 内部包internal

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

## 2.32. json struct tag

1）不指定tag

```go
Field int // “Filed”:0
```

不指定tag，默认使用变量名称。转换为json时，key为Filed。

（2）直接忽略

```go
Field int json:"-" //注意：必须为"-"，不能带有opts
```

转换时不处理。

（3）指定key名

```go
Field int json:"myName" // “myName”:0
```

转换为json时，key为myName

（4）"omitempty"零值忽略

```go
Field int json:",omitempty"
```

转换为json时，值为零值则忽略，否则key为myName

（5）指定key且零值忽略

```go
Field int json:"myName,omitempty"
```

转换为json时，值为零值则忽略，否则key为myName

（6）指定key为"-"

```go
Field int json:"-," // “-”:0
```

此项与忽略的区别在于多了个”,“。

（7）“string” opt
以上提到的用法都是常见的，这个比较特殊。

"string"仅适用于字符串、浮点、整数或布尔类型，表示的意思是：将字段的值转换为字符串；解析时，则是将字符串解析为指定的类型。主要用于与javascript通信时数据的转换。

注意：
仅且仅有"string"，没有int、number之类的opt。即带"string" opt的字段，编码时仅能将字符串、浮点、整数或布尔类型转换为string类型，反之则不然；解码时可以将string转换为其他类型，反之不然。因为"string"有限制。

```go
Int64String int64 json:",string" // “Int64String”:“0”
```

“string” opt的使用可以在Marshal/Unmarshal时自动进行数据类型的转换，减少了手动数据转换的麻烦，但是一定要注意使用的范围，对不满足的类型使用，是会报错的。

## 2.33. 反射reflect的使用

一个ORM的例子，传入对象，生成一个插入sql：

```go
func MakeCreateSql(in interface{}) (string, error) {
	var tableName string // 表名
	var fields []string  // 字段
	var values string    // 值
	var sql string

	inType := reflect.TypeOf(in)
	tableName = inType.Name() // 表名

	if inType.Kind() == reflect.Struct { // 暂时只支持结构体
		inValue := reflect.ValueOf(in)
		for i := 0; i < inType.NumField(); i++ {
			ft := inType.Field(i)
			fv := inValue.Field(i)

			fieldName := ft.Name // 字段名

			switch fv.Kind() {
			case reflect.String:
				values = fmt.Sprintf(`%s,'%s'`, values, fv.String())
			case reflect.Int, reflect.Int32:
				values = fmt.Sprintf(`%s,%d`, values, fv.Int())
			default:
				return "", errors.New("type not support: " + fieldName)
			}

			fields = append(fields, fieldName)
			fmt.Printf("idx: %d, field: %s, value: %v, kind: %s, tag: %s\n", i, fieldName, fv, fv.Kind().String(), ft.Tag) // idx: 0, field: id, value: 1, kind: int, tag: json:"id"
		}
	}

	if len(fields) > 0 {
		sql = fmt.Sprintf(`insert into %s (%s) values (%s)`, tableName, strings.Join(fields, ","), strings.TrimLeft(values, ","))
	}

	return sql, nil
}

type account struct {
	id   int    `json:"id"`
	name string `json:"name" gorm:"column:name"`
}

func TestMakeCreateSql(t *testing.T) {
	in := account{
		1,
		"jack",
	}
	get, err := MakeCreateSql(in) // insert into account (id,name) values (1,'jack')
	if err != nil {
		t.Errorf("err: %s", err.Error())
	}
	expect := ""
	if get != expect {
		t.Errorf("expect: %s, get: %s", expect, get)
	}
}
```
## 2.34. unsafe的使用

`unsafe.Pointer`表示任意类型且可寻址的指针值，可以在不同的指针类型之间进行转换（类似 C 语言的 void * 的用途）。其包含四种核心操作：

-   任何类型的指针值都可以转换为 Pointer
-   Pointer 可以转换为任何类型的指针值
-   uintptr 可以转换为 Pointer
-   Pointer 可以转换为 uintptr

```go
type Num struct{
    i string
    j int64
}

func main(){
    n := Num{i: "EDDYCJY", j: 1}
    nPointer := unsafe.Pointer(&n)

    niPointer := (*string)(unsafe.Pointer(nPointer))
    *niPointer = "煎鱼"

    njPointer := (*int64)(unsafe.Pointer(uintptr(nPointer) + unsafe.Offsetof(n.j)))
    *njPointer = 2

    fmt.Printf("n.i: %s, n.j: %d", n.i, n.j) // n.i: 煎鱼, n.j: 2
}
```

## 2.35. runtime包的使用

### 2.35.1. 打印堆栈

```go
debug.PrintStack()
```

## 2.36. http包的使用

### 2.36.1. 转发请求

```go
func ForwardHandler(writer http.ResponseWriter, request *http.Request) {
    u, err := url.Parse("https://target.com/path/to/uri")
    if nil != err {
        log.Println(err)
        return
    }

    proxy := httputil.ReverseProxy{
        Director: func(request *http.Request) {
            request.URL = u
        },
    }

    proxy.ServeHTTP(writer, request)
}

func ForwardHandler(writer http.ResponseWriter, request *http.Request) {
    u := &url.URL{
        Scheme: "https",
        Host:   "target.com",
    }

    proxy := httputil.NewSingleHostReverseProxy(u)
    request.URL.Path = "/path/to/uri"
    proxy.ServeHTTP(writer, request)
}
```

## 2.37. embed文件嵌入

1.16版本引入

```go
package main

import (
    _ "embed"
)

//go:embed preset_regex.json
var presetRegex []byte
```
## 2.38. 程序平滑退出

linux下可以使用`man 7 signal`查看POSIX系统信号，常用的2是`ctrl+c`，15是`kill`，9是`kill -9`,9是无条件结束程序，不能被捕获。

```go
package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

func main() {
	// 创建一个信号通道，用于接收操作系统的信号
	sigChan := make(chan os.Signal, 1)

	// 告诉 signal 包监听 SIGINT 和 SIGTERM 信号
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	wg := sync.WaitGroup{}
	ctx, cancel := context.WithCancel(context.Background())
	// 启动程序的主逻辑
	wg.Add(1)
	go func() {
		mainLogic(ctx)
		close(sigChan)
		fmt.Println("主逻辑退出")
		wg.Done()
	}()

	// 等待信号
	s, ok := <-sigChan
	if ok {
		fmt.Println("收到信号", s)
	} else {
		fmt.Println("程序正常退出")
	}

	// 接收到信号后通知主逻辑退出，并执行清理工作
	cleanup(cancel)
	wg.Wait()

	// 退出程序
	os.Exit(0)
}

func mainLogic(ctx context.Context) {
	var done bool
	var counter int
	for !done {
		// 执行程序的主要逻辑
		select {
		case <-ctx.Done():
			done = true
		case <-time.After(5 * time.Second):
			fmt.Println("Working...")
			counter++
			if counter >= 3 {
				done = true // 模拟程序正常退出
			}
		}
	}
}

func cleanup(cancel context.CancelFunc) {
	// 执行清理工作，例如关闭文件、数据库连接等
	fmt.Println("Cleaning up...")
	cancel()
}

```

## 2.39. 定时器

定时器方法：

- `time.Sleep`：阻塞一段时间
- `time.NewTimer`：定时器，一段时间后发送消息到通道，重置后可重复使用。需要Stop释放
- `time.After`：一段时间后发送消息到通道
- `time.AfterFunc`：一段时间后执行一个回调函数
- `time.NewTicker`：重复定时器。从new开始，每隔一段时间往通道里发送一个消息。如果通道里已经有消息，则丢弃。需要Stop释放
- `time.Tick`：NewTicker的简化版本，无法Stop，所以有泄露风险，适用于整个应用程序生命周期



例如：

```go
func testTicker() {
	tn := time.Now()
	tm := time.NewTicker(10 * time.Second) // 从new开始，每10s往通道里发送一个消息。如果通道里已经有消息，则丢弃。
	defer tm.Stop()

	<-tm.C
	fmt.Println(time.Since(tn).Seconds(), "tick n1")

	time.Sleep(11 * time.Second)
	<-tm.C
	fmt.Println(time.Since(tn).Seconds(), "tick n2")

	<-tm.C
	fmt.Println(time.Since(tn).Seconds(), "tick n3")
}
```

打印如下，n2在sleep后立即打印，n3在第30s打印

```bash
10.0146309 tick n1
21.0167355 tick n2
30.0111594 tick n3
```

## 2.40. cgo

```go
package main

/*
#include <stdio.h>
#include <stdlib.h>

void printMessage(char* msg) {
   printf("%s\n", msg);
}
*/
import "C"
import "unsafe"

func main() {
	message := C.CString("Hello, World!")
	defer C.free(unsafe.Pointer(message))
	C.printMessage(message)
}
```

## 2.41. 项目目录结构
```
/myproject
 /api
    /handlers
    /middleware
 /cmd
    /mycommand
      main.go
 /pkg
    /mylibrary
 /web
    /static
    /templates
 Dockerfile
 Makefile
 .gitignore
 README.md
 go.mod
 go.sum
```

- /api: 此目录通常包含API的所有处理器和中间件。
- /cmd: 此目录包含应用程序的所有命令。每个命令都有自己的目录，该目录下包含一个main.go文件，该文件是命令的入口点。
- /pkg: 此目录包含库代码，这些代码可以被其他应用程序使用。
- /web: 此目录包含Web服务器的代码。

## 2.42. 编译时注入编译信息

类似dgraph做的，编译时写入版本、编译日期等信息到进程

```bash
go build -ldflags "-s -w -X 'pkg/gconfig.gitHash=5bfd92b6b23beee0c94969926cdac8ce71aff23a" -o ./bin/test ./cmd/main.go
```

# 3. 底层知识

## 3.1. 切片

## 3.2. map

## 3.3. 锁

## 3.4. 通道

# 4. 内部包

## 4.1. `golang.org/x/sync/errgroup`

```golang
package main

import (
	"context"
	"fmt"
	"golang.org/x/sync/errgroup"
	"time"
)

func main() {
	// 创建一个带有取消机制的上下文
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// 创建 errgroup.Group
	var g errgroup.Group

	// 启动第一个 goroutine
	g.Go(func() error {
		fmt.Println("Goroutine 1: Started")
		// 模拟一些工作
		time.Sleep(time.Second)
		fmt.Println("Goroutine 1: Completed")
		return nil
	})

	// 启动第二个 goroutine
	g.Go(func() error {
		fmt.Println("Goroutine 2: Started")
		// 模拟一个错误
		time.Sleep(time.Second)
		fmt.Println("Goroutine 2: Simulating an error")
		return fmt.Errorf("Goroutine 2: An error occurred")
	})

	// 启动第三个 goroutine
	g.Go(func() error {
		fmt.Println("Goroutine 3: Started")
		// 模拟一些工作
		time.Sleep(time.Second)
		fmt.Println("Goroutine 3: Completed")
		return nil
	})

	// 等待所有 goroutine 完成
	if err := g.Wait(); err == nil {
		fmt.Println("All goroutines completed successfully")
	} else {
		fmt.Printf("At least one goroutine encountered an error: %v\n", err)
	}

	// 手动取消上下文
	cancel()
}
```



## 4.2. `golang.org/x/sync/singleflight`

```golang
package main

import (
	"fmt"
	"golang.org/x/sync/singleflight"
	"sync"
	"time"
)

func main() {
	var g singleflight.Group

	var wg sync.WaitGroup

	for i := 0; i < 5; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()

			// 使用 singleflight.Do 保证只有一个 goroutine 执行某个函数
			val, err, _ := g.Do("key", func() (interface{}, error) {
				fmt.Printf("goroutine %d: Executing\n", id)
				time.Sleep(time.Second)
				return "result", nil
			})

			if err != nil {
				fmt.Printf("goroutine %d: %v\n", id, err)
				return
			}

			// 所有 goroutine 都会打印相同的结果，而只有一个执行了真正的函数
			fmt.Printf("goroutine %d: Result: %v\n", id, val)
		}(i)
	}

	wg.Wait()
}

```



## 4.3. `golang.org/x/sync/semaphore`信号量

```golang
package main

import (
	"context"
	"fmt"
	"golang.org/x/sync/semaphore"
	"sync"
	"time"
)

func main() {
	ctx := context.TODO()

	// 创建一个信号量，最多允许两个并发
	sem := semaphore.NewWeighted(2)

	var wg sync.WaitGroup

	for i := 0; i < 5; i++ {
		wg.Add(1)
		go func(id int) {
			defer wg.Done()
			// 获取信号量
			if err := sem.Acquire(ctx, 1); err != nil {
				fmt.Printf("goroutine %d: %v\n", id, err)
				return
			}
			defer sem.Release(1)

			// 模拟一些工作
			fmt.Printf("goroutine %d: Working\n", id)
			time.Sleep(time.Second)

		}(i)
	}

	wg.Wait()
}
```



## 4.4. `golang.org/x/time/rate`令牌桶限流

```golang
package main

import (
	"fmt"
	"time"

	"golang.org/x/time/rate"
)

func main() {
	// 每1毫秒放1个令牌，桶容量大小为10
	r := rate.Every(1 * time.Millisecond)
	limiter := rate.NewLimiter(r, 10)

	for i := 0; i < 10; i++ {
		// 尝试获取一个令牌，如果获取不到，则阻塞等待
		if limiter.Allow() {
			fmt.Println("Received token")
		} else {
			fmt.Println("No token available")
		}
		time.Sleep(200 * time.Millisecond) // 限制请求速率
	}
}
```



# 5. 第三方包

## 5.1. Gorm

### 5.1.1. 相对更新：

```go
Db.Model(xy).Where("id = ? ", id).Update("sign_up_num", gorm.Expr("sign_up_num+ ?", 1))
```

### 5.1.2. 查询，不存在则创建

```go
var licTmp model.CascadeLic
// 根据where条件查询记录，未找到则根据lic创建。实际会执行两条sql
txn.Where(model.CascadeLic{Type: "lower", LowerTAG: lic.LowerTAG, UUID: lic.UUID}).Attrs(lic).FirstOrCreate(&licTmp)
```

### 5.1.3. 复用通用的逻辑

```go
whereScopeFuncs := make([]func(db *gorm.DB) *gorm.DB, 0)
for _, lic := range recycleLics {
    if lic.LowerTAG != req.LocalTag {
        continue
    }

    recycleTags = append(recycleTags, lic.LowerTAG)
    whereScopeFuncs = append(whereScopeFuncs, func(db *gorm.DB) *gorm.DB {
        return db.Or("type='lower' and lowertag = ? and uuid = ?", lic.LowerTAG, lic.UUID)
    })
}
if len(whereScopeFuncs) > 0 {
    var cnt int
    txn.Scopes(whereScopeFuncs...).Count(&cnt)
    txn.Scopes(whereScopeFuncs...).Delete(&model.CascadeLic{})
}
```

### 5.1.4. 查询后判断错误为未找到

```go
errors.Is(err, gorm.ErrRecordNotFound)
```

### 5.1.5. 日志


> 参考：[Logger | GORM - The fantastic ORM library for Golang, aims to be developer friendly.](https://gorm.io/zh_CN/docs/logger.html)

### 5.1.6. 生成sql语句

开启调试模式后，gorm会打印执行的sql语句，但这个语句不一定是实际执行的sql，特别是在参数经过预处理之后，比如

```sql
SELECT * FROM "td_osloginfo"  WHERE ((logtype LIKE '%'%' or items LIKE '%'%')) AND (agentid ='59E95EDD-5082-9DE8-AFF1-B1C81A63C853') LIMIT 10 OFFSET 0
```

这条语句是gorm生成的，直接放到终端执行是查不到数据的，而实际能查到数据，实际pg的查询日志为

```
2023-06-16 09:41:26.634 CST [9372] LOG:  execute <unnamed>: SELECT * FROM "td_osloginfo"  WHERE ((logtype LIKE $1 or items LIKE $2)) AND (agentid =$3)
2023-06-16 09:41:26.634 CST [9372] DETAIL:  parameters: $1 = '%''%', $2 = '%''%', $3 = '59E95EDD-5082-9DE8-AFF1-B1C81A63C853'
```

对比之下，gorm生成的sql为

```sql
SELECT * FROM "td_osloginfo"  WHERE ((logtype LIKE '%''%' or items LIKE '%''%')) AND (agentid ='59E95EDD-5082-9DE8-AFF1-B1C81A63C853') LIMIT 10 OFFSET 0
```

这条语句看起来是对的，但就是查不到数据，实际pg的查询日志是

```
2023-06-16 09:43:54.911 CST [20235] LOG:  execute <unnamed>: SELECT * FROM "td_osloginfo"  WHERE ((logtype LIKE $1 or items LIKE $2)) AND (agentid =$3) LIMIT 10 OFFSET 0
2023-06-16 09:43:54.911 CST [20235] DETAIL:  parameters: $1 = '%''''%', $2 = '%''''%', $3 = '59E95EDD-5082-9DE8-AFF1-B1C81A63C853'
```

**结论：** 
- 预处理时不需要对单引号转义，数据库会自动转义；sprintf拼接的则需要转义。
- gorm的ToSQL生成的sql不安全，官方不建议用于生产环境

## 5.2. grpc-gateway

[grpc-gateway](https://link.segmentfault.com/?enc=IiOARw%2FsDGNqscUzUzwHcw%3D%3D.rS7Vg97osGOKT4igbY52nEs7DaK4M2QHhyaxkrfkoYZgHMBU7tgWk3gR4PDkgVJi)是protoc的一个插件。它读取gRPC服务定义，并生成一个反向代理服务器，将RESTful JSON API转换为gRPC

```bash
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway
```

> 参考：[go - Grpc+Grpc Gateway实践一 介绍与环境安装](https://segmentfault.com/a/1190000013339403)

## 5.3. fvbock/endless

http服务的平滑重启

```bash
go get -u github.com/fvbock/endless
```

## 5.4. cron定时任务

```bash
go get github.com/robfig/cron/v3@v3.0.0
```

## 5.5. pkg/errors

使用 `github.com/pkg/errors` 包装 `errors`

> 参考：[GitHub - llitfkitfk/go-best-practice: Go语言实战: 编写可维护Go语言代码建议](https://github.com/llitfkitfk/go-best-practice#72-错误只处理一次)

## 5.6. trylock

非阻塞拿锁，非阻塞获取锁状态

```go
package trylock

import (
	"sync"
	"sync/atomic"
	"unsafe"
)

const (
	LockedFlag   int32 = 1
	UnlockedFlag int32 = 0
)

type Mutex struct {
	in     sync.Mutex
	status *int32
}

func NewMutex() *Mutex {
	status := UnlockedFlag
	return &Mutex{
		status: &status,
	}
}

func (m *Mutex) Lock() {
	m.in.Lock()
}

func (m *Mutex) Unlock() {
	m.in.Unlock()
	atomic.StoreInt32(m.status, UnlockedFlag)
}

func (m *Mutex) TryLock() bool {
	if atomic.CompareAndSwapInt32((*int32)(unsafe.Pointer(&m.in)), UnlockedFlag, LockedFlag) {
		atomic.StoreInt32(m.status, LockedFlag)
		return true
	}
	return false
}

func (m *Mutex) IsLocked() bool {
	return (*(*int32)(unsafe.Pointer(&m.in)) & LockedFlag) == LockedFlag
}
```

> 参考：[扩展golang的sync mutex的trylock及islocked](https://xiaorui.cc/archives/5084)

## 5.7. 获取系统信息

```bash
go get github.com/shirou/gopsutil
```

github.com/prometheus/procfs

## 5.8. 日志组件

### 5.8.1. logrus

### 5.8.2. zap

### 5.8.3. seelog

## 5.9. 基础助手

### 5.9.1. go实现集合

集合的特点是元素不重复

[sets package - k8s.io/apimachinery/pkg/util/sets - Go Packages](https://pkg.go.dev/k8s.io/apimachinery/pkg/util/sets)

## 5.10. `go.uber.org/ratelimit` 限流

```go
import (
	"fmt"
	"time"

	"go.uber.org/ratelimit"
)

func main() {
    rl := ratelimit.New(100) // 每秒最多100次操作

    prev := time.Now()
    for i := 0; i < 10; i++ {
        now := rl.Take()
        fmt.Println(i, now.Sub(prev))
        prev = now
    }

    // 输出：
    // 0 0
    // 1 10ms
    // 2 10ms
    // 3 10ms
    // 4 10ms
    // 5 10ms
    // 6 10ms
    // 7 10ms
    // 8 10ms
    // 9 10ms
}

```



# 6. 开发环境

## 6.1. vscode

### 6.1.1. 配置调试当前go文件

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





