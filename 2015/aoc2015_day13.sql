SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2015_day13(x text)
SERVER aoc2018 options(filename 'D:\aoc2015.day13.input');



CREATE FOREIGN TABLE aoc2015_day13_test(x text)
SERVER aoc2018 options(filename 'D:\aoc2015.day13_test.input');



CREATE TEMPORARY TABLE seat_arr
(
	person1 TEXT,
	person2 TEXT,
	preference INT

);


INSERT INTO seat_arr
SELECT 
SPLIT_PART(x, ' ', 1), 
LEFT(SPLIT_PART(x, ' ', -1), -1),
CASE WHEN SPLIT_PART(x, ' ', 3) = 'gain' THEN SPLIT_PART(x, ' ', 4) ::INT
	ELSE -1 * SPLIT_PART(x, ' ', 4) ::INT END
FROM aoc2015_day13;


-- Part 1





WITH RECURSIVE search_map(person1, person2, total_preference, depth) AS 
(
	SELECT *, 1
	FROM seat_arr 
	UNION ALL
	SELECT sa.person1, sa.person2, total_preference + preference, sm.depth + 1
	FROM seat_arr sa
	JOIN search_map sm
		ON sa.person1 = sm.person2
) CYCLE person1 SET is_cycle USING path
,

paths AS 
(

	SELECT path::TEXT[] AS path ,  total_preference
	FROM search_map 
	WHERE  NOT is_cycle 
	AND person2 =   LEFT(SUBSTR((path::TEXT[])[1], 2), -1)
	AND depth = (SELECT COUNT(DISTINCT person1)   FROM  seat_arr)
)



SELECT  p1.total_preference + p2.total_preference AS happiness
FROM paths p1
JOIN paths p2
	ON p1.path = ARRAY_REVERSE(p2.path)
ORDER BY happiness DESC
LIMIT 1;




-- Part 2

WITH RECURSIVE search_map(person1, person2, total_preference, depth) AS 
(
	SELECT *, 1
	FROM seat_arr 
	UNION ALL
	SELECT sa.person1, sa.person2, total_preference + preference, sm.depth + 1
	FROM seat_arr sa
	JOIN search_map sm
		ON sa.person1 = sm.person2
) CYCLE person1 SET is_cycle USING path
,

paths AS 
(

	SELECT path::TEXT[] AS path ,  total_preference
	FROM search_map 
	WHERE  NOT is_cycle 
	AND person2 =   LEFT(SUBSTR((path::TEXT[])[1], 2), -1)
	AND depth = (SELECT COUNT(DISTINCT person1)   FROM  seat_arr)
),

arrangements AS
(
	SELECT  p1.total_preference + p2.total_preference AS happiness,  p1.path
	FROM paths p1
	JOIN paths p2
		ON p1.path = ARRAY_REVERSE(p2.path)
),

pairs AS 
(
	SELECT '(' || s1.person1 || ')' AS person1, '(' || s1.person2 || ')'  AS person2, 
	s1.preference + s2.preference AS mutual_affection
	FROM seat_arr s1
	JOIN seat_arr s2
		ON s1.person1 = s2.person2
		AND s2.person1 = s1.person2

)


SELECT happiness - mutual_affection AS new_happiness
FROM arrangements
JOIN pairs
	ON array_position(path, person2 ) - array_position(path,  person1) = 1
ORDER BY new_happiness DESC
LIMIT 1; 
























