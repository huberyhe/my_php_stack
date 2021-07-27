[回到首页](../README.md)

# Shell基础

[TOC]

## 1、判断语句

### 1.1、整数比较

| 运算符        | 描述     |
| ------------- | -------- |
| num1 -eq num2 | 相等     |
| num1 -ne num2 | 不等     |
| num1 -gt num2 | 大于     |
| num1 -lt num2 | 小于     |
| num1 -ge num2 | 大于等于 |
| num1 -le num2 | 小于等于 |

### 1.2、字符串比较

| 运算符             | 描述   |
| ------------------ | ------ |
| string             | 不为空 |
| -n string          | 不为空 |
| -z string          | 为空   |
| string1 == string2 | 相等   |
| string1 != string2 | 不等   |

### 1.3、文件判断

| 运算符  | 描述       |
| ------- | ---------- |
| -d file | 是目录     |
| -e file | 存在       |
| -f file | 是普通文件 |
| -r file | 可读       |
| -s file | 长度不为0  |
| -w file | 可写       |
| -x file | 可执行     |
| -L file | 是链接文件 |



> 参考：[shell浅谈之二运算符和IF条件判断](https://blog.csdn.net/taiyang1987912/article/details/38893381)

## 2、控制语句

### 2.1、if语句

```bash
if [[ condition1 ]]; then
	command1
elif [[ condition2]]; then
	command2
else
	command3
fi
```

单行`if...else`

```bash
condition &&　do_sth１ || do_sth2
if [ condition ]; then echo 1; else echo 0; fi
```

### 2.2、for循环

```bash
for var in item1 item2 ... itemN
do
    command1
done
```

### 2.3、while循环

```bash
while condition
do
    command
done
```



### 2.4、case语句

case结构变量值依次比较，遇到双分号则跳到esac后的语句执行，没有匹配则脚本将执行默认值"*)"后的命令，直到"';;"为止。case的匹配值必须是常量或正则表达式。

```bash
#!/bin/bash
  
echo "Please Input a score_type(A-E): "
read score_type
 
case "$score_type" in
A)
     echo "The range of score is from 90 to 100 !";;
B)
     echo "The range of score is from 80 to 89 !";;
C)
     echo "The range of score is from 70 to 79 !";;
D)
     echo "The range of score is from 60 to 69 !";;
E)
     echo "The range of score is from 0 to 59 !";;
*)
     echo "What you input is wrong !";;
esac
```

case中使用break退出外层循环。

```bash
#!/bin/bash

while : #开启无限循环
do
    echo -n "输入 1 到 5 之间的数字:"
    read aNum
    case $aNum in
        1|2|3|4|5) echo "你输入的数字为 $aNum!"
        ;;
        *) echo "你输入的数字不是 1 到 5 之间的! 游戏结束"
            break # break 表示退出循环; 如果使用continue关键字，则结束本次循环，继续执行循环后面的内容
        ;;
    esac
done
```

## 3、字符串处理

### 3.1、字符串长度

```bash
str="abc"
echo ${#str}
```

### 3.2、查找子串位置

```bash
str="abc"
str1=`expr index $str "a"`
echo $str1
```

### 3.3、截取子串

```bash
str="abc"
str1=`expr substr $str 1 2`
echo $str1

str="abcdef"
echo ${str:2}           # 从第二个位置开始提取字符串， bcdef
echo ${str:2:3}         # 从第二个位置开始提取3个字符, bcd
echo ${str:(-6):5}      # 从倒数第二个位置向左提取字符串, abcde
echo ${str:(-4):3}      # 从倒数第二个位置向左提取6个字符, cde
```

### 3.4、字符串替换

```bash
str="apple, tree, apple tree"
echo ${str/apple/APPLE}   # 替换第一次出现的apple
echo ${str//apple/APPLE}  # 替换所有apple
  
echo ${str/#apple/APPLE}  # 如果字符串str以apple开头，则用APPLE替换它
echo ${str/%apple/APPLE}  # 如果字符串str以apple结尾，则用APPLE替换它
```

### 3.5、字符串连接

```bash
str="abc"
str1="ab"
str2=${str}${str1}
```

> 参考：[Bash 字符串处理命令](https://www.cnblogs.com/dmir/p/6267374.html)

## 4、数组使用

### 4.1、定义一个数组变量

```bash
array_name=(value1 value2 ... valuen)

array_name[0]=value0
array_name[1]=value1
array_name[2]=value2
```

### 4.2、读取数组

```bash
${array_name[index]}
```

### 4.3、获取数组中所有元素

```bash
my_array=(A B "C" D)

echo "数组的元素为: ${my_array[*]}"
echo "数组的元素为: ${my_array[@]}"
```

### 4.4、获取数组长度

```bash
my_array=(A B "C" D)

echo "数组元素个数为: ${#my_array[*]}"
echo "数组元素个数为: ${#my_array[@]}"
```

## 5、命令行输入

## 6、