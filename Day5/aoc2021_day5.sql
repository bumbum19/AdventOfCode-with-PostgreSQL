

CREATE FOREIGN TABLE aoc2021_day5 (a text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day5.input');
 



CREATE TEMPORARY TABLE  hydrothermal  (
  x1  INT,
  y1  INT,
  x2  INT,
  y2  INT,
  PRIMARY KEY (x1,y1,x2,y2)
  
);







INSERT INTO hydrothermal
SELECT 
SPLIT_PART(REPLACE(a,' -> ', ','),',',1)::INT,
SPLIT_PART(REPLACE(a,' -> ', ','),',',2)::INT,
SPLIT_PART(REPLACE(a,' -> ', ','),',',3)::INT,
SPLIT_PART(REPLACE(a,' -> ', ','),',',4)::INT 
FROM aoc2021_day5;


-- Part 1


WITH grid AS NOT MATERIALIZED (
    SELECT x,y
FROM GENERATE_SERIES(0,999) AS x CROSS JOIN GENERATE_SERIES(0,999) AS y
),


hydrothermal_vert AS

(SELECT x1, y1, y2 FROM   hydrothermal WHERE 
x1 = x2 ),


hydrothermal_horiz  AS
(SELECT y1, x1, x2  FROM   hydrothermal WHERE 
y1 = y2 ),

cte AS 
(
SELECT x,y
FROM grid 
JOIN hydrothermal_vert ON 
 ( y  >=y1 AND y <= y2 OR  y  >=y2 AND y <= y1 )  AND x = x1  
UNION ALL
SELECT x,y
FROM grid 
JOIN hydrothermal_horiz ON 
 ( x  >=x1 AND x <= x2 OR  x  >=x2 AND x <= x1 )  AND y = y1),
 
cte2 AS 
(SELECT x,y FROM cte GROUP BY x,y HAVING COUNT(*) >= 2)

SELECT COUNT(*) FROM cte2;

-- Solution: 4421

-- Part 2

-- Query may need about 10 seconds!!!


WITH grid AS NOT MATERIALIZED (
    SELECT x,y
FROM GENERATE_SERIES(0,999) AS x CROSS JOIN GENERATE_SERIES(0,999) AS y
),


hydrothermal_vert AS

(SELECT x1, y1, y2 FROM   hydrothermal WHERE 
x1 = x2 ),

hydrothermal_horiz  AS
(SELECT y1, x1, x2  FROM   hydrothermal WHERE 
y1 = y2 ),

hydrothermal_diag1 AS
(SELECT  x1, y1, x2, y2 FROM hydrothermal WHERE 
x1 - x2 = y1 - y2 
 ),
 
hydrothermal_diag2 AS

(SELECT  x1, y1, x2, y2 FROM hydrothermal WHERE 
 x1 - x2 = -(y1 - y2) 
 ),

cte AS 
(SELECT x,y
FROM grid 
JOIN hydrothermal_vert ON 
 ( y  >=y1 AND y <= y2 OR  y  >=y2 AND y <= y1 )  AND x = x1  

 UNION ALL

SELECT x,y
FROM grid 
JOIN hydrothermal_horiz ON 
 ( x  >=x1 AND x <= x2 OR  x  >=x2 AND x <= x1 )  AND y = y1
 
 UNION ALL

 SELECT x,y
FROM grid 
JOIN hydrothermal_diag1 ON 
 ( x  >=x1 AND x <= x2 OR  x  >=x2 AND x <= x1 )   AND (x - x1 = y - y1)
 
 UNION ALL

SELECT x,y
FROM grid 
JOIN hydrothermal_diag2 ON 
 ( x  >=x1 AND x <= x2 OR  x  >=x2 AND x <= x1 )   AND (x - x1 = -(y - y1))
 ),
 
cte2 AS 
(SELECT x,y FROM cte GROUP BY x,y HAVING COUNT(*) >= 2)

SELECT COUNT(*) FROM cte2;


