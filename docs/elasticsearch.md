[回到首页](../README.md)

# 1. 样例

说明

[TOC]

## 1.1. 标题1

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

## 1.2. 标题2

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