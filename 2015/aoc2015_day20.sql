SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2015_day20(x text)
SERVER aoc2018 options(filename 'D:\aoc2015.day20.input');



CREATE TEMPORARY TABLE bound
(
	num INT

);

INSERT INTO bound
SELECT x::INT 
FROM aoc2015_day20;


-- Part 1


WITH cte AS
(

	SELECT y, SUM(x) AS add_up
	FROM GENERATE_SERIES(1, 2000) AS x
	JOIN GENERATE_SERIES(1, 2000) AS y
		 ON MOD(y, x) = 0
	GROUP BY y
)

SELECT c1.y * c2.y AS num
FROM cte c1
JOIN cte c2
    ON c1.y < c2.y
	AND GCD(c1.y,c2.y) = 1
	
WHERE 10 * c1.add_up * c2.add_up >= (TABLE bound)
ORDER BY num
LIMIT 1;



-- Part 2

WITH cte AS
(

	SELECT y, x
	FROM GENERATE_SERIES(1, 2000) AS x
	JOIN GENERATE_SERIES(1, 2000) AS y
		 ON MOD(y, x) = 0
		 
	
)

SELECT c1.y * c2.y AS num
FROM cte c1
JOIN cte c2
    ON c1.y < c2.y
	AND GCD(c1.y,c2.y) = 1
	
WHERE c1.y * c2.y <= c1.x * c2.x * 50 
GROUP BY c1.y,  c2.y
HAVING 11 * SUM(c1.x * c2.x)  >= (TABLE bound)
ORDER BY num
LIMIT 1
;


















SELECT c1.y * c2.y AS x
FROM cte c1
JOIN cte c2
    ON c1.y < c2.y
	AND GCD(c1.y,c2.y) = 1
	
WHERE 10 * c1.add_up * c2.add_up >= (TABLE bound)
ORDER BY x
LIMIT 1;




