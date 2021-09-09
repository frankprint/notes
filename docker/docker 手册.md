# docker 手册



## 一、简介依赖和特性

### 1.特点

1. docker 只能允许在linux系统中。

### 2.依赖

docker以来的linux内核特性

1. namespaces 命名空间 （隔离）
2. Controlgroups(即 cgroups)控制组 （资源控制）

## 二、安装以及部署

## 1.安装前检查

  1.检查内核

```shell
[root@docker_swarm_master01 ~]# uname -a
Linux docker_swarm_master01 3.10.0-1127.18.2.el7.x86_64 #1 SMP Sun Jul 26 15:27:06 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

```

   2.检查存储驱动

```
[root@docker_swarm_master01 ~]# ls -l /sys/class/misc/device-mapper/
total 0
-r--r--r-- 1 root root 4096 Apr 12 17:40 dev
drwxr-xr-x 2 root root    0 Apr 12 17:40 power
lrwxrwxrwx 1 root root    0 Apr 12 17:40 subsystem -> ../../../../class/misc
-rw-r--r-- 1 root root 4096 Apr 12 17:40 uevent

```



### 2.安装部署

参考地址：

https://docs.docker.com/engine/install/centos/













