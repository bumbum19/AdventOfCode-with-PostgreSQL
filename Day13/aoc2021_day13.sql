CREATE FOREIGN TABLE aoc2021_day13 (x text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day13.input');
 
 
 
 
CREATE TEMPORARY TABLE  paper  (
id  SERIAL,
x  INT,
y INT
);

INSERT INTO paper(x,y)
SELECT 
SPLIT_PART(x,',',1)::INT,
-1*SPLIT_PART(x,',',2)::INT
FROM aoc2021_day13
WHERE x NOT LIKE '%f%' AND x != '';





CREATE TEMPORARY TABLE  folding  (
id  SERIAL,
direction  text,
pos INT
);

INSERT INTO folding (direction, pos)
SELECT 
CASE WHEN x LIKE '%x%' THEN 'vertical' ELSE 'horizontal' END, 
CASE WHEN x LIKE '%x%' THEN SPLIT_PART(x,'=',2)::INT ELSE -1*SPLIT_PART(x,'=',2)::INT END
FROM aoc2021_day13
WHERE x  LIKE '%f%' AND x != '';


-- Part 1


WITH t AS
(
SELECT  DISTINCT
CASE WHEN direction = 'vertical' THEN 
	CASE WHEN x < pos THEN x ELSE  x - 2*(x - pos) END
	ELSE x END AS x,
CASE WHEN direction = 'horizontal' THEN 
	CASE WHEN y > pos THEN y ELSE  y - 2*(y - pos) END
	ELSE y END AS y
FROM paper CROSS JOIN folding 
WHERE folding.id = 1 
)

SELECT COUNT(*) FROM t;







WITH RECURSIVE t(x, y, step) AS 
(

SELECT x,y, 0 FROM paper

UNION

SELECT 
CASE WHEN direction = 'vertical' THEN 
	CASE WHEN x < pos THEN x ELSE  x - 2*(x - pos) END
	ELSE x END,
CASE WHEN direction = 'horizontal' THEN 
	CASE WHEN y > pos THEN y ELSE  y - 2*(y - pos) END
	ELSE y END,
step + 1
FROM t JOIN folding ON step+1 = id
WHERE CASE WHEN direction = 'vertical' THEN x != pos ELSE y != pos END
),


t2 AS 

(SELECT * FROM t WHERE step = (SELECT MAX(id) FROM folding)),






t3 AS 
(
SELECT x,y, CASE WHEN step ISNULL THEN '.' ELSE '#' END AS dot
FROM GENERATE_SERIES((SELECT MIN(x) FROM t2), (SELECT MAX(x) FROM t2))  AS s1(x) 
CROSS JOIN GENERATE_SERIES((SELECT MIN(y) FROM t2 )  , (SELECT MAX(y) FROM t2)) AS s2(y) 
NATURAL LEFT JOIN t2
)


SELECT y, STRING_AGG(dot,'') FROM t3 GROUP BY y ORDER BY y DESC;


























