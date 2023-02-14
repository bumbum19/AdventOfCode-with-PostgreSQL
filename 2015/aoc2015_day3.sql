CREATE FOREIGN TABLE aoc2015_day3 (x TEXT)
SERVER aoc2015 options(filename 'D:\aoc2015.day3.input');




CREATE  TEMPORARY TABLE instructions
(
	pos SERIAL,
	direction CHAR
	
	
);


INSERT INTO instructions(direction)
SELECT STRING_TO_TABLE(x, NULL) FROM aoc2015_day3;




-- Part 1


WITH cte AS 
(
	SELECT 
	pos,
	SUM(CASE WHEN direction =  '>' THEN 1 WHEN direction =  '<' THEN -1 ELSE 0 END) OVER w AS x,
	SUM(CASE WHEN direction =  '^' THEN 1 WHEN direction =  'v' THEN -1 ELSE 0 END) OVER w AS y
	FROM instructions
	WINDOW w AS (ORDER BY pos)
),

cte2 AS 
(

SELECT DISTINCT ON (x,y) x,y FROM cte 
UNION 
VALUES (0,0)


)

SELECT COUNT(*) FROM cte2;





-- Part 2


WITH santa AS 
(
	SELECT 
	pos,
	SUM(CASE WHEN direction =  '>' THEN 1 WHEN direction =  '<' THEN -1 ELSE 0 END) OVER w AS x,
	SUM(CASE WHEN direction =  '^' THEN 1 WHEN direction =  'v' THEN -1 ELSE 0 END) OVER w AS y
	FROM instructions
	WHERE MOD(pos, 2) = 1
	WINDOW w AS (ORDER BY pos)
),


robo_santa AS 
(
	SELECT 
	pos,
	SUM(CASE WHEN direction =  '>' THEN 1 WHEN direction =  '<' THEN -1 ELSE 0 END) OVER w AS x,
	SUM(CASE WHEN direction =  '^' THEN 1 WHEN direction =  'v' THEN -1 ELSE 0 END) OVER w AS y
	FROM instructions  
	WHERE MOD(pos, 2) = 0
	WINDOW w AS (ORDER BY pos)
),



combined AS 
(

SELECT DISTINCT ON (x,y) x,y FROM santa 
UNION 
SELECT DISTINCT ON (x,y) x,y FROM robo_santa 
UNION
VALUES (0,0)


)

SELECT COUNT(*) FROM combined;







