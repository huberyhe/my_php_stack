[回到首页](../README.md)

# Shell高级命令

find、awk、sed、grep等

[TOC]

## find查找文件

`find path -option [ -print ] [ -exec -ok command ] {} \;`

### 1、常用过滤条件

- -mount, -xdev : 只检查和指定目录在同一个文件系统下的文件，避免列出其它文件系统中的文件
- -amin n : 在过去 n 分钟内被读取过
- -anewer file : 比文件 file 更晚被读取过的文件
- -atime n : 在过去n天内被读取过的文件
- -cmin n : 在过去 n 分钟内被修改过
- -cnewer file :比文件 file 更新的文件
- -ctime n : 在过去n天内被修改过的文件
- -empty : 空的文件-gid n or -group name : gid 是 n 或是 group 名称是 name
- -ipath p, -path p : 路径名称符合 p 的文件，ipath 会忽略大小写
- -name name, -iname name : 文件名称符合 name 的文件。iname 会忽略大小写
- -size n : 文件大小 是 n 单位，b 代表 512 位元组的区块，c 表示字元数，k 表示 kilo bytes，w 是二个位元组。
- -type c : 文件类型是 c 的文件。
  - d: 目录
  - c: 字型装置文件
  - b: 区块装置文件
  - p: 具名贮列
  - f: 一般文件
  - l: 符号连结
  - s: socket

- -pid n : process id 是 n 的文件

### 2、过滤条件组合：或、且、非

- 或：-o
- 且：-a
- 非：! 或者 `-not`

例如，查找txt和pdf后缀文件，且排除aaa前缀

```bash
>:tmp$ ls -a
.  ..  aaa.txt  bbb.txt  .ccc.txt  ddd.pdf
>:tmp$ find ./ \( -name '*.txt' -o -name '*.pdf' \) -a ! -name 'aaa*'
./.ccc.txt
./bbb.txt
./ddd.pdf
```

### 3、使用正则表示式搜索

`-regex`支持正则表达式匹配文件路径

例如，查找txt和pdf后缀文件，使用正则表达式写法

```bash
>:tmp$ find . -iregex ".*\(\.txt\|\.pdf\)$"
./.ccc.txt
./aaa.txt
./bbb.txt
./ddd.pdf
```

### 4、对查找结果文件执行操作

查找 /var/log 目录中更改时间在 7 日以前的普通文件，并在删除之前询问它们：

```bash
find /var/log -type f -mtime +7 -ok rm {} \;
```

查找当前目录中文件属主具有读、写权限，并且文件所属组的用户和其他用户具有读权限的文件：

```bash
find . -type f -perm 644 -exec ls -l {} \;
```

查找系统中所有文件长度为 0 的普通文件，并列出它们的完整路径：

```bash
find / -type f -size 0 -exec ls -l {} \;
```

### 5、文件名中包含空格时的处理

当文件名中包含空格符时，xargs对文件操作会提示找不到文件

xargs 默认是以空白字符 (空格， TAB，换行符) 来分割记录的，因此文件名` ./file 1.log` 被解释成了两个记录` ./file` 和 `1.log`

```bash
>:~$ find tmp/ -name '*.log'
tmp/file 1.log
tmp/file 2.log
>:~$ find tmp/ -name '*.log' | xargs rm
rm: cannot remove 'tmp/file': No such file or directory
rm: cannot remove '1.log': No such file or directory
rm: cannot remove 'tmp/file': No such file or directory
rm: cannot remove '2.log': No such file or directory
```

为了解决此类问题， 让 find命令在打印出一个文件名之后接着输出一个 NULL 字符 (`'\0'`) 而不是换行符，然后再告诉 xargs 也用 NULL 字符来作为记录的分隔符。这就是 find 的 `-print0` 和 xargs 的` -0` 的来历吧。

```bash
>:~$ find tmp/ -name '*.log' -print0 | xargs -0 rm
>:~$ find tmp/ -name '*.log'
>:~$
```

### 0、其他实例：

```bash
# 删除10天前以html后缀的文件，包括带空格的文件
find /usr/local/backups -name "*.html" -mtime +10 -print0 | xargs -0 rm -rfv
find /usr/local/backups -mtime +10 -name "*.html" -exec rm -rf {} \;

# 只在查找当前目录中查找，不查找子目录：-maxdepth \ -mindepth
find . -maxdepth 1 -name '*.txt'
```

> 参考：
>
> [Linux查找目录下的按时间过滤的文件](https://www.cnblogs.com/hhwww/p/10827558.html)

## awk格式化输出

```
awk [选项参数] 'script' var=value file(s)
或
awk [选项参数] -f scriptfile var=value file(s)
```

### 1、多分隔符

```bash
# 使用多个分隔符.先使用空格分割，然后对分割结果再使用","分割
awk -F '[ ,]' '{print $1,$2,$5}' log.txt
```

### 2、过滤

```bash
# 过滤第一列大于2并且第二列等于'Are'的行
awk '$1>2 && $2=="Are" {print $1,$2,$3}' log.txt
```

### 3、正则匹配

```bash
# 输出第二列包含 "th"，并打印第二列与第四列
awk '$2 ~ /th/ {print $2,$4}' log.txt
# 输出包含 "re" 的行
awk '/re/ ' log.txt
# 忽略大小写
awk 'BEGIN{IGNORECASE=1} /this/' log.txt
```

### 4、常用内置变量

-  FS(Field Separator)：输入字段分隔符， 默认为空白字符
-  OFS(Out of Field Separator)：输出字段分隔符， 默认为空白字符
-  RS(Record Separator)：输入记录分隔符(输入换行符)， 指定输入时的换行符
-  ORS(Output Record Separate)：输出记录分隔符（输出换行符），输出时用指定符号代替换行符
-  NF(Number for Field)：当前行的字段的个数(即当前行被分割成了几列)
-  NR(Number of Record)：行号，当前处理的文本行的行号。
-  FNR：各文件分别计数的行号
-  ARGC：命令行参数的个数
-  ARGV：数组，保存的是命令行所给定的各参数

### 5、awk脚本

```bash
$ cat score.txt
Marry   2143 78 84 77
Jack    2321 66 78 45
Tom     2122 48 77 71
Mike    2537 87 97 95
Bob     2415 40 57 62
$ cat cal.awk
#!/bin/awk -f
#运行前
BEGIN {
    math = 0
    english = 0
    computer = 0
 
    printf "NAME    NO.   MATH  ENGLISH  COMPUTER   TOTAL\n"
    printf "---------------------------------------------\n"
}
#运行中
{
    math+=$3
    english+=$4
    computer+=$5
    printf "%-6s %-6s %4d %8d %8d %8d\n", $1, $2, $3,$4,$5, $3+$4+$5
}
#运行后
END {
    printf "---------------------------------------------\n"
    printf "  TOTAL:%10d %8d %8d \n", math, english, computer
    printf "AVERAGE:%10.2f %8.2f %8.2f\n", math/NR, english/NR, computer/NR
}
$ awk -f cal.awk score.txt
NAME    NO.   MATH  ENGLISH  COMPUTER   TOTAL
---------------------------------------------
Marry  2143     78       84       77      239
Jack   2321     66       78       45      189
Tom    2122     48       77       71      196
Mike   2537     87       97       95      279
Bob    2415     40       57       62      159
---------------------------------------------
  TOTAL:       319      393      350
AVERAGE:     63.80    78.60    70.00
```

### 0、其他实例

计算文件大小

```bash
ls -l *.txt | awk '{sum+=$5} END {print sum}'
```

打印九九乘法表

```bash
seq 9 | sed 'H;g' | awk -v RS='' '{for(i=1;i<=NF;i++)printf("%dx%d=%d%s", i, NR, i*NR, i==NR?"\n":"\t")}'
```

> 参考：
>
> [Linux awk 命令](https://www.runoob.com/linux/linux-comm-awk.html)

## sed编辑文本

## grep查找文本
