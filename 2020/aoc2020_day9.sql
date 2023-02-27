SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2020_day9 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day9.input');


CREATE TEMPORARY TABLE xmas
(
	id SERIAL,
	num BIGINT



);

INSERT INTO xmas(num)
SELECT x::BIGINT FROM aoc2020_day9;




-- Part 1

WITH cte AS 
(

	SELECT a.id AS id_1, b.id AS id_2, a.num + b.num AS num
	FROM xmas a 
	JOIN xmas b
		ON a.id < b.id
	
)


SELECT num FROM xmas 
LEFT JOIN cte 
	USING (num)
WHERE id_1 IS NULL
AND id > 25
ORDER BY id 
LIMIT 1;



-- Part 2



WITH  RECURSIVE cte AS 
(

	SELECT a.id AS id_1, b.id AS id_2, a.num + b.num AS num
	FROM xmas a 
	JOIN xmas b
		ON a.id < b.id
	
),


invalid_number AS 
(
	SELECT num FROM xmas 
	LEFT JOIN cte 
		USING (num)
	WHERE id_1 IS NULL
	AND id > 25
	ORDER BY id 
	LIMIT 1
),



cte2 AS 
(


	SELECT  x, id FROM GENERATE_SERIES(1,1000) AS x
	CROSS JOIN LATERAL( SELECT id, SUM(num)  OVER w AS y FROM xmas OVER WINDOW w AS 
	(ORDER BY id RANGE BETWEEN x PRECEDING AND CURRENT ROW)) AS dt
     WHERE y = (TABLE invalid_number)





)


SELECT MIN(num) + MAX(num) AS encryption_weakness
FROM xmas 
WHERE id BETWEEN (SELECT id - x FROM cte2) AND (SELECT id FROM cte2);
	
	
	

