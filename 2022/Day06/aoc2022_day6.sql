SET lc_messages TO 'en_US.UTF-8';




CREATE FOREIGN TABLE aoc2022_day6 (x text)
SERVER aoc2022 options(filename 'D:\aoc2022.day6.input');


CREATE TEMPORARY TABLE  marker (

buffer text
 );
 
 INSERT INTO marker 
 SELECT *
 FROM 
 aoc2022_day6;



-- Part 1

WITH cte AS 
(
SELECT n, lit, LAG(lit,1) OVER w AS lag1, LAG(lit,2) OVER w AS lag2, LAG(lit,3) OVER w AS lag3 
FROM marker CROSS JOIN  STRING_TO_TABLE(buffer, NULL) WITH ORDINALITY AS t(lit,n) 
WINDOW w AS (ORDER BY n)
)

SELECT MIN(n) FROM cte WHERE lit != lag1 AND lit != lag2 AND lit != lag3 AND 
lag1 != lag2 AND lag1 != lag3 AND lag2 != lag3;





-- Part 2


WITH RECURSIVE cte AS
(

	SELECT   n, lit, STRING_AGG(lit,'') OVER (ORDER BY n RANGE BETWEEN 13 PRECEDING AND CURRENT ROW) AS x
	FROM marker CROSS JOIN  STRING_TO_TABLE(buffer, NULL) WITH ORDINALITY AS t(lit,n) OFFSET 13
),

literals (id, lit) AS
(
	SELECT 97 , CHR(97)
	UNION ALL
	SELECT id+1, CHR(id+1) FROM literals
    WHERE id < 122
)


SELECT n AS answer FROM cte JOIN literals l ON STRPOS(x,l.lit) > 0
GROUP BY n HAVING COUNT(*) = 14 ORDER BY n LIMIT 1; 






