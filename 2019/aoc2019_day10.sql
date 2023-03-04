SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2019_day10 (x text)
SERVER aoc2019 options(filename 'D:\aoc2019.day10.input');



CREATE FOREIGN TABLE aoc2019_day10_test (x text)
SERVER aoc2019 options(filename 'D:\aoc2019.day10_test.input');


CREATE FOREIGN TABLE aoc2019_day10_test2 (x text)
SERVER aoc2019 options(filename 'D:\aoc2019.day10_test2.input');


CREATE TEMPORARY TABLE asteroids
(   
	id SERIAL,
	pos POINT

);




INSERT INTO asteroids(pos)
WITH cte AS
(
	SELECT x, ROW_NUMBER() OVER () AS line
	FROM aoc2019_day10
)

SELECT POINT(col- 1, line - 1)
FROM cte
CROSS JOIN STRING_TO_TABLE(x, NULL) WITH ORDINALITY AS t(y, col)
WHERE y = '#';






-- Part 1



WITH cte AS
(

	SELECT s1.id AS first_id, s2.id AS second_id,
	LSEG(s1.pos, s2.pos) AS line_seg
	FROM asteroids s1
	JOIN asteroids s2
		ON s1.id != s2.id
	
)




SELECT  (SELECT COUNT(*) -1 FROM asteroids ) - COUNT(DISTINCT second_id)  AS cnt
FROM cte c 
JOIN asteroids a
	ON pos <@ line_seg
WHERE id != first_id
AND id != second_id
GROUP BY first_id
ORDER BY cnt DESC
LIMIT 1;


-- Part 2


WITH cte AS
(

	SELECT s1.id AS first_id, s1.pos AS first_pos, s2.id AS second_id, s2.pos AS second_pos,
	LSEG(s1.pos, s2.pos) AS line_seg
	FROM asteroids s1
	JOIN asteroids s2
		ON s1.id != s2.id
	
),

station AS 
(

    SELECT  first_id AS id
	FROM cte c 
	JOIN asteroids a
		ON pos <@ line_seg
	WHERE id != first_id
	AND id != second_id
	GROUP BY first_id
	ORDER BY (SELECT COUNT(*) -1 FROM asteroids ) - COUNT(DISTINCT second_id)  DESC
	LIMIT 1

),

cte2 AS
(
	SELECT first_id,  second_id,  LENGTH(line_seg) AS dist,

     
	ROUND(ACOS(
	CASE WHEN direction = 1 THEN -1 ELSE 1 END *trans_pos[1]/
	 SQRT(POW(trans_pos[0],2) + POW(trans_pos[1],2))
	 )::NUMERIC, 3) AS angle , direction
	
	 

	FROM cte 
	CROSS JOIN LATERAL(VALUES(second_pos - (SELECT pos FROM station NATURAL JOIN asteroids))) AS t(trans_pos)
	CROSS JOIN LATERAL(VALUES(CASE WHEN SIGN(trans_pos[0]) =  0 THEN 1 ELSE SIGN(trans_pos[0]) END ))AS t2(direction)
	WHERE first_id = (TABLE station)
),

find_id AS
(

	SELECT  second_id AS id , RANK() OVER (PARTITION BY angle, direction  ORDER BY dist) AS rnk, direction, angle
	FROM cte2
	ORDER BY rnk, direction DESC, angle
	OFFSET 199 
    LIMIT 1
	
)

SELECT pos[0]*100 + pos[1]
FROM find_id
NATURAL JOIN asteroids;







