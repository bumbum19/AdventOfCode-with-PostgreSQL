 
CREATE EXTENSION file_fdw;
 
CREATE SERVER aoc2021 FOREIGN  DATA wrapper file_fdw;
 
 
 
CREATE FOREIGN TABLE aoc2021_day1 (depth INT)
SERVER aoc2021 options(filename 'D:\aoc2021.day1.input');

 
 
 
 
 CREATE TEMPORARY TABLE sea_floor (
  id  SERIAL,
  depth  INT
  
);


INSERT INTO sea_floor(depth)
SELECT depth FROM aoc2021_day1;

-- Part 1

WITH cte AS
(SELECT depth, LAG(depth) OVER (ORDER BY id) AS prev_depth FROM sea_floor )
 
SELECT 
SUM(CASE WHEN depth > prev_depth THEN 1 END) 
FROM cte;


-- Part 2

WITH cte AS

(SELECT SUM(depth) OVER (ORDER BY id RANGE BETWEEN 2 PRECEDING AND CURRENT ROW  ) AS depth FROM sea_floor OFFSET 2),

cte2 AS
(SELECT depth, LAG(depth) OVER () AS prev_depth FROM cte )
 
SELECT 
SUM(CASE WHEN depth > prev_depth THEN 1 END) 
FROM cte2;