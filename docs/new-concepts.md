[回到首页](../README.md)

# 1. 新概念

说明

[TOC]

## 1.1. 云原生

### 1.1.1. CAP定理：

- 一致性
- 可用性
- 分区容错

## 1.2. 标题2

[补偿事务模式](https://docs.microsoft.com/zh-cn/azure/architecture/patterns/compensating-transaction)：撤消一系列步骤执行的工作，当一个或多个步骤失败时，这些步骤会共同定义最终一致的操作。 遵循最终一致性模型的操作常见于实现复杂业务流程和工作流的云托管应用程序中。

[事件溯源模式](https://docs.microsoft.com/zh-cn/azure/architecture/patterns/event-sourcing)：使用只追加存储来记录对数据采取的完整系列操作，而不是仅存储域中数据的当前状态。 该存储可作为记录系统，可用于具体化域对象。 这样一来，无需同步数据模型和业务域，从而简化复杂域中的任务，同时可提高性能、可扩展性和响应能力。 它还可提供事务数据一致性并保留可启用补偿操作的完整审核记录和历史记录。

[Saga 分布式事务模式](https://docs.microsoft.com/zh-cn/azure/architecture/reference-architectures/saga/saga)：Saga 设计模式是一种在分布式事务方案中跨微服务管理数据一致性的方法。 saga 是一系列事务，用于更新每个服务并发布消息或事件以触发下一个事务步骤。 如果步骤失败，则 saga 将执行补偿事务来应对上述事务。

[CQRS 模式](https://docs.microsoft.com/zh-cn/azure/architecture/patterns/cqrs)：CQRS 是“命令和查询责任分离”的英文缩写，它是一种将数据存储的读取操作和更新操作分离的模式。 在应用程序中实现 CQRS 可以最大限度地提高其性能、可缩放性和安全性。 通过迁移到 CQRS 而创建的灵活性使系统能够随着时间的推移而更好地发展，并防止更新命令在域级别导致合并冲突。
