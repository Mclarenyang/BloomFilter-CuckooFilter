# BloomFilter-CuckooFilter
基于 Swift 语言的 BloomFIlter 及 CuckooFilter，两个过滤器的具体描述见[BloomFIlter & CuckooFilter学习笔记](https://www.jianshu.com/p/7f9d74b34e76)。

## 性能测试数据
1.BloomFilter
```
添加平均：2.18982219696045ms/element
判断平均：<=1.45994186401367ms/element
```
2.CuckooFilter
```
//三次扩容情况下
添加平均：0.439960956573486ms/element
判断平均：<=0.233228206634521ms/element
删除平均：0.214576721191406ms/element
```
