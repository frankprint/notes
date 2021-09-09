sqlserver、mysql、postgres、oracle、db2不通的语法



# 1.不同的数据库连接符

> 对于连接符不通的数据库有这不通的写法

针对于oracle、db2

```sql
SELECT
aa.ENAME || ' ' || aa.DEPTNO  as data
FROM EMP aa


```

针对于mysql、postgres、sqlserver

```sql
SELECT
	CONCAT( a.ENAME, ' ', a.DEPTNO ) AS DATA 
FROM
	EMP a
```



# 2.截取字符串与取字符串的长度

对于除sqlserver的绝大多数数据截取字符串长度、获取字符串长度可以这么写

对于mysql、oracle、postgres、db2  。  SUBSTR用于截取字符串 LENGTH用于获取长度。

```sql

select * from EMP  order by SUBSTR(EMP.JOB,LENGTH(EMP.JOB) -2)

```

对于sqlserver。SUBSTRING用于截取字符串 要求需要三个参数，len用于获取字符串的长度。

```sql

select * from EMP  order by SUBSTRING(EMP.JOB,len(EMP.JOB) -2,2)

```



# 3.TRANSLATE 的不同的用法

首先，对于mysql、sqlserver 来说，不支持该函数。

针对于postgres、oracle来说:

```sql
SELECT
	* 
FROM
	V ee 
ORDER BY
	REPLACE(ee.DATA,REPLACE ( TRANSLATE( ee.DATA, '0123456789', '##########' ), '#', '' ),  '') asc

```



对于db2来说，使用的TRANSLATE的参数顺序不通。（这里的作用是把数据中的0123456789替换为'#'）

```sql
SELECT
	* 
FROM
	V 
ORDER BY
	REPLACE ( DATA, REPLACE ( TRANSLATE ( DATA, '##########', '0123456789' ), '#', '' ), '' )
```



# 4.oracle 9i以后 对于null值排序

绝大多数数据库包括 oracle支持下列语法

```sql
SELECT
CASE	
	WHEN
		aa.COMM IS NOT NULL THEN
			aa.COMM ELSE 0 
			END AS wenjian 
	FROM
		EMP aa 
	ORDER BY
		wenjian
```



对于oracle 9i版本以后可以使用下列语法来决定null值是否排在前面



```sql
	select * from EMP ORDER BY EMP.COMM nulls first
```

```sql
	select * from EMP ORDER BY EMP.COMM nulls last
```



5.对于限制多少行返回不同数据库的用法。

对于mysql、postgres数据库来说 使用 limit 来限定返回的行，还有多种用途

```sql

SELECT * from (
SELECT ENAME,DEPTNO FROM EMP LIMIT 1
) cc

```



对于oracle数据库来说 使用 where ROWNUM  < 2 来返回一行数据 不可以使用 = 来返回固定的第一行，具体请参考说明。

```
SELECT * from (
SELECT ENAME,DEPTNO FROM EMP  where ROWNUM < 2
) cc
```



对于db2的数据库来说 。



```sql
SELECT * FROM EMP FETCH FIRST 5 ROWS ONLY
```



对于sqlserver来说需要这样。

```sql
select top 5 * from EMP
```







