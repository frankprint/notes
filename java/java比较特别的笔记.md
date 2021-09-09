## java中，参数后面跟三个点(...)的含义

参考地址 ：

https://blog.csdn.net/linjpg/article/details/93999924





## java 关于::引用中使用泛型约束泛型类型



people() 返回一个stream实现流

```java
Map<Integer, Person> idToPersons = people().collect(Collectors.toMap(Person::getId, Function.identity(),
				(existingValue,newValue) -> {throw new IllegalStateException(); },
				TreeMap<Integer,Person>::new));

```

TreeMap<Integer,Person>::new 表示引入一个约束的泛型来实例化这个map



