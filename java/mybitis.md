Mybits遇到的一些问题。





## 常见问题



### 重定义绑定的类的别名导致填入的返回值找不到。

> 结论： 所有映射类，要不就只有全称，要不就只有别名，不能同时使用全称和别名



以下是实现某接口的xml实例对象

这是定义的接口

```java
package com.zyj.testmybits.exector;

import com.zyj.testmybits.table.User;
import org.apache.ibatis.annotations.Param;


import java.util.List;
import java.util.Map;

public interface UserDao {
    List<User> getUserList();

    List<User> QueryUserList(Integer id);

    int addUser(User user);

    int UpdateUser(User user);

    int DeleteUser(Integer id);

    //添加map的user
    int addUser2(Map<String,Object> user);

    /**
     *  根据map来查询map
     * @param user 用户信息
     * @return
     */
    List<User> searchMapUser(Map<String,Integer> user);

    /**
     *  根据map信息来修改user
     * @param user
     * @return
     */
    int updateMapUser(Map<String,Object> user);


    int DeleteMapUser(Map<String,Object> user);

    List<User> searchMapLike(String userName);

    List<User> searchMapLike2(String userName);

    List<User> listUserLimit();


}

```



<!--注意在这里已经把user定义为 DiyResult -->

```xaml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.zyj.testmybits.exector.UserDao">

    <!--注意在这里已经把user定义为 DiyResult -->
    <resultMap id="DiyResult" type="user">
<!--        <result  column="test" property="password" />-->
    </resultMap>
    <select id="getUserList" resultType="user">
        select * from mybatis.user
    </select>

    <select id="QueryUserList" resultType="user" parameterType="java.lang.Integer">
        select * from mybatis.user where id = #{id}
    </select>

    <insert id="addUser" parameterType="user">
        insert  into mybatis.user(id,name,pwd) value ( #{id} , #{name} , #{pwd} )
    </insert>

    <update id="UpdateUser" parameterType="user" >
        update mybatis.user set name = #{name} , pwd = #{pwd}   where id = #{id} ;
    </update>

    <!--测试-->
    <delete id="DeleteUser" parameterType="java.lang.Integer" >
        delete from mybatis.user where id = #{id}
    </delete>

    <insert id="addUser2" parameterType="java.util.Map" >
        insert into mybatis.user(id,name,pwd) value  ( #{id} , #{name} , #{pwd} )
    </insert>


    <select id="searchMapUser" parameterType="java.util.Map" resultType="user">
        select * from mybatis.user where id = #{id}
    </select>


    <update id="updateMapUser" parameterType="java.util.Map" >
        update mybatis.user set name = #{name} where id = #{id} ;
    </update>

    <delete id="DeleteMapUser" parameterType="java.util.Map" >
        delete from mybatis.user where id = #{id}
    </delete>

    <select id="searchMapLike" parameterType="java.lang.String" resultType="user">
        select * from mybatis.user where name like "%"#{userName}"%"
    </select>

    <select id="searchMapLike2" parameterType="java.lang.String" resultMap="DiyResult">
        select * from mybatis.user where name like #{userName}
    </select>

    <select id="listUserLimit"  resultMap="user">
        select * from mybatis.user
    </select>



</mapper>
```



就会出现以下报错。



```java
org.apache.ibatis.builder.IncompleteElementException: Could not find result map 'com.zyj.testmybits.exector.UserDao.user' referenced from 'com.zyj.testmybits.exector.UserDao.listUserLimit'
	at org.apache.ibatis.builder.MapperBuilderAssistant.getStatementResultMaps(MapperBuilderAssistant.java:341)
	at org.apache.ibatis.builder.MapperBuilderAssistant.addMappedStatement(MapperBuilderAssistant.java:285)
	at org.apache.ibatis.builder.xml.XMLStatementBuilder.parseStatementNode(XMLStatementBuilder.java:113)
	at org.apache.ibatis.session.Configuration.lambda$buildAllStatements$2(Configuration.java:816)
	at java.util.Collection.removeIf(Collection.java:414)
	at org.apache.ibatis.session.Configuration.buildAllStatements(Configuration.java:815)
	at org.apache.ibatis.session.Configuration.hasStatement(Configuration.java:792)
	at org.apache.ibatis.session.Configuration.hasStatement(Configuration.java:787)
	at org.apache.ibatis.binding.MapperMethod$SqlCommand.resolveMappedStatement(MapperMethod.java:257)
	at org.apache.ibatis.binding.MapperMethod$SqlCommand.<init>(MapperMethod.java:227)
	at org.apache.ibatis.binding.MapperMethod.<init>(MapperMethod.java:53)
	at org.apache.ibatis.binding.MapperProxy.lambda$cachedMapperMethod$0(MapperProxy.java:61)
	at java.util.concurrent.ConcurrentHashMap.computeIfAbsent(ConcurrentHashMap.java:1660)
	at org.apache.ibatis.binding.MapperProxy.cachedMapperMethod(MapperProxy.java:61)
	at org.apache.ibatis.binding.MapperProxy.invoke(MapperProxy.java:56)
	at com.sun.proxy.$Proxy6.listUserLimit(Unknown Source)
	at com.zyj.testmybits.exector.UserDaoTest.limitMapUser(UserDaoTest.java:187)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:498)
	at org.junit.runners.model.FrameworkMethod$1.runReflectiveCall(FrameworkMethod.java:50)
	at org.junit.internal.runners.model.ReflectiveCallable.run(ReflectiveCallable.java:12)
	at org.junit.runners.model.FrameworkMethod.invokeExplosively(FrameworkMethod.java:47)
	at org.junit.internal.runners.statements.InvokeMethod.evaluate(InvokeMethod.java:17)
	at org.junit.runners.ParentRunner.runLeaf(ParentRunner.java:325)
	at org.junit.runners.BlockJUnit4ClassRunner.runChild(BlockJUnit4ClassRunner.java:78)
	at org.junit.runners.BlockJUnit4ClassRunner.runChild(BlockJUnit4ClassRunner.java:57)
	at org.junit.runners.ParentRunner$3.run(ParentRunner.java:290)
	at org.junit.runners.ParentRunner$1.schedule(ParentRunner.java:71)
	at org.junit.runners.ParentRunner.runChildren(ParentRunner.java:288)
	at org.junit.runners.ParentRunner.access$000(ParentRunner.java:58)
	at org.junit.runners.ParentRunner$2.evaluate(ParentRunner.java:268)
	at org.junit.runners.ParentRunner.run(ParentRunner.java:363)
	at org.junit.runner.JUnitCore.run(JUnitCore.java:137)
	at com.intellij.junit4.JUnit4IdeaTestRunner.startRunnerWithArgs(JUnit4IdeaTestRunner.java:68)
	at com.intellij.rt.execution.junit.IdeaTestRunner$Repeater.startRunnerWithArgs(IdeaTestRunner.java:47)
	at com.intellij.rt.execution.junit.JUnitStarter.prepareStreamsAndStart(JUnitStarter.java:242)
	at com.intellij.rt.execution.junit.JUnitStarter.main(JUnitStarter.java:70)
Caused by: java.lang.IllegalArgumentException: Result Maps collection does not contain value for com.zyj.testmybits.exector.UserDao.user
	at org.apache.ibatis.session.Configuration$StrictMap.get(Configuration.java:964)
	at org.apache.ibatis.session.Configuration.getResultMap(Configuration.java:674)
	at org.apache.ibatis.builder.MapperBuilderAssistant.getStatementResultMaps(MapperBuilderAssistant.java:339)
	... 38 more

```



### Mybatis (ParameterType) 如何传递多个不同类型的参数





