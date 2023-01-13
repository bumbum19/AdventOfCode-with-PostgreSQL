SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2021_day9 (a text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day9.input');



 
 CREATE TEMPORARY TABLE  lava_tubes  (
  id  SERIAL,
  heights  INT[]
  );
  
  
INSERT INTO lava_tubes(heights)
SELECT STRING_TO_ARRAY(a, NULL)::INT[] FROM aoc2021_day9;






	
WITH t AS 

(
SELECT 
id AS x,
	   y,
	height
FROM lava_tubes 
CROSS JOIN UNNEST(heights) WITH ORDINALITY AS t (height, y)
),


t2 AS
(
SELECT *, 
LAG(height) OVER (PARTITION BY x ORDER BY y) AS west,
LEAD(height) OVER (PARTITION BY x ORDER BY y) AS east,
LAG(height) OVER (PARTITION BY y ORDER BY x) AS north,
LEAD(height) OVER (PARTITION BY y ORDER BY x) AS south

FROM t
),


t3 AS 

(
SELECT *, 
LAG(north) OVER (PARTITION BY x ORDER BY y) AS north_west,
LEAD(north) OVER (PARTITION BY x ORDER BY y) AS north_east,
LAG(south) OVER (PARTITION BY x ORDER BY y) AS south_west,
LEAD(south) OVER (PARTITION BY x ORDER BY y) AS south_east

FROM t2
)

SELECT MAX(height) AS answer FROM t3  
WHERE CASE  WHEN LEAST(east, west, north, south,north_east, north_west, south_east, south_west) >= height
THEN TRUE ELSE FALSE END  ;




-- Part 2





WITH RECURSIVE cte AS 

(
SELECT 
id AS x,
	   y,
	height
FROM lava_tubes 
CROSS JOIN UNNEST(heights) WITH ORDINALITY AS q(height, y)
),


cte2 AS
(
SELECT *, 
LAG(height) OVER (PARTITION BY x ORDER BY y) AS west,
LEAD(height) OVER (PARTITION BY x ORDER BY y) AS east,
LAG(height) OVER (PARTITION BY y ORDER BY x) AS north,
LEAD(height) OVER (PARTITION BY y ORDER BY x) AS south

FROM cte
),


t AS 

(
SELECT *, 
LAG(north) OVER (PARTITION BY x ORDER BY y) AS north_west,
LEAD(north) OVER (PARTITION BY x ORDER BY y) AS north_east,
LAG(south) OVER (PARTITION BY x ORDER BY y) AS south_west,
LEAD(south) OVER (PARTITION BY x ORDER BY y) AS south_east
FROM cte2
),

s (x, y, height, basin) AS 
(
SELECT x,y, height, ROW_NUMBER() OVER () 
 FROM t WHERE  CASE  
WHEN LEAST(east, west, north, south,north_east, north_west, south_east, south_west) >= height
THEN TRUE ELSE FALSE END

UNION 

SELECT cte.x,cte.y, cte.height, basin
FROM s JOIN cte 
ON  cte.x = s.x AND cte.y IN (s.y - 1, s.y + 1 )
OR  cte.y = s.y AND cte.x IN (s.x - 1, s.x + 1 )
WHERE s.height <= cte.height
AND cte.height < 9

),

h AS 

(

SELECT COUNT(*) AS cnt FROM s  GROUP BY basin ORDER BY cnt DESC LIMIT 3)


SELECT ROUND(EXP(SUM(LN(cnt)))::NUMERIC,0) FROM h;




