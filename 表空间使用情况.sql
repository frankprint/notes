SELECT SUM(bytes) / (1024 * 1024) AS free_space, tablespace_name
  FROM dba_free_space
 GROUP BY tablespace_name;
SELECT a.tablespace_name,
       a.bytes total,
       b.bytes used,
       c.bytes free,
       (b.bytes * 100) / a.bytes "% USED ",
       (c.bytes * 100) / a.bytes "% FREE "
  FROM sys.sm$ts_avail a, sys.sm$ts_used b, sys.sm$ts_free c
 WHERE a.tablespace_name = b.tablespace_name
   AND a.tablespace_name = c.tablespace_name;
