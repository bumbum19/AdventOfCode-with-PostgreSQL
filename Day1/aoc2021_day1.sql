 
CREATE EXTENSION file_fdw;
 
CREATE SERVER aoc2021 foreign data wrapper file_fdw;
 
 
 
CREATE FOREIGN TABLE aoc2021_day1 (depth INT)
SERVER aoc2021 options(filename 'D:\aoc2021.day1.input');
 
WITH cte AS
(SELECT depth, LAG(depth) OVER () AS prev_depth FROM aoc2021_day1 )
 
SELECT 
SUM(CASE WHEN depth > prev_depth THEN 1 END) 
FROM cte