[回到首页](../README.md)

[TOC]

官方中文文档v2.x：[Elasticsearch: 权威指南 | Elastic]([序言 | Elasticsearch: 权威指南 | Elastic](https://www.elastic.co/guide/cn/elasticsearch/guide/current/foreword_id.html))

官方最新版本文档：[Elasticsearch Guide [8.9] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)

# 1. 基本使用

## 1.1. 文档元数据

三个元数据唯一标识一个文档：`_index`索引，`_type`类型，`_id`唯一标识

## 1.2. 查询方法

```
curl -i -X GET "url?args" -H "Content-Type: application/json" --data ""
```

请求方法可以是GET、PUT、POST、DELETE、HEAD。GET用于查询，PUT用于修改，POST用于新建，DELETE用于删除，HEAD用于判断是否存在。

不常见的是，es的GET请求可以接受请求体，此时请求体与url参数同时生效。

## 1.3. CRUD

```
# 查询一个文档
GET /website/blog/123?pretty
# 查询文档的部分字段
GET /website/blog/123?_source=title,text
# 不查询元数据
GET /website/blog/123/_source
# 查询多个文档
GET /_mget
{
   "docs" : [
      {
         "_index" : "website",
         "_type" :  "blog",
         "_id" :    2
      },
      {
         "_index" : "website",
         "_type" :  "pageviews",
         "_id" :    1,
         "_source": "views"
      }
   ]
}
GET /website/blog/_mget
{
   "ids" : [ "2", "1" ]
}

# 创建文档
POST /website/blog/
{
  "title": "My first blog entry",
  "text":  "I am starting to get the hang of this...",
  "date":  "2014/01/02"
}
# 指定id
PUT /website/blog/123?op_type=create
{}
PUT /website/blog/123/_create
{}

# 更新整个文档
PUT /website/blog/123
{
  "title": "My first blog entry",
  "text":  "I am starting to get the hang of this...",
  "date":  "2014/01/02"
}

# 更新部分文档
POST /website/blog/1/_update
{
   "doc" : {
      "tags" : [ "testing" ],
      "views": 0
   }
}
# 使用脚本更新
POST /website/blog/1/_update
{
   "script" : "ctx._source.tags+=new_tag",
   "params" : {
      "new_tag" : "search"
   }
}

# 删除文档
DELETE /website/blog/123

# 检查文档是否存在。200表示存在，404表示不存在
curl -i -XHEAD http://localhost:9200/website/blog/123

# 批量操作：delete\create\index\update，index表示创建或替换
POST /_bulk
{ "delete": { "_index": "website", "_type": "blog", "_id": "123" }} 
{ "create": { "_index": "website", "_type": "blog", "_id": "123" }}
{ "title":    "My first blog post" }
{ "index":  { "_index": "website", "_type": "blog" }}
{ "title":    "My second blog post" }
{ "update": { "_index": "website", "_type": "blog", "_id": "123", "_retry_on_conflict" : 3} }
{ "doc" : {"title" : "My updated blog post"} }

```

字符串类型的数字如何使用分组聚合

```
GET sales/_search
{
  "runtime_mappings": {
    "price.euros": {
      "type": "double",
      "script": {
        "source": """
          emit(doc['price'].value * params.conversion_rate)
        """,
        "params": {
          "conversion_rate": 0.835526591
        }
      }
    }
  },
  "aggs": {
    "price_ranges": {
      "range": {
        "field": "price.euros",
        "ranges": [
          { "to": 100 },
          { "from": 100, "to": 200 },
          { "from": 200 }
        ]
      }
    }
  }
}
```

```
GET index_name/_search
{
  "query": {
    "bool": {
      "must": {
        "script": {
          "script": {
            "inline": "Float.parseFloat(doc['Price.keyword'].value) >= 40 && Float.parseFloat(doc['Price.keyword'].value) <= 100",
            "lang": "painless"
          }
        }
      }
    }
  }
}
```

> 参考：
> 1、[Elasticsearch range query on number in string format - Stack Overflow](https://stackoverflow.com/questions/55374426/elasticsearch-range-query-on-number-in-string-format)
> 2、[Range aggregation | Elasticsearch Guide [8.8] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-aggregations-bucket-range-aggregation.html#_script)

## 1.4. 并发控制

es通过版本号来实现乐观并发控制，每次更新文档后文档的版本号加1，再修改或删除时带上版本号则es会校验当前文档版本号是否与请求的版本号匹配，匹配才能修改和删除，否则返回409

```
PUT /website/blog/1?version=1
{
  "title": "My first blog entry",
  "text":  "Starting to get the hang of this..."
}
```

## 1.5. 映射

索引中每个文档都有 _类型_ 。每种类型都有它自己的 _映射_ ，或者 _模式定义_

当你索引一个包含新域的文档—​之前未曾出现-- Elasticsearch 会使用 _动态映射_ ，通过JSON中基本数据类型，尝试猜测域类型。

### 1.5.1. 查看映射

取得索引 `gb` 中类型 `tweet` 的映射

```
GET /gb/_mapping/tweet
```

### 1.5.2. 自定义域映射

定义索引gb中类型tweet的映射，字段有tweet、date、name、user_id。

- type：类型
- index： 怎样索引字符串。analyzed 以全文索引这个域；not_analyzed 精确值索引；no 不索引，搜索不到
- analyzer：指定在搜索和索引时使用的分析器，默认为standard分析器

```
DELETE /gb

PUT /gb 
{
  "mappings": {
    "tweet" : {
      "properties" : {
        "tweet" : {
          "type" :    "string",
          "analyzer": "english"
        },
        "date" : {
          "type" :   "date"
        },
        "name" : {
          "type" :   "string"
        },
        "user_id" : {
          "type" :   "long"
        }
      }
    }
  }
}

PUT /gb/_mapping/tweet
{
  "properties" : {
    "tag" : {
      "type" :    "string",
      "index":    "not_analyzed"
    }
  }
}

# 测试映射
GET /gb/_analyze
{
  "field": "tag",
  "text": "Black-cats" 
}
```

### 1.5.3. 索引模板

[Index templates | Elasticsearch Guide [7.17] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/7.17/index-templates.html)

## 1.5. 聚合查询


## 1.6. 其他

在分布式系统中，对结果排序的成本随分页的深度成指数上升。这就是 web 搜索引擎对任何查询都不要返回超过 1000 个结果的原因。

> 参考：
> [分页 | Elasticsearch: 权威指南 | Elastic](https://www.elastic.co/guide/cn/elasticsearch/guide/current/pagination.html)

查看索引模板
```bash
curl -X GET "132.131.0.21:9200/_template/dlp-clipboard?pretty" -H ''
```

查看映射
```bash
curl -X GET "132.131.0.21:9200/dlp-clipboard-2023.08.10/_mapping/udp?pretty" -H ''
```

查看集群信息
```bash
curl -X GET "132.131.0.21:9200?pretty" -H ''
```

查询时排除某个索引

```
curl -X GET 'localhost:9200/*,-dlp-*/_search?pretty'
```