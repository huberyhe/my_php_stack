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

### 1.2.3. CRUD

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