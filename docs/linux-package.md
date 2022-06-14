[回到首页](../README.md)

# 1. Linux下打包

说明

[TOC]

## 1.1. RPM包

### 1.1.1. 常用rpm命令

下载rpm包：`sudo yum install --downloadonly nginx --downloaddir=./ `

查看包的信息：`rpm -qpi topihs-server-3.1-0.128b220210.x86_64.rpm`

查看包的脚本：`rpm --scripts -qp topihs-server-3.1-0.128b220210.x86_64.rpm`

查看包的文件：`rpm -qlp lrzsz-0.12.20-36.el7.x86_64.rpm`

重新打包rpm：`rpmrebuild --package --notest-install -e wget-1.14-18.el7_6.1.x86_64.rpm`

查看已安装包的spec：`rpmrebuild -s wget.spec wget`

### 1.1.2. 示例，打包lrzsz

参考[Building and distributing packages](https://developer.ibm.com/tutorials/l-rpm1/)写的，原本是以wget为例，编译不过换成了lrzsz

lrzsz.spec

```bash
#This is a sample spec file for lrzsz

%define _topdir          /home/hubery/rpm_pkgs/my_lrzsz
%define name             lrzsz
%define release          0
%define version          0.12.20
%define buildroot        %{_topdir}/%{name}‑%{version}‑root

BuildRoot:      %{buildroot}
Summary:        GNU lrzsz
License:        GPL
Name:           %{name}
Version:        %{version}
Release:        %{release}
Source:         %{name}-%{version}.tar.gz
Prefix:         /usr/local
Group:          Development/Tools

%description
The GNU lrzsz program downloads files from the Internet using the command‑line.

%prep
%setup ‑q

%build
./configure
make

%install
make install prefix=$RPM_BUILD_ROOT/usr/local

%files
%defattr(-,root,root)
/usr/local/bin/lrb
/usr/local/bin/lrx
/usr/local/bin/lrz
/usr/local/bin/lsb
/usr/local/bin/lsx
/usr/local/bin/lsz
/usr/local/share/locale/de/LC_MESSAGES/lrzsz.mo

%doc
%attr(0444,root,root)
/usr/local/man/man1/lrz.1
/usr/local/man/man1/lsz.1

```

rpm_make_lrzsz.sh

```bash
#!/usr/bin/env bash
sh_dir=$(cd $(dirname $0) && pwd)
build_dir=${sh_dir}/my_lrzsz
tar_file=${sh_dir}/lrzsz-0.12.20.tar.gz
src_spec_filename=lrzsz.spec
dst_spec_filename=lrzsz.spec
src_url=https://src.fedoraproject.org/repo/pkgs/lrzsz/lrzsz-0.12.20.tar.gz/b5ce6a74abc9b9eb2af94dffdfd372a4/lrzsz-0.12.20.tar.gz

if [[ ! -e $tar_file  ]]; then
    wget $src_url -O $tar_file
fi

if [[ -e $build_dir ]]; then
    rm -rf ${build_dir}
fi

mkdir -p ${build_dir}
cd ${build_dir}
mkdir BUILD RPMS SOURCES SPECS SRPMS
cp ${tar_file} SOURCES/
cp ${sh_dir}/${src_spec_filename} SPECS/${dst_spec_filename}

rpmbuild -v -bb --clean ${build_dir}/SPECS/${dst_spec_filename}
```

最终输出：`/home/hubery/rpm_pkgs/my_lrzsz/RPMS/x86_64/lrzsz-0.12.20-0.x86_64.rpm`

### 1.1.3. 常用字段介绍

打包过程阶段：

```
# 预处理阶段。
%prep
# 将SOURCE下的源代码包（上例的lrzsz-0.12.20.tar.gz）解压
%setup ‑q

# 构建阶段
%build
./configure
make

# 安装阶段。将编译好的软件安装到虚拟根目录中，用于后续打包
%install
make install prefix=$RPM_BUILD_ROOT/usr/local

# 文件阶段。声明哪些文件需要打包到rpm中，以及它们的属性
%files

# 清理阶段
%clean
make clean

# 修改记录段，格式固定
%changelog
* Fri Dec 29 2012 foobar <foobar@kidding.com> - 1.0.0-1
- Initial version
```

安装过程阶段：

```
# 安装前执行的脚本，语法和shell脚本的语法相同
%pre
# 安装后执行的脚本
%post
# 卸载前执行的脚本
%preun
# 卸载完成后执行的脚本
%postun
# 清理阶段，在制作完成后删除安装的内容
```

### 1.1.4. 常见宏介绍

```
%{_sysconfdir}        /etc
%{_prefix}            /usr
%{_exec_prefix}       %{_prefix}
%{_bindir}            %{_exec_prefix}/bin
%{_lib}               lib (lib64 on 64bit systems)
%{_libdir}            %{_exec_prefix}/%{_lib}
%{_libexecdir}        %{_exec_prefix}/libexec
%{_sbindir}           %{_exec_prefix}/sbin
%{_sharedstatedir}    /var/lib
%{_datadir}           %{_prefix}/share
%{_includedir}        %{_prefix}/include
%{_oldincludedir}     /usr/include
%{_infodir}           /usr/share/info
%{_mandir}            /usr/share/man
%{_localstatedir}     /var
%{_initddir}          %{_sysconfdir}/rc.d/init.d 
%{_topdir}            %{getenv:HOME}/rpmbuild
%{_builddir}          %{_topdir}/BUILD
%{_rpmdir}            %{_topdir}/RPMS
%{_sourcedir}         %{_topdir}/SOURCES
%{_specdir}           %{_topdir}/SPECS
%{_srcrpmdir}         %{_topdir}/SRPMS
%{_buildrootdir}      %{_topdir}/BUILDROOT
%{_var}               /var
%{_tmppath}           %{_var}/tmp
%{_usr}               /usr
%{_usrsrc}            %{_usr}/src
%{_docdir}            %{_datadir}/doc
%{buildroot}          %{_buildrootdir}/%{name}-%{version}-%{release}.%{_arch}
$RPM_BUILD_ROOT       %{buildroot}
```



### 1.1.5. 其他注意事项

1、如何在升级时获取已安装的版本？

rpm包没有直接方法，且不应该使用`rpm -qa`命令，因为这个时候rpm数据此时可能被锁住。应该通过我们rpm包中的文件判断，所以最好有个固定的位置以固定的方式存储当前版本号。

2、pre与post之间传递信息

rpm包没有直接方法，可以通过写文件实现

>  参考：
>
>  1、[使用spec文件语法创建一个rpm](https://www.cnblogs.com/zafu/p/7423758.html)
>
>  2、[升级和安装的rpm过程中 spec 文件中脚本调用顺序和参数](https://blog.csdn.net/kyle__shaw/article/details/115461583)
>
>  3、[RPM 包的构建 - SPEC 基础知识](https://www.cnblogs.com/michael-xiang/p/10480809.html)
>
>  4、[RPM Packaging Guide (rpm-packaging-guide.github.io)](https://rpm-packaging-guide.github.io/#files)
>
>  5、[rpm升级 配置文件处理规则](http://blog.chinaunix.net/uid-11989741-id-3365435.html)
>
>  6、[Building and distributing packages – IBM Developer](https://developer.ibm.com/tutorials/l-rpm1/)
>
>  7、[Transactions and Rollback with RPM | Linux Journal](https://www.linuxjournal.com/article/7034)
>
>  8、[rpmbuild - RPM spec file find installed version - Stack Overflow](https://stackoverflow.com/questions/35357916/rpm-spec-file-find-installed-version)
>
>  9、[Directives For the %files list (osuosl.org)](https://ftp.osuosl.org/pub/rpm/max-rpm/s1-rpm-inside-files-list-directives.html)
>
>  10、[Fedora Packaging Guidelines :: Fedora Docs (fedoraproject.org)](https://docs.fedoraproject.org/en-US/packaging-guidelines/)

## 1.2. DEB包

## 1.3. ssu包（sangfor）

