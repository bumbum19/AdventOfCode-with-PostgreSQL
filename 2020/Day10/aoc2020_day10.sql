SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2020_day10 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day10.input');


CREATE FOREIGN TABLE aoc2020_day10_test (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day10_test.input');


CREATE TEMPORARY TABLE adapter
(
	id SERIAL,
	jolt INT



);

INSERT INTO adapter(jolt)
SELECT x::INT FROM aoc2020_day10;



-----------

CREATE TEMPORARY TABLE adapter
(
	id SERIAL,
	jolt INT



);

INSERT INTO adapter(jolt)
VALUES
(16),
(10),
(15),
(5),
(1),
(11),
(7),
(19),
(6),
(12),
(4);






















-- Part 1

WITH cte AS
(
	SELECT  jolt - COALESCE(LAG(jolt) OVER w, 0)  AS diff 
	FROM adapter
	WINDOW w AS (ORDER BY jolt, id)

)



SELECT COUNT(*) FILTER (WHERE diff = 1) * (COUNT(*) FILTER (WHERE diff = 3) + 1)
FROM cte;




-- Part 2


WITH cte AS
(
	SELECT id, jolt,  COALESCE(LEAD(jolt) OVER w, jolt + 3) - jolt AS diff, 
	ROW_NUMBER() OVER w AS rnk
	FROM (TABLE adapter UNION VALUES(0,0)) AS full_adapter
	WINDOW w AS (ORDER BY jolt, id)

),

cte2 AS 
(
	SELECT rnk, rnk - COALESCE(LAG(rnk) OVER w, 0) - 2 AS diff FROM cte
	WHERE diff = 3
	WINDOW w AS (ORDER BY rnk)
	



),

cte3 AS
(

	SELECT 
	CASE WHEN diff = 1 THEN 2 
		 WHEN diff = 2 THEN 4 
		 ELSE POW(2, diff) - (diff - 2) * POW(2, diff - 3) END AS f_diff		 ,
	COUNT(*) AS cnt
	FROM cte2
	WHERE diff > 0
	GROUP BY diff
)

SELECT PRODUCT(POW(f_diff, cnt)::INT) FROM cte3 ;
















