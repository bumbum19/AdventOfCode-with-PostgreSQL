CREATE FOREIGN TABLE aoc2022_day5 (x text)
SERVER aoc2022 options(filename 'D:\aoc2022.day5.input');



CREATE TEMPORARY TABLE  arrangement 
(
stack INT,
height  INT,
symbol text
 );
 

INSERT INTO arrangement
VALUES
(1,1,'[Z]'),
(1,2,'[N]'),
(2,1,'[M]'),
(2,2,'[C]'),
(2,3,'[D]'),
(3,1,'[P]');



CREATE TEMPORARY TABLE  moves 
(
id SERIAL,
undock  INT,
target INT,
amount INT
 );
 
INSERT INTO moves(undock,target,amount)
VALUES
(2,1,1),
(1,3,3),
(2,1,2),
(1,2,1);



--------------------


CREATE TEMPORARY TABLE  arrangement 
(
stack INT,
height  INT,
symbol text
 );
 
 



INSERT INTO arrangement
WITH t AS 
(

SELECT * FROM  GENERATE_SERIES (1,9) AS stack CROSS JOIN GENERATE_SERIES (8,1,-1) AS height
),


t2 AS 
(

SELECT x, ROW_NUMBER() OVER () AS rnk FROM  aoc2022_day5
WHERE x NOT LIKE 'move%' AND x NOT LIKE '%1%' AND x NOT LIKE ''
),


t3 AS 
(

SELECT x, RANK() OVER (ORDER BY rnk DESC) AS height FROM t2
)

SELECT stack, height, SUBSTR(x,stack*4 - 3,3) AS symbol FROM t3 NATURAL JOIN t
WHERE SUBSTR(x,stack*4 - 3,3) != '   '
; 

 
 CREATE TEMPORARY TABLE  moves 
(
id SERIAL,
undock  INT,
target INT,
amount INT
 );

INSERT INTO moves (undock,target,amount)
SELECT 
SPLIT_PART(x,' ',4)::INT,
SPLIT_PART(x,' ',6)::INT,
SPLIT_PART(x,' ',2)::INT
FROM aoc2022_day5
WHERE x LIKE 'move%'
;
  
  
 -- Solution 


WITH RECURSIVE arrangement2(stack, height, symbol )  AS 
(
	SELECT 1, 0, 'bottom' 
	UNION ALL
	SELECT stack + 1 ,0, 'bottom' FROM arrangement2
	WHERE stack < (SELECT MAX(stack) FROM arrangement)
	
	
),

arrangement3 AS 

(TABLE arrangement
 UNION ALL
 TABLE arrangement2
),


t (step, stack, height, symbol, dep) AS 
(
	SELECT 0, *, MAX(height) OVER (PARTITION BY stack) 
	FROM arrangement3
	UNION ALL
	
	SELECT * FROM
	(WITH t_copy AS 
		(SELECT * FROM t) 
	
	SELECT step + 1,
	CASE WHEN  stack = undock AND height > dep - amount AND height > 0 THEN target ELSE stack END , 
	CASE WHEN  stack = undock AND height > dep - amount AND height > 0
		THEN (SELECT DISTINCT dep FROM t_copy WHERE stack = target) + dep - height + 1
		ELSE height END , 
	symbol, 
	MAX(CASE WHEN  stack = undock AND height > dep - amount AND height > 0
		THEN (SELECT DISTINCT dep FROM t_copy WHERE stack = target) + dep - height  + 1
		ELSE height END) OVER (PARTITION BY CASE WHEN  stack = undock AND height > dep - amount
		THEN target ELSE stack END) FROM t_copy JOIN moves ON step + 1 = id
	
	
	) AS t3
	
)



SELECT STRING_AGG(SUBSTR(symbol,2,1),'' ORDER BY stack) FROM t 

WHERE step = (SELECT COUNT(*) FROM moves) AND height > 0 AND height = dep;





-- Part 2


WITH RECURSIVE arrangement2(stack, height, symbol )  AS 
(
	SELECT 1, 0, 'bottom' 
	UNION ALL
	SELECT stack + 1 ,0, 'bottom' FROM arrangement2
	WHERE stack < (SELECT MAX(stack) FROM arrangement)
	
	
),

arrangement3 AS 

(TABLE arrangement
 UNION ALL
 TABLE arrangement2
),


t (step, stack, height, symbol, dep) AS 
(
	SELECT 0, *, MAX(height) OVER (PARTITION BY stack) 
	FROM arrangement3
	UNION ALL
	
	SELECT * FROM
	(WITH t_copy AS 
		(SELECT * FROM t) 
	
	SELECT step + 1,
	CASE WHEN  stack = undock AND height > dep - amount AND height > 0 THEN target ELSE stack END , 
	CASE WHEN  stack = undock AND height > dep - amount AND height > 0
		THEN (SELECT DISTINCT dep FROM t_copy WHERE stack = target) + height - (dep - amount) 
		ELSE height END , 
	symbol, 
	MAX(CASE WHEN  stack = undock AND height > dep - amount AND height > 0
		THEN (SELECT DISTINCT dep FROM t_copy WHERE stack = target) + height - (dep - amount) 
		ELSE height END) OVER (PARTITION BY CASE WHEN  stack = undock AND height > dep - amount
		THEN target ELSE stack END) FROM t_copy JOIN moves ON step + 1 = id
	
	
	) AS t3
	
)



SELECT STRING_AGG(SUBSTR(symbol,2,1),'' ORDER BY stack) FROM t 

WHERE step = (SELECT COUNT(*) FROM moves) AND height > 0 AND height = dep;


























WITH t AS 
(
SELECT *, MAX(height) OVER (PARTITION BY stack) AS dep FROM arrangement, moves WHERE id = 1 
)


SELECT 
CASE WHEN  stack = undock AND height > dep - amount THEN target ELSE stack END AS stack , 
CASE WHEN  stack = undock AND height > dep - amount 
	THEN (SELECT DISTINCT dep FROM t WHERE stack = target) + dep - height + 1
	ELSE height END AS height, 
symbol, 
MAX(CASE WHEN  stack = undock AND height > dep - amount 
	THEN (SELECT DISTINCT dep FROM t WHERE stack = target) + dep - height + 1
	ELSE height END) OVER (PARTITION BY CASE WHEN  stack = undock AND height > dep - amount
	THEN target ELSE stack END) AS dep FROM t 

;