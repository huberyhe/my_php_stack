[回到首页](../README.md)

# 1. Dgraph基础

说明

[TOC]

## 1.1. 基本概念

## 1.2. 使用场景

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



### 1.3.3. 图形客户端 ratel

项目地址：[dgraph-io/ratel: Dgraph Data Visualizer and Cluster Manager (github.com)](https://github.com/dgraph-io/ratel)

## 1.4. DQL语法

### 1.4.1. 查询

### 1.4.2. 新增

### 1.4.3. 修改

### 1.4.4. 删除

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



> 参考：
>
> 1、[Expand Predicates in DQL - Query language (dgraph.io)](https://dgraph.io/docs/query-language/expand-predicates/)
>
> 2、[Dgraph QL 入门](https://juejin.cn/post/6844903598581612557)
>
> 3、[dgraph实现基本操作](https://www.cnblogs.com/wangha/p/10467915.html)
>
> 4、[Dgraph的基本使用经典教程（数据导入，导出，删除，查询等）)](https://codeleading.com/article/41964542945/)

