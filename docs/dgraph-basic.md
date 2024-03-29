[回到首页](../README.md)

# 1. Dgraph基础

说明

[TOC]

## 1.1. 基本概念

## 1.2. 使用场景

### 1.2.1. 图数据库相对于关系数据库的优势

- 容易表示复杂关系
- 多跳查询效率高

> 参考：[美团图数据库平台建设及业务实践](https://tech.meituan.com/2021/04/01/nebula-graph-practice-in-meituan.html)

## 1.3. 查询工具

### 1.3.1. 代码，golang示例

```go
var err error

// 连接
conn, err := grpc.Dial(host.Address+":"+host.Port, grpc.WithInsecure())
if err != nil {
    db.Error = err
    return
}
Client = dgo.NewDgraphClient(api.NewDgraphClient(Conn))

// 查询
dql := ``
resp, err := Client.NewTxn().Query(context.Background(), dql)
fmt.Println(resp.Json)

// 突变
dql := ``
ctx := context.Background()
txn := Client.NewTxn()
defer txn.Discard(ctx)
_, err := txn.Mutate(ctx, &api.Mutation{
    SetNquads: []byte(dql),
    CommitNow: true,
})
txn.Commit(ctx)
```

### 1.3.2. curl

查看状态：

```
curl http://localhost:8080/health
```



查询：

```bash
curl "localhost:8080/query" --silent --request POST \
  --header "Content-Type: application/dql" \
  --data $'
{
 me(func: has(starring)) {
   name
  }
}
' | python -m json.tool | less
```



修改和新增数据：

```bash
curl "localhost:8080/mutate?commitNow=true" --silent --request POST \
 --header  "Content-Type: application/rdf" \
 --data $'
{
  set {
   _:luke <name> "Luke Skywalker" .
   _:luke <dgraph.type> "Person" .
   _:leia <name> "Princess Leia" .
   _:leia <dgraph.type> "Person" .
   _:han <name> "Han Solo" .
   _:han <dgraph.type> "Person" .
   _:lucas <name> "George Lucas" .
   _:lucas <dgraph.type> "Person" .
   _:irvin <name> "Irvin Kernshner" .
   _:irvin <dgraph.type> "Person" .
   _:richard <name> "Richard Marquand" .
   _:richard <dgraph.type> "Person" .

   _:sw1 <name> "Star Wars: Episode IV - A New Hope" .
   _:sw1 <release_date> "1977-05-25" .
   _:sw1 <revenue> "775000000" .
   _:sw1 <running_time> "121" .
   _:sw1 <starring> _:luke .
   _:sw1 <starring> _:leia .
   _:sw1 <starring> _:han .
   _:sw1 <director> _:lucas .
   _:sw1 <dgraph.type> "Film" .
  }
}
' | python -m json.tool | less

```

旧版：
```bash
curl "localhost:19191/mutate" --slient --request POST \
	--header "X-Dgraph-CommitNow: true" \
	--header "Content-Type: text/plain" \
	--data $'
{
	delete {
		<0xf4245> * * . 
	}
}
	'
```

### 1.3.3. 图形客户端 ratel

项目地址：[dgraph-io/ratel: Dgraph Data Visualizer and Cluster Manager (github.com)](https://github.com/dgraph-io/ratel)

## 1.4. DQL语法

官方文档：[Get Started - Quickstart Guide (dgraph.io)](https://dgraph.io/docs/get-started/)

### 1.4.1. 查询

#### 1.  基本示例

```dql
{
  me(func: eq(name@en, "Steven Spielberg")) @filter(has(director.film)) {
    name@en
    director.film @filter(allofterms(name@en, "jones indiana"))  {
      name@en
    }
  }
}
```

me：当前查询的名称

#### 2. 过滤

过滤需要字段类型有index，不同的index类型可以过滤的方式不同，常用的类型有`term/hash/fulltext/trigram`

- `uid(uids)` 过滤uid，uids可以是变量或者n个uid值
- `eq`, `ge`, `gt`, `le`, `lt`比较
- `allofterms(predicate, "space-separated term list")`包含所有字符
- `anyofterms(predicate, "space-separated term list")`包含任意一个字符
- `regexp(predicate, /regular-expression/)`正则判断
- `match(predicate, string, distance)`
- `alloftext(predicate, "space-separated text")`全文检索
- `between(predicate, startDateValue, endDateValue)`范围判断
- `has(predicate)`有字段值

#### 3. 排序

定义：`q(func: ..., orderasc: predicate1, orderdesc: predicate2)`

支持：`int`, `float`, `String`, `dateTime`, `default`

#### 4. 分页

定义：`predicate @filter(...) (first: M, offset: N) { ... }`

#### 5. 计数

定义：`count(predicate)`

#### 6. 分组

定义：`q(func: ...) @groupby(predicate) { min(...) }`

### 1.4.2. 新增

```dql
{
    set {
		<0x1> <td.relation.group_account> <0x27101> .
    }
}
```

### 1.4.3. 修改

如果是修改节点属性，直接set即可；如果是修改关系，需要先解除旧关系（delete），再绑定（set）

### 1.4.4. 删除

```dql
{
    delete {
		<0x1> <td.relation.group_account> <0x27101> .
		<0xf4245> * * . 
    }
}
```



## 1.5. 数据导出导入

1、rdf格式导出

```bash
curl localhost:8080/admin/export
```

2、json格式导出

```bash
curl 'localhost:8080/admin/export?format=json'
```

3、导入

仅开启zero服务（5080端口），并删除p和w文件夹

```bash
dgraph bulk -r goldendata.rdf -s goldendata.schema --map_shards=4 --reduce_shards=1 --zero=localhost:5080
```

rdf是数据，schema定义了导入的数据类型

## 1.6. 注意事项

1、[排序](https://dgraph.io/docs/query-language/sorting/)后默认只能查1000条数据，first默认值为1000

## 1.7. zero与alpha

Dgraph Zero controls the Dgraph cluster, assigns servers to a group, and re-balances data between server groups.
Dgraph Alpha hosts predicates and indexes. Predicates are either the properties associated with a node or the relationship between two nodes. Indexes are the tokenizers that can be associated with the predicates to enable filtering using appropriate functions.
Ratel serves the UI to run queries, mutations & altering schema.

zero: grpc占用5080端口，http占用6080端口
alpha: http占用8080端口，grpc占用9080端口，worker grpc占用内部7080端口

> 参考：[https://dgraph.io/docs/deploy/ports-usage/](https://dgraph.io/docs/deploy/ports-usage/)

## 1.8. 查看状态

```bash
curl localhost:8080/health
```

## 1.9. 数据目录

- zw：zero存储WAL文件的目录
- p：alpha存储`posting lists`的目录
- w：alpha存储`raft write-ahead logs`的目录

> 参考：
>
> 1、[Expand Predicates in DQL - Query language (dgraph.io)](https://dgraph.io/docs/query-language/expand-predicates/)
>
> 2、[Dgraph QL 入门](https://juejin.cn/post/6844903598581612557)
>
> 3、[dgraph实现基本操作](https://www.cnblogs.com/wangha/p/10467915.html)
>
> 4、[Dgraph的基本使用经典教程（数据导入，导出，删除，查询等）)](https://codeleading.com/article/41964542945/)

