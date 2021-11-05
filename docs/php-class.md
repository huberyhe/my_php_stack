[回到首页](../README.md)

# PHP类的概念

说明

[TOC]

## 1、类的三个特性

- 封装：让类更加安全。让成员属性变成私有，使用方法来访问成员属性
- 继承：子类继承父类的一切非私有属性和方法
- 多态：子类对父类方法重新实现，所以表现可以不同

> 参考：
>
> 1、[PHP 对象及其三大特性 - 翟喵儿 - 博客园 (cnblogs.com)](https://www.cnblogs.com/zhaimiaoer/p/5477044.html)
>
> 2、[PHP 继承、封装与多态 | 面向对象编程 | PHP 入门到实战教程 (laravelacademy.org)](https://laravelacademy.org/post/21638)

## 2、抽象类与接口

抽象类：abstract class，继承extends

2.1、抽象类不能被实例化

2.2、可以定义抽象方法、非抽象方法和属性，子类必须实现父类定义的抽象方法

2.3、抽象类可以实现接口，且可以不实现其中的方法

接口：interface，实现implements，继承extends

2.1、接口定义了类必须实现的方法，这些方法没有具体内容

2.2、方法必须为public

2.3、可以定义常量

2.4、**类可以实现多个接口**，前提是这些接口中方法不重复；抽象类中可以包含已实现的方法（非抽象）和抽象方法，抽象方法必须被子类实现

2.5、方法的实现必须与接口中的定义一致

```php
interface Play  
{  
    const LEVEL=10;  
    public function PlayLOL();  
    public function PlayFootball();  
} 

interface Read  
{  
    public function ReadNovel();  
} 
	
abstract class  Human
{
    abstract function eat();
}
//抽象类可以实现接口后不实现其方法，可以继承一个抽象类的同时实现多个接口注意必须要把extends语句写在implements前面，否则会报错
abstract class Sutdent extends Human implements Play,Read
{
    abstract function study();
}
```

> 参考：[php抽象类和接口的区别 - vinter_he - 博客园 (cnblogs.com)](https://www.cnblogs.com/vinter/p/8716685.html)

## 3、其他常见问题

3.1、类中self和static的区别

`self`只能引用当前类中的方法，而`static`关键字允许函数能够在运行时动态绑定类中的方法。
