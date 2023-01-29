
CREATE FOREIGN TABLE aoc2022_day10(x text)
 SERVER aoc2022 options(filename 'D:\aoc2022.day10.input');
 
 
CREATE TEMPORARY TABLE   cathode_ray  (
id  SERIAL,
instruction  TEXT,
steps INT
);


INSERT INTO cathode_ray(instruction, steps)
SELECT
SPLIT_PART(x,' ',1), CASE WHEN SPLIT_PART(x,' ',2) = '' THEN 0 ELSE SPLIT_PART(x,' ',2)::INT END
FROM aoc2022_day10;

------------------------------


CREATE FOREIGN TABLE aoc2022_day10_test(x text)
 SERVER aoc2022 options(filename 'D:\aoc2022.day10_test.input');
 
 
CREATE TEMPORARY TABLE   cathode_ray (
id  SERIAL,
instruction  TEXT,
steps INT
);


INSERT INTO cathode_ray(instruction, steps)
SELECT
SPLIT_PART(x,' ',1), CASE WHEN SPLIT_PART(x,' ',2) = '' THEN 0 ELSE SPLIT_PART(x,' ',2)::INT END
FROM aoc2022_day10_test;



-- Part 1


WITH cte AS
(
	SELECT id ,2 * COUNT(*) FILTER (WHERE instruction = 'addx' ) OVER w + 
		COUNT(*) FILTER (WHERE instruction = 'noop' ) OVER w AS pos, 
	  1 + SUM(steps) OVER w AS val
    FROM cathode_ray
    WINDOW w AS (ORDER BY id)
 
),

cte2 AS
( 
	SELECT pos, 
	LEAD(pos) OVER (ORDER BY id) AS next_pos, val 
	FROM cte



)



SELECT SUM(t.pos * val) AS signal_strength 
FROM cte2 
JOIN GENERATE_SERIES(20,220,40) AS t(pos) 
ON t.pos - 1 >= cte2.pos AND  t.pos - 1 < cte2.next_pos;




-- Part 2


WITH cte AS
(
	SELECT id ,2 * COUNT(*) FILTER (WHERE instruction = 'addx' ) OVER w + 
		COUNT(*) FILTER (WHERE instruction = 'noop' ) OVER w AS pos, 
	  1 + SUM(steps) OVER w AS val
    FROM cathode_ray
    WINDOW w AS (ORDER BY id)
 
),

cte2 AS
( 
	SELECT pos, 
	LEAD(pos) OVER (ORDER BY id) AS next_pos, val 
	FROM cte



),


screen AS 
(

	SELECT t.pos, CASE WHEN CASE WHEN MOD(t.pos,40) = 0 THEN 40 ELSE MOD(t.pos,40) END - COALESCE(val,0) BETWEEN 0 AND 2 
		THEN '#' ELSE '.' END AS pixel,
	NTILE(6) OVER (ORDER BY t.pos) AS bucket 
	FROM GENERATE_SERIES(1,240) AS t(pos)
	LEFT JOIN cte2
	ON t.pos - 1 >= cte2.pos AND  t.pos - 1 < cte2.next_pos
)



SELECT STRING_AGG(pixel,'' ORDER BY pos) AS image FROM screen GROUP BY bucket ORDER BY bucket;