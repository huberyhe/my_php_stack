[回到首页](../README.md)

# 1. zookeeper

说明

[TOC]

## 1.1. 使用场景

Apache ZooKeeper 是一个开源的分布式协调服务，旨在为分布式应用程序提供高效、可靠的协调服务。ZooKeeper 提供了一个简单的、高性能的分布式环境，可以用于解决各种分布式系统中的一致性和协调问题。

## 1.2. 功能

1. **命名服务：**

   ZooKeeper 提供了一个分布式的命名空间，允许客户端在其中注册、查找和管理数据节点（znode），类似于分布式文件系统。

2. **配置管理：**

   ZooKeeper 可以用作配置信息的中心存储，允许应用程序动态地读取和更新配置信息。它提供了监听机制，可以实时通知客户端配置的变化。

3. **分布式锁：**

   ZooKeeper 提供了基于分布式锁的机制，允许多个客户端在分布式环境中同步访问共享资源。通过 ZooKeeper 的临时顺序节点和 Watches 机制，可以实现高效的分布式锁。

4. **分布式队列：**

   ZooKeeper 可以用作分布式队列的实现，允许多个客户端在队列中插入和删除数据，并且可以通过 Watches 机制实现队列数据的实时通知。

5. **分布式协调：**

   ZooKeeper 提供了一系列的原语（如 barrier、semaphore 等），可以用于在分布式环境中实现复杂的协调和同步操作。

6. **高可用性：**

   ZooKeeper 使用多副本模式存储数据，并且自动选举 Leader 节点，保证了系统的高可用性和可靠性。