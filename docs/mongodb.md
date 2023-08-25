[回到首页](../README.md)

# 1. MongoDB

说明

[TOC]

## 1.1. 使用场景

## 1.2. 基本使用

### 1.2.1. 连接

```bash
mongo host:port/database -u username -p password
```

### 1.2.3. CRUD基本方法

```
show databases;
use sample_mflix;

show collections;

# 插入
db.movies.insertOne(
  {
    title: "The Favourite",
    genres: [ "Drama", "History" ],
    runtime: 121,
    rated: "R",
    year: 2018,
    directors: [ "Yorgos Lanthimos" ],
    cast: [ "Olivia Colman", "Emma Stone", "Rachel Weisz" ],
    type: "movie"
  }
)
db.movies.insertMany([
   {
      title: "Jurassic World: Fallen Kingdom",
      genres: [ "Action", "Sci-Fi" ],
      runtime: 130,
      rated: "PG-13",
      year: 2018,
      directors: [ "J. A. Bayona" ],
      cast: [ "Chris Pratt", "Bryce Dallas Howard", "Rafe Spall" ],
      type: "movie"
    },
    {
      title: "Tag",
      genres: [ "Comedy", "Action" ],
      runtime: 105,
      rated: "R",
      year: 2018,
      directors: [ "Jeff Tomsic" ],
      cast: [ "Annabelle Wallis", "Jeremy Renner", "Jon Hamm" ],
      type: "movie"
    }
])

# 查找
db.movies.find()
db.movies.find( {} )
db.movies.find( { "title": "Titanic" } )

# 修改
db.movies.updateOne( { title: "Twilight" },
{
  $set: {
    plot: "A teenage girl risks everything–including her life–when she falls in love with a vampire."
  },
  $currentDate: { lastUpdated: true }
})

# 删除
db.movies.deleteOne( { cast: "Brad Pitt" } )
db.movies.deleteMany( { title: "Titanic" } )
db.movies.deleteMany({})
```

查询：[db.collection.find(query, projection, options).pretty()]([db.collection.find() — MongoDB Manual](https://www.mongodb.com/docs/manual/reference/method/db.collection.find/#db.collection.find))
排序：[cursor.sort(sort)]([cursor.sort() — MongoDB Manual](https://www.mongodb.com/docs/manual/reference/method/cursor.sort/#cursor.sort))
分页：[cursor.skip().limit()]([cursor.limit() — MongoDB Manual](https://www.mongodb.com/docs/upcoming/reference/method/cursor.limit/#cursor.limit))
计数：[cursor.count()]([cursor.count() — MongoDB Manual](https://www.mongodb.com/docs/upcoming/reference/method/cursor.count/#cursor.count))

插入：
```
db.collection.insertOne()
db.collection.insertMany()
db.collection.insert()
```

### 1.2.4. 查询条件

1. 等值匹配：`{ item: null }`，null表示值为null或字段不存在
2. 类型检查：`{ item : { $type: 10 } }`，10表示类型为NULL
3. 存在检查：`{ item : { $exists: false } }`，字段不存在

1. 查询数组，精确匹配：`{ tags: ["red", "blank"] }`，数组的值和顺序必须都相同
2. 查询数组，值匹配：`{ tags: { $all: ["red", "blank"] } }`
3. 查询数组，元素匹配：`{ tags: "red" }`，最少有一个元素为red；`{ dim_cm: { $gt: 15, $lt: 20 } } }`，存在元素大于15且存在元素小于20；`{ dim_cm: { $elemMatch: { $gt: 22, $lt: 30 } } }`，存在元素大于22且小于30；`{ "dim_cm.1": { $gt: 25 } }`，第二个元素值大于25
4. 查询数组，数组长度：`{ "tags": { $size: 3 } }`，至少有三个元素

1. 文档嵌套：`{ "size.h": { $lt: 15 } }`，size下的h小于15

### 1.2.5. 内置方法和变量

### 1.2.6. 关于id

go中使用`bson.NewObjectId()`得到的id是数据库唯一的

> 参考：[mongodb - Possibility of duplicate Mongo ObjectId's being generated in two different collections? - Stack Overflow](https://stackoverflow.com/questions/4677237/possibility-of-duplicate-mongo-objectids-being-generated-in-two-different-colle)

### 1.2.7. 索引

```
# 查看索引
db.clientinfo.getIndexes()

# 创建索引
db.collection.createIndex(
   { orderDate: 1, category: 1 },
   { name: "date_category_fr", collation: { locale: "fr", strength: 2 } }
)

# 查询分析
db.clientinfo.find({_id:'59C70824-120F-50AF-BE19-27F5EB359EED'}).explain()


# 查看索引大小，indexSizes键
db.clientinfo.stats()
```

### 1.2.8. 聚合

1、定义：[`db.collection.aggregate(pipeline, options)`]([db.collection.aggregate() — MongoDB Manual](https://www.mongodb.com/docs/manual/reference/method/db.collection.aggregate/#mongodb-method-db.collection.aggregate))

[聚合参考](https://www.mongodb.com/docs/manual/meta/aggregation-quick-reference/))：

2、集合聚合阶段(db.collection.aggregate)

- `$addFields` 向文档添加新字段
- `$bucket` 根据指定的表达式和存储区边界，将传入的文档分组
- `$bucketAuto` 根据指定的表达式将传入的文档分类为特定数量的组
- `$collStats` 返回有关集合或视图的统计信息
- `$count` 返回聚合管道此阶段的文档数量计数
- `$facet` 在同一组输入文档的单个阶段内处理多个聚合管道
- `$geoNear` 根据与地理空间点的接近程度返回一个有序的文档流
- `$graphLookup` 对集合执行递归搜索
- `$group` 按指定的标识符表达式对文档进行分组，并将累加器表达式(如果指定)应用于每个组
- `$indexStats` 返回有关集合的每个索引的使用情况的统计信息
- `$limit` 将未修改的前 n 个文档传递给管道
- `$listSessions` 列出足以传播到`system.sessions`集合的所有会话
- `$lookup` 对同一数据库中的另一个集合执行左外连接，从“已连接”集合中过滤文档以进行处理
- `$match` 过滤文档流以仅允许匹配的文档未经修改地传递到下一个管道阶段
- `$merge` 将聚合管道的结果文档写入集合
- `$out` 将聚合管道的结果文档写入集合
- `$planCacheStats` 返回集合的计划缓存信息
- `$project` 重新整形流中的每个文档
- `$redact` 通过基于文档本身中存储的信息限制每个文档的内容来重塑流中的每个文档
- `$replaceRoot` 用指定的嵌入文档替换文档
- `$replaceWith` 用指定的嵌入文档替换文档
- `$sample` 从输入中随机选择指定数量的文档
- `$set` 向文档添加新字段
- `$skip` 跳过前 n 个文档，其中 n 是指定的跳过编号，并将其余未修改的文档传递给管道
- `$sort` 按指定的排序键重新排序文档
- `$sortByCount` 根据指定表达式的值对传入文档进行分组，然后计算每个不同组中的文档计数
- `$unionWith` 执行两个集合的并集
- `$unset` 从文档中移除/排除字段
- `$unwind` 解析输入文档中的数组字段，为每个元素输出一个文档

3、变量

`$$NOW` 当前时间
`$$CLUSTER_TIME` 当前时间戳值
`$$ROOT` 引用根文档
`$$CURRENT` 引用字段路径的开始
`$$REMOVE` 允许有条件地排除字段
`$$DESCEND` 
`$$PRUNE`
`$$KEEP`

`new Date("01/05/2020")` 日期

4、表达式

`{ <operator>: [ <argument1>, <argument2> ... ] }`
`{ <operator>: <argument> }`

- 算数表达式运算符
- 数组表达式运算符
- 布尔表达式运算符
- 比较表达式运算符
- 条件表达式运算符
- 自定义聚合表达式运算符
- 数据大小表达式运算符
- 日期表达式运算符
- 文字表达式运算符
- 对象表达式运算符
- 集合表达式运算符
- 字符串表达式运算符
- 文本表达式运算符
- 角度表达式运算符
- 累加器($group)
- 累加器($project 和$addFields)
- 变量表达式运算符

5、sql到聚合

[SQL to Aggregation Mapping Chart — MongoDB Manual](https://www.mongodb.com/docs/manual/reference/sql-aggregation-comparison/)

|SQL 术语，函数和概念|Mongo聚合命令|
|---|---|
|WHERE|$match|
|GROUP BY|$group|
|HAVING|$match|
|SELECT|$project|
|ORDER BY|$sort|
|LIMIT|$limit|
|SUM()|$sum|
|COUNT()|$sum|
|join|$lookup|
|SELECT INTO NEW_TABLE|$out|
|MERGE INTO TABLE|$merge|

示例：查询user集合，并使用role_name字段从role集合查到角色id

```
db.user.aggregate([
  {
    $match: {
      username: "heyc"
    }
  },
  {
    $lookup: {
      from: "role",
      localField: "role_name",
      foreignField: "role_name",
      as: "role_info"
    }
  },
  {
    $unwind: "$role_info"
  },
  {
    $addFields: {
      "role_id": "$role_info._id"
    }
  },
  {
    $project: {
      "role_info": 0
    }
  }
])
```

### 1.2.9. 游标操作

```
cursor.hasNext() 
cursor.next() 
cursor.toArray() 
cursor.forEach()

cursor.map() 
cursor.objsLeftInBatch() 
cursor.itcount() 
cursor.pretty()
```

