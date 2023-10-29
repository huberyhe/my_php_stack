[回到首页](../README.md)

# 1. lua基本使用

说明

[TOC]

## 1.1. 数据类型

Lua 中有 8 个基本类型分别为：nil、boolean、number、string、userdata、function、thread 和 table

查看变量类型：

```lua
type(true)=="boolean"
```

删除一个变量：

```lua
a=1
a=nil
```

局部变量：
```lua
a = 5               -- 全局变量  
local b = 5         -- 局部变量
```

注释：
```lua
-- 单行注释
--[[
 多行注释
 多行注释
 --]]
```
### 1.1.1. 布尔
boolean 类型只有两个可选值：true（真） 和 false（假），Lua 把 false 和 nil 看作是 false，其他的都为 true，数字 0 也是 true

### 1.1.2. 字符串
字符串定义：
```lua
string1 = "this is string1"
string2 = 'this is string2'

html = [[  
<html>  
<head></head>  
<body>  
    <a href="http://www.runoob.com/">菜鸟教程</a>  
</body>  
</html>  
]]
```

字符串连接：
```lua
> print("a" .. 'b')
ab
```

字符串长度：
```lua
> len = "Hello, 世界!"
> print(#len)
14
> print(string.len(len))
14
> utf8.len(myString)
9
> 
```

字符串格式化打印：
```lua
> string.format("the value is:%d",4)
the value is:4

```
### 1.1.3. 表table

lua表是一个关联数组，下标从1开始

```lua
local tbl = {a="apple", p="pear", "orange", "grape"}
for key, val in pairs(tbl) do
    print("Key", key, val)
end
print(tbl["a"])
print(tbl.a) -- 当索引为字符串类型时的一种简化写法
```

表操作：
```lua
fruits = {"banana","orange","apple"}

-- 连接，返回元素拼接后的字符串：table.concat (table [, sep [, start [, end]]])
print("连接后的字符串 ",table.concat(fruits,", ")) -- banana, orange, apple

-- 插入：table.insert (table, [pos,] value)
table.insert(fruits,"mango")  
print("索引为 4 的元素为 ",fruits[4])

-- 移除：table.remove (table [, pos])
table.remove(fruits)  
print("移除后最后一个元素为 ",fruits[5])

-- 排序：table.sort (table [, comp])
table.sort(fruits)
```
## 1.2. 循环

### 1.2.1. while
```lua
a=10
while( a < 20 )
do
   print("a 的值为:", a)
   a = a+1
end
```

### 1.2.2. for

```lua
-- 数值for循环：i 从 10 变化到 1，每次变化以 -1 为步长递增 i，并执行一次print。-1 是可选的，如果不指定，默认为1
for i=10,1,-1 do  
    print(i)  
end

-- 泛型for循环：打印数组a的所有值  
a = {"one", "two", "three"}
for i, v in ipairs(a) do
    print(i, v)
end 

```

### 1.2.3. repeat...until

```lua
--[ 变量定义 --]
a = 10
--[ 执行循环 --]
repeat
   print("a的值为:", a)
   a = a + 1
until( a > 15 )
```

## 1.3. 流程控制

```lua
--[ 0 为 true ]
if(0)
then
    print("0 为 true")
end
```

## 1.4. 函数

```lua
optional_function_scope function function_name( argument1, argument2, argument3..., argumentn)
    function_body
    return result_params_comma_separated
end

-- optional_function_scope：默认为全局函数，局部函数加local
-- result_params_comma_separated：支持多返回值，逗号隔开
```

可变参数：
```lua
function average(...)
   result = 0
   local arg={...}
   for i,v in ipairs(arg) do
      result = result + v
   end
   print("总共传入 " .. select("#",...) .. " 个数")
   return result/select("#",...)
end

print("平均值为",average(10,5,3,4,5,6))

function f(...)
    a = select(3,...)  -->从第三个位置开始，变量 a 对应右边变量列表的第一个参数
    print (a)  -- 2
    print (select(3,...)) -->打印所有列表参数： 2 3 4 5
end

f(0,1,2,3,4,5)
```

## 1.5. 迭代器

```lua

-- 返回两个值，第一个值作为下次调用时的控制变量
function square(iteratorMaxCount,currentNumber)
   if currentNumber<iteratorMaxCount
   then
      currentNumber = currentNumber+1
   return currentNumber, currentNumber*currentNumber
   end
end

-- 无状态的迭代器：square是迭代函数，3是状态常量，0是控制变量
for i,n in square,3,0
do
   print(i,n)
end
```

```lua
array = {"Google", "Runoob"}

function elementIterator (collection)
   local index = 0
   local count = #collection
   -- 闭包函数
   return function ()
      index = index + 1
      if index <= count
      then
         --  返回迭代器的当前元素
         return collection[index]
      end
   end
end

-- 多状态的迭代器：使用闭包实现
for element in elementIterator(array)
do
   print(element)
end
```

## 1.6. 协同程序

```lua
#!/usr/bin/env lua
function foo()
        print("running")
        local value = coroutine.yield("parsed")
        print("resume, value: " .. tostring(value))
        print("end")
end

-- 创建协同程序
local co = coroutine.create(foo)

-- 启动协同程序
local status, result = coroutine.resume(co)
print(result) -- 输出: 暂停 foo 的执行

-- 恢复协同程序的执行，并传入一个值
status, result = coroutine.resume(co, 42)
print(result) -- 输出: 协同程序 foo 恢复执行，传入的值为: 42
```

生产者消费者

```lua
local newProductor

function productor()
     local i = 0
     while true do
          i = i + 1
          send(i)     -- 将生产的物品发送给消费者
     end
end

function consumer()
     while true do
          local i = receive()     -- 从生产者那里得到物品
          print(i)
     end
end

function receive()
     local status, value = coroutine.resume(newProductor)
     return value
end

function send(x)
     coroutine.yield(x)     -- x表示需要发送的值，值返回以后，就挂起该协同程序
end

-- 启动程序
newProductor = coroutine.create(productor)
consumer()
```

## 1.7. 错误处理

断言：assert首先检查第一个参数，若没问题，assert不做任何事情；否则，assert以第二个参数作为错误信息抛出

error函数：终止正在执行的函数，并返回message的内容作为错误信息(error函数永远都不会返回)
```
error (message [, level])
```

pcall函数：以一种"保护模式"来调用第一个参数，因此pcall可以捕获函数执行中的任何错误

