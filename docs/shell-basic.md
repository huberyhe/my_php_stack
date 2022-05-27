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

| 运算符             | 描述                                                     |
| ------------------ | -------------------------------------------------------- |
| string             | 不为空                                                   |
| -n string          | 不为空                                                   |
| -z string          | 为空                                                     |
| string1 == string2 | 相等                                                     |
| string1 != string2 | 不等                                                     |
| string =~ a.*      | 正则匹配，以a开头，又例 [[ "$str" =~ ^"${JAR_NAME}".* ]] |

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

### 1.4、小数比较

#### 1、方法1：bc，非内置命令

```bash
v1=0.124
v2=0.128
if [[ `echo "$v1==$v2" | bc` -eq 1 ]]; then
	echo "equal"
elif [[ `echo "$v1>$v2" | bc` -eq 1 ]]; then
	echo "greater-than"
elif [[ `echo "$v1<$v2" | bc` -eq 1 ]]; then
	echo "less-than"
else
	echo "err"
fi
```

#### 2、方法2：awk

```bash
awk -v num1=6.6 -v num2=5.5 'BEGIN{print(num1>num2)?"0":"1"}'
```

#### 3、方法3：expr，推荐

```bash
v1=0.124
v2=0.128
if [[ `expr $v1 \= $v2` -eq 1 ]]; then
	echo "equal"
elif [[ `expr $v1 \> $v2` -eq 1 ]]; then
	echo "greater-than"
elif [[ `expr $v1 \< $v2` -eq 1 ]]; then
	echo "less-than"
else
	echo "err"
fi
```

### 1.5、test

test 与 [] 的功能基本相同，例如

#### 1、判断字符串相同

```
test "abc" = "a" && echo "same"
```

#### 2、判断文件存在

```bash
test -f /etc/passwd && echo "file exist"
```



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

### 3.2、匹配字符串开头的子串长度

**expr match "$string" '$substring'**
$substring 是一个正则表达式。

```bash
MyString=abcABC123ABCabc
echo $(expr match "$MyString" 'abc[A-Z]*.2')   # 结果为 8
```

### 3.3、查找子串位置/索引

**expr index $string $substring**
在字符串 $string 中匹配到的 $substring 第一次出现的位置。

```bash
str="abc"
str1=`expr index $str "a"`
echo $str1 # 结果为 1
```

### 3.4、截取子串

**${string:position}**
在 $string 中从位置 $position 处开始提取子串。
如果 $string 是 "*" 或者 "@"，那么将会提取从位置 $position 开始的位置参数。
**${string:position:length}**
在 $string 中从位置 $position 开始提取 $length 长度的子串。

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

**expr match "$string" '\($substring\)'**
从 $string 的开始位置提取 $substring，$substring 是正则表达式。

```bash
MyString=abcABC123ABCabc
echo $(expr match "$MyString" '\(.[b-c]*[A-Z]..[0-9]\)') # abcABC1
```

### 3.5、字符串替换

```bash
str="apple, tree, apple tree"
echo ${str/apple/APPLE}   # 替换第一次出现的apple
echo ${str//apple/APPLE}  # 替换所有apple
  
echo ${str/#apple/APPLE}  # 如果字符串str以apple开头，则用APPLE替换它
echo ${str/%apple/APPLE}  # 如果字符串str以apple结尾，则用APPLE替换它
```

### 3.6、字符串连接

```bash
str="abc"
str1="ab"
str2=${str}${str1}
```

### 3.7、字符串默认值

```bash
str="abc"
echo ${str:-123} # 输出abc
echo ${str2:-123} # 输出123
```

### 3.8、删除子串

**${string#substring}**
从 $string 的开头位置截掉最短匹配的 $substring。
**${string##substring}**
从 $string 的开头位置截掉最长匹配的 $substring。

```bash
MyString=abcABC123ABCabc
echo ${MyString#a*C} # 123ABCabc
# 截掉 'a' 到 'C' 之间最短的匹配字符串。

echo ${MyString##a*C} # abc
# 截掉 'a' 到 'C' 之间最长的匹配字符串。
```

**${string%substring}**
从 $string 的结尾位置截掉最短匹配的 $substring。
**${string%%substring}**
从 $string 的结尾位置截掉最长匹配的 $substring。

```bash
MyString=abcABC123ABCabc
echo ${MyString%b*c} # abcABC123ABCa
# 从 $MyString 的结尾位置截掉 'b' 到 'c' 之间最短的匹配。

echo ${MyString%%b*c} # a
# 从 $MyString 的结尾位置截掉 'b' 到 'c' 之间最长的匹配。
```

**实用案例**：获取文件名的前缀和后缀

```bash
FILE="example.tar.gz"
echo "${FILE%%.*}" # => example
 
echo "${FILE%.*}" # => example.tar
 
echo "${FILE#*.}" # => tar.gz
 
echo "${FILE##*.}" # => gz
```

### 3.9、字符串分割成数组

1、利用字符串替换

```bash
string="hello,shell,split,test"  
array=(${string//,/ })  
 
for var in ${array[@]}
do
   echo $var
done
```

2、利用IFS分隔符

```bash
string="hello,shell,split,test"  
 
#对IFS变量 进行替换处理
OLD_IFS="$IFS"
IFS=","
array=($string)
IFS="$OLD_IFS"
 
for var in ${array[@]}
do
   echo $var
done
```

3、利用tr字符串替换

```bash
string="hello,shell,split,test"  
array=(`echo $string | tr ',' ' '` )  
 
for var in ${array[@]}
do
   echo $var
done 
```



> 参考：
>
> 1、[Bash 字符串处理命令](https://www.cnblogs.com/dmir/p/6267374.html)
>
> 2、[Bash 中常见的字符串操作](https://www.cnblogs.com/sparkdev/p/10006970.html)

## 4、数组使用

### 4.1、定义一个数组变量

```bash
array_name=(value1 value2 ... valuen)

array_name[0]=value0
array_name[1]=value1
array_name[2]=value2

# 这种要求元素下标连续
array_name[${#array_name[@]}]=$value3
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

### 4.5、判断元素是否在数组中

1、遍历

```bash
for i in ${array[@]}
do
   [ "$i" == "$var" ] && echo "yes"
done
```

2、grep

```bash
echo "${array[@]}" | grep -wq "$var" && echo "Yes" || echo "No"
```

3、尝试移除元素后，看数组有没有变化

```bash
[[ ${array[@]/${var}/} != ${array[@]} ]] && echo "Yes" || echo "No"
```

### 4.6、数组作为函数参数

直接传递时函数接收到的只是数组的第一个元素，需要传递所有元素，使用`"${list[*]}"`，例如：

```bash
cover_list=(
placeholder
/types/types.go
)

# 是否在数组中
function inArray() {
    needle=$1
    haystack=$2
    [[ ${haystack[@]/${needle}/} != ${haystack[@]} ]] && return
}


if inArray $f "${cover_list[*]}"; then
	echo "in array"
else
	echo "not in array"
fi
```



## 5、命令行输入

例如命令行：

```bash
./test.sh -f config.conf -v --prefix=/home
```

其中，-f是一个选项，需要一个参数，即config.conf；-v也是一个选项，不需要参数。

--prefix是一个长选项，需要一个参数，使用等号连接（非必需）

### 5.1、手工处理

  \*  $0 ： ./test.sh,即命令本身，相当于C/C++中的argv[0]
  \*  $1 ： -f,第一个参数.
  \*  $2 ： config.conf
  \*  $3, $4 ... ：类推。
  \*  $# 参数的个数，不包括命令本身，上例中$#为4.
  \*  $@ ：参数本身的列表，也不包括命令本身，如上例为 -f config.conf -v --prefix=/home
  \*  $* ：和$@相同，但"$*" 和 "$@"(加引号)并不同，"$*"将所有的参数解释成一个字符串，而"$@"是一个参数数组。

### 5.2、getopts，不支持长选项，但使用非常简单，满足大部分场景

```bash
#!/bin/bash

while getopts "a:bc" arg #选项后面的冒号表示该选项需要参数
do
	case $arg in
		a)
			echo "a's arg:$OPTARG" #参数存在$OPTARG中
			;;
		b)
			echo "b"
			;;
		c)
			echo "c"
			;;
		?)  #当有不认识的选项的时候arg为?
			echo "unkonw argument"
			exit 1
			;;
	esac
done
```

实际使用时抽取成一个函数

```bash
parseArgs() {
  while getopts "b:dgm:n:p:uv" opt; do
  # case处理选项及其参数
  done
}

parseArgs "$@"
```

实例：

```bash
#!/bin/bash
###
### 描述
###
### by hyc171819@gmail.com
###
### Usage:
###   hyc_work_build_git.sh
### Options:
###   -u        是否上传
###   -b        是否生成docker镜像
###   -h        Show this message.

function help() {
	sed -rn 's/^### ?//;T;p' "$0"
}

function parseArgs() {
	while getopts "hub" opt; do
		case ${opt} in
		h)
			help
			exit 1
			;;
		u)
			arg_upload=1
			;;
		b)
			arg_build=1
			;;
		:)
			exit
			;;
		?)
			exit
			;;
		*)
			echo "*分支:${OPTARG}"
			;;
		esac
	done
}

# default no(1)
function askNY ()
{
    ret=0
    timeout=300
    while
        echo -n "$1[y/N]"
    do
        read ans
        if [[ -z $ans ]]; then
            ret=1
            break
        elif [[ "$ans"x = "y"x || "$ans"x = "Y"x ]]; then
            ret=0
            break
        elif [[ "$ans"x = "n"x || "$ans"x = "N"x ]]; then
            ret=1
            break
        else
            continue
        fi
    done
    return $ret
}
arg_upload=0
arg_build=0
parseArgs "$@"

if [[ $arg_build -ne 0 ]] || askNY "Make finished, build image(Y) or not(N)?" ; then
	echo ">>> start build image ..."

	# ...
fi
```

使用"$@"可以将参数原封不动传递给函数

1. 加双引号是防止参数中可能有空格，空格会被shell自动视为分隔符
2. "$@"会将每个参数用双引号括起来传递进去，而"@*"则是所有参数括在双引号中，作为一个参数传入函数

### 5.2、getopt，支持长选项

```bash
#!/bin/bash

# A small example program for using the new getopt(1) program.
# This program will only work with bash(1)
# An similar program using the tcsh(1) script language can be found
# as parse.tcsh

# Example input and output (from the bash prompt):
# ./parse.bash -a par1 'another arg' --c-long 'wow!*\?' -cmore -b " very long "
# Option a
# Option c, no argument
# Option c, argument `more'
# Option b, argument ` very long '
# Remaining arguments:
# --> `par1'
# --> `another arg'
# --> `wow!*\?'

# Note that we use `"$@"' to let each command-line parameter expand to a
# separate word. The quotes around `$@' are essential!
# We need TEMP as the `eval set --' would nuke the return value of getopt.

#-o表示短选项，两个冒号表示该选项有一个可选参数，可选参数必须紧贴选项
#如-carg 而不能是-c arg
#--long表示长选项
#"$@"在上面解释过
# -n:出错时的信息
# -- ：举一个例子比较好理解：
#我们要创建一个名字为 "-f"的目录你会怎么办？
# mkdir -f #不成功，因为-f会被mkdir当作选项来解析，这时就可以使用
# mkdir -- -f 这样-f就不会被作为选项。

TEMP=`getopt -o ab:c:: --long a-long,b-long:,c-long:: \
     -n 'example.bash' -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around `$TEMP': they are essential!
#set 会重新排列参数的顺序，也就是改变$1,$2...$n的值，这些值在getopt中重新排列过了
eval set -- "$TEMP"

#经过getopt的处理，下面处理具体选项。

while true ; do
	case "$1" in
		-a|--a-long) echo "Option a" ; shift ;;
		-b|--b-long) echo "Option b, argument \`$2'" ; shift 2 ;;
		-c|--c-long)
			# c has an optional argument. As we are in quoted mode,
			# an empty parameter will be generated if its optional
			# argument is not found.
			case "$2" in
				"") echo "Option c, no argument"; shift 2 ;;
				*)  echo "Option c, argument \`$2'" ; shift 2 ;;
			esac ;;
		--) shift ; break ;;
		*) echo "Internal error!" ; exit 1 ;;
	esac
done
echo "Remaining arguments:"
for arg do
	echo '--> '"\`$arg'" ;
done
```

> 参考：
>
> [Bash Shell中命令行选项/参数处理](https://www.cnblogs.com/FrankTan/archive/2010/03/01/1634516.html)

## 6、map的使用

### 6.1、声明

```bash
declare -A map
```

### 6.2、初始化

```bash
map=(["aa"]="11" ["bb"]="22")
map["name"]="val"
map["apple"]="pen"
```

### 6.3、输出与遍历

```bash
# 输出所有key
echo ${!map[@]}

# 输出所有value
echo ${map[@]}

# 输出长度
echo ${#map[@]}

# 遍历
for key in ${!map[*]};do
    echo "$key => ${map[$key]}"
done
```

> 参考：
>
> [Shell中map的使用 - 大坑水滴](https://www.cnblogs.com/qq931399960/p/10786362.html)

## 7、数值运算

### 7.1、运算符[ ]

只支持整数，结果也是整数

```bash
a=2
b=3
c=$[a+b]
d=$[a-b]
e=$[a*b]
f=$[a/b]
g=$[a%b] 
```

### 7.2、运算符(())

同7.1

### 7.3、expr及其反引用

```bash
a=2
b=3
expr $a + $b
expr $a - $b
expr $a \* $b
expr $a / $b
expr $a % $b
```

### 7.3、bc

```bash
echo '2.0*3.00'|bc
echo '2.25+4.5'|bc
echo '5.66-7.888'|bc
```

> 参考：[玩转Bash脚本：数值计算](https://blog.csdn.net/guodongxiaren/article/details/40370701)

## 8、特殊变量



| 变量 | 含义                                                         |
| ---- | ------------------------------------------------------------ |
| $0   | 当前脚本的文件名                                             |
| $n   | 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是$1，第二个参数是$2。 |
| $#   | 传递给脚本或函数的参数个数。                                 |
| $*   | 传递给脚本或函数的所有参数。                                 |
| $@   | 传递给脚本或函数的所有参数。被双引号(" ")包含时，与 $* 稍有不同，下面将会讲到。 |
| $?   | 上个命令的退出状态，或函数的返回值。                         |
| $$   | 当前Shell进程ID。对于 Shell 脚本，就是这些脚本所在的进程ID。 |
| $!   | 子shell的进程ID                                              |

$* 和 $@ 的区别

```bash
#!/bin/bash
echo "\$*=" $*
echo "\"\$*\"=" "$*"

echo "\$@=" $@
echo "\"\$@\"=" "$@"

echo "print each param from \$*"
for var in $*
do
    echo "$var"
done

echo "print each param from \$@"
for var in $@
do
    echo "$var"
done

echo "print each param from \"\$*\""
for var in "$*"
do
    echo "$var"
done

echo "print each param from \"\$@\""
for var in "$@"
do
    echo "$var"
done
```

执行 ./test.sh "a A" "b" "c" "d"，看到下面的结果：

```bash
$*= a A b c d
"$*"= a A b c d
$@= a A b c d
"$@"= a A b c d
print each param from $*
a
A
b
c
d
print each param from $@
a
A
b
c
d
print each param from "$*"
a A b c d
print each param from "$@"
a A
b
c
d
```



## 9、其他命令

### 9.1、获取随机数

shuf -i LO-HI -n COUNT

```bash
shuf -i 1-100 -n1
```

