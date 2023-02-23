SET lc_messages TO 'en_US.UTF-8';



CREATE SERVER aoc2016 FOREIGN  DATA wrapper file_fdw;




CREATE FOREIGN TABLE aoc2016_day1 (x TEXT)
SERVER aoc2016 options(filename 'D:\aoc2016.day1.input');





CREATE  TEMPORARY TABLE walk
(
	step SERIAL,
	direction CHAR,
	moves INT
);

INSERT INTO walk(direction, moves)
SELECT SUBSTR(TRIM(y),1,1), SUBSTR(TRIM(y),2)::INT FROM aoc2016_day1
CROSS JOIN STRING_TO_TABLE(x, ',') AS y ;


--------------------------

CREATE  TEMPORARY TABLE walk
(
	step SERIAL,
	direction CHAR,
	moves INT
);

INSERT INTO walk(direction, moves)
VALUES 
('R', 2), 
('R', 2),
('R', 2);


-- Part 1


WITH RECURSIVE cte(step, direction, orientation) AS 

(

	SELECT step, direction, 1 FROM walk WHERE step = 1
	UNION ALL
	SELECT 	w.step, w.direction, 
	CASE WHEN MOD(w.step, 2) = 0 THEN CASE WHEN cte.direction = 'R' AND orientation = 1 
		OR cte.direction = 'L' AND orientation = -1 THEN 1 ELSE -1 END
	ELSE CASE WHEN cte.direction = 'R' AND orientation = 1 
		OR cte.direction = 'L' AND orientation = -1 THEN -1 ELSE 1 END
		END
	FROM walk w
	JOIN cte 
		ON w.step = cte.step + 1
	
)


SELECT ABS(SUM( CASE WHEN direction = 'R' AND orientation = 1 
		OR direction = 'L' AND orientation = -1 THEN moves ELSE -moves END) FILTER (WHERE MOD(step,2)  =1))+  
		
	  ABS(SUM( CASE WHEN direction = 'R' AND orientation = 1 
		OR direction = 'L' AND orientation = -1 THEN -moves ELSE moves END) FILTER (WHERE MOD(step,2)  =0) ) AS distance
FROM cte 
JOIN walk 
	USING (step, direction)
 ;
 
 
 
 
 
 
 

 
 
 
 
 -- Part 2
 
 
 
 WITH RECURSIVE cte(step, direction, orientation) AS 

(

	SELECT step, direction, 1 FROM walk WHERE step = 1
	UNION ALL
	SELECT 	w.step, w.direction, 
	CASE WHEN MOD(w.step, 2) = 0 THEN CASE WHEN cte.direction = 'R' AND orientation = 1 
		OR cte.direction = 'L' AND orientation = -1 THEN 1 ELSE -1 END
	ELSE CASE WHEN cte.direction = 'R' AND orientation = 1 
		OR cte.direction = 'L' AND orientation = -1 THEN -1 ELSE 1 END
		END
	FROM walk w
	JOIN cte 
		ON w.step = cte.step + 1
	
),


cte2 AS 
(

	SELECT step, COALESCE(SUM( CASE WHEN direction = 'R' AND orientation = 1 
			OR direction = 'L' AND orientation = -1 THEN moves ELSE -moves END) FILTER (WHERE MOD(step,2)  =1) OVER w, 0) AS x, 
			
		  COALESCE(SUM( CASE WHEN direction = 'R' AND orientation = 1 
			OR direction = 'L' AND orientation = -1 THEN -moves ELSE moves END) FILTER (WHERE MOD(step,2)  =0) OVER w, 0) AS y
	FROM cte 
	JOIN walk 
		USING (step, direction)
	WINDOW w AS (ORDER BY step)
	UNION ALL SELECT 0, 0, 0
),

cte3 AS 
(

	SELECT step, LSEG(POINT(x,y), POINT(LEAD(x) OVER w, LEAD(y) OVER w)) AS line
	FROM cte2
	WINDOW w AS (ORDER BY step)



)



SELECT  ABS((a.line # b.line)[0]) + ABS((a.line # b.line)[1]) AS answer
FROM cte3 a 
JOIN cte3 b
	ON a.step < b.step - 1
	AND a.line ?# b.line
ORDER BY b.step
LIMIT 1
;






