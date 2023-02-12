CREATE FOREIGN TABLE aoc2016_day5 (x TEXT)
SERVER aoc2016 options(filename 'D:\aoc2016.day5.input');




CREATE TEMPORARY TABLE door
(

	id TEXT

);


INSERT INTO door 
TABLE aoc2016_day5;



-- Part 1

SELECT SUBSTR(STRING_AGG(SUBSTR(first_six, 6), ''), 1, 8) 
FROM door 
CROSS JOIN  GENERATE_SERIES(1, 10000000) AS x
CROSS JOIN LATERAL (VALUES(SUBSTR(MD5(id|| x::TEXT), 1, 6))) AS dt(first_six)
WHERE SUBSTR(first_six, 1, 5) = '00000'



-- Part 2

WITH cte  AS
(
	SELECT DISTINCT ON (SUBSTR(first_seven, 6, 1) ) first_seven
	FROM door 
	CROSS JOIN  GENERATE_SERIES(1, 30000000) AS x
	CROSS JOIN LATERAL (VALUES(SUBSTR(MD5(id|| x::TEXT), 1, 7))) AS dt(first_seven)
	WHERE SUBSTR(first_seven, 1, 5) = '00000' 
	ORDER BY SUBSTR(first_seven, 6, 1), x
)


SELECT SUBSTR(STRING_AGG(SUBSTR(first_seven, 7), ''), 1, 8) FROM cte;