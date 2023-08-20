[回到首页](../README.md)

# 1. git常用命令

[TOC]

这里仅对常见问题作简要记录，推荐阅读**[廖雪峰的Git教程](https://www.liaoxuefeng.com/wiki/896043488029600)**、[阮一峰的Git 使用规范流程](https://www.ruanyifeng.com/blog/2015/08/git-use-process.html)和[高质量的Git中文教程](https://github.com/geeeeeeeeek/git-recipes)

## 1.1. 常见工作流程

一个项目至少应该有三个分支：**master正式分支**，**dev开发分支**，以及属于各个成员的**个人开发分支**（比如dev_heyc）

平时成员在个人分支dev_heyc下开发，功能开发完或者bug修复完提交一个merge request到dev分支，分支由主程审核并合并到dev分支。

项目阶段完成后将dev合并到master分支，并打上标签。

特殊情况下可以增加**feature和bug分支**，以便多人一起完成后一起提交，但多数情况下有个人分支并约定一起提交即可。

dev分支和master分支禁止直接提交代码，只允许合并代码，gitlab可以做这个配置。

为减少合并代码时代码冲突，个人分支在合并前先做一次`git rebase`，将远程dev分支的改动合入到自己的个人分支，再进行push和merge。

所以个人使用git的流程是这样的。

```bash
# 1、commit本地修改
git commit -am "some commit"

# 2、拉取远程dev分支
git fetch origin dev

# 3、将远程dev分支的最新提交并入到本地个人分支，实际上是把整个个人分支的提交移动到dev分支的后面
git rebase dev

# 4、提交到远程仓库
git push origin dev_heyc

# 5、在gitlab上提交合并请求
```

注意：`git rebase`的黄金法则是，绝不要在公共的分支上使用它。

## 1.2. 撤销改动

### 1.2.1. 修改在工作区：已修改，未add

```
git checkout -- aaa.txt bbb.txt
git checkout -- *
git checkout -- *.txt
```

### 1.2.2. 修改在暂存区：已add，未commit

```
git reset HEAD aaa.txt bbb.txt
git reset HEAD *
git reset HEAD *.txt
```

### 1.2.3. 修改已提交到本地仓库：已commit

```
#回退到上一个版本
git reset --hard HEAD^
#回退到上上次版本
git reset --hard HEAD^^
git reset --hard HEAD~2

#回退到指定commitid的版本（git log或git reflog获取）
git reset --hard  commit-id
```

### 1.2.4. 修改已提交到远程仓库，回滚某次的提交并重新提交

```bash
git revert <commit-id>
git revert HEAD~2 // 上上次

git commit -a -m "revert to ..."
```

## 1.3. 代码合并的几种方法

### 1.3.1. 1.3.1 git merge

### 1.3.2. 1.3.2 git cherry-pick

`git cherry-pick`命令的作用，就是将指定的提交（commit）应用于其他分支

> 参考：[git cherry-pick 教程](https://www.ruanyifeng.com/blog/2020/04/git-cherry-pick.html)

### 1.3.3. 1.3.3 git merge --squash

> 参考：
> 
> 1. [Git合并那些事——认识几种Merge方法](https://morningspace.github.io/tech/git-merge-stories-1/)
> 2. [github - What does it mean to squash commits in git?](https://stackoverflow.com/questions/35703556/what-does-it-mean-to-squash-commits-in-git)

## 1.4. 设置代理

命令行设置

```bash
# 设置全局代理
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080

# 取消代理
git config --global --unset http.proxy
git config --global --unset https.proxy

# 针对github设置代理和取消代理
git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
git config --global --unset http.https://github.com.proxy)
```

配置文件，修改`~/.ssh/config`

```
# linux
ProxyCommand nc -X 5 -x 127.0.0.1:1080 %h %p

# windows
ProxyCommand connect -S 127.0.0.1:1080 %h %p
```



## 1.5. 其他命令

### 1.5.1. 查看任意目录的状态

```bash
git --git-dir=the/local/repo/.git --work-tree=the/local/repo status
git -C the/local/repo status
```

### 1.5.2. 判断当前目录是否为git仓库

```bash
[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" == "true" ]
```

### 1.5.3. 文件可执行权限

```bash
# 查看权限
git ls-files --stage test.sh
# 增加权限
git update-index --chmod=+x *.sh
```

### 1.5.4. 换行符问题

core.autocrlf
- true：提交时转换为LF，检出时转换为CRLF
- input：提交时转换为LF，检出时不转换
- false：提交检出均不转换

core.safecrlf
- true：拒绝提交包含混合换行符的文件
- false：允许提交包含混合换行符的文件
- warn：提交包含混合换行符的文件时给出警告

```bash
git config --global core.autocrlf input
git config --global core.safecrlf true
```

### 1.5.5. git log

`git log --name-only` 显示每次提交修改的文件名
`git log --name-status`显示每次提交修改的文件名和状态
`git log --stat`显示每次提交修改的文件名和修改统计

### 1.5.6. 归档

```bash
# 将仓库当前分支的最后一次提交，归档到/var/tmp/junk目录，不包含.git目录
git archive --format=tar --prefix=junk/ HEAD | (cd /var/tmp/ && tar xf -)
# 或使用tar
tar --exclude-vcs -zcf foo.tar.gz ./FOLDER_NAME
```

### 1.5.7. 全局gitignore

家目录下创建.gitignore文件，然后配置`core.excludesFile`

```
# linux
git config --global core.excludesFile '~/.gitignore'
# cmd
git config --global core.excludesFile "%USERPROFILE%\.gitignore"
# powershell
git config --global core.excludesFile "$Env:USERPROFILE\.gitignore"
```




## 1.6. git客户端

### 1.6.1. [GitHub CLI](https://github.com/cli/cli#github-cli)，GitHub官方命令行工具

![screenshot of gh pr status](../imgs/84171218-327e7a80-aa40-11ea-8cd1-5177fc2d0e72.png)

### 1.6.2. [Fork](https://git-fork.com/)，Window和mac os下的桌面客户端

![image 1](../imgs/image1Win.jpg)

