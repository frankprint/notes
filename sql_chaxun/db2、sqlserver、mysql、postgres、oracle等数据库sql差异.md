# db2、sqlserver、mysql、postgres、oracle等数据库操作不通的方法





## 1.测量长度差异、以及截取字符串长度

sqlserver

```sql
SELECT
	SUBSTRING(e1.ENAME, e2.id, 1)
FROM
	( SELECT ENAME FROM EMP t1 WHERE t1.ENAME = 'KING' ) e1,(
	SELECT
		id 
	FROM
		T10 
	) e2 
WHERE
	e2.id <= len( e1.ENAME ) 
	AND e1.ENAME = 'KING'
```



其他



```sql
SELECT
	substr( e1.ENAME, e2.id, 1 ) 
FROM
	( SELECT ENAME FROM EMP t1 WHERE t1.ENAME = 'KING' ) e1,(
	SELECT
		id 
	FROM
		T10 
	) e2 
WHERE
	e2.id <= LENGTH( e1.ENAME ) 
	AND e1.ENAME = 'KING'
```







## 2.连接符的差异

适用于、oracle、 postgres、db2

```sql
	select ENAME||' 的工作是 '||JOB from EMP
	
```



mysql、sqlserver

```sql
	select CONCAT(ENAME,' 的工作是 ',JOB)  from EMP
```



sqlserver

```sql
	select ENAME + ' 的工作是 ' + JOB from EMP
```



## 3.限制返回的行数



DB2

```sql

SELECT * FROM EMP FETCH FIRST 5 ROWS ONLY
```





Mysql、postgres

```sql
select * from EMP limit 5
```



Oracle

```sql
select * from emp where ROWNUM <= 5		
```



Sqlserver

```sql
select top 5 * from emp
```













