CREATE FOREIGN TABLE aoc2018_day6 (x TEXT)
SERVER aoc2018 options(filename 'D:\aoc2018.day6.input');



CREATE TEMPORARY TABLE coordinates
(
	id SERIAL PRIMARY KEY,
	x INT,
	y INT
);



INSERT INTO coordinates(x, y)
SELECT  
SPLIT_PART(x, ', ', 1)::INT, 
SPLIT_PART(x, ', ', 2)::INT
FROM aoc2018_day6;




CREATE TEMPORARY TABLE coordinates
(
	id SERIAL PRIMARY KEY,
	x INT,
	y INT
);



INSERT INTO coordinates(x, y)
VALUES 
(1, 1),
(1, 6),
(8, 3),
(3, 4),
(5, 5),
(8, 9);


-- Part 1

WITH cte AS 
(

	SELECT DISTINCT ON (a, b) a, b, ABS(a-x) +  ABS(b-y)  AS dist
	FROM GENERATE_SERIES(0, 500) AS a
	CROSS JOIN GENERATE_SERIES(0, 500) b
	CROSS JOIN coordinates
	ORDER BY a,b, dist 


),

cte2 AS 
(

	SELECT a, b, SUM(x) AS x, SUM(y) AS y
	FROM cte 
	JOIN coordinates
		ON ABS(a-x) +  ABS(b-y) = dist
	GROUP BY a, b 
	HAVING COUNT(*) = 1
)

SELECT COUNT(*) AS area
FROM cte2
GROUP BY x, y
HAVING NOT BOOL_OR( a NOT BETWEEN  (SELECT MIN(x) FROM coordinates)  AND (SELECT MAX(x) FROM coordinates) OR
					b NOT BETWEEN  (SELECT MIN(y) FROM coordinates)  AND (SELECT MAX(y) FROM coordinates)  ) 
ORDER BY area DESC
LIMIT 1;



-- Part 2


WITH cte AS 
(

	SELECT a, b
	FROM GENERATE_SERIES(0, 500) AS a
	CROSS JOIN GENERATE_SERIES(0, 500) b
	CROSS JOIN coordinates
	GROUP BY a, b
	HAVING SUM(ABS(a-x) +  ABS(b-y)) <= 10000


)


SELECT COUNT(*) FROM cte;




