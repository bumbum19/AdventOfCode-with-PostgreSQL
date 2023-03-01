SET lc_messages TO 'en_US.UTF-8';




CREATE FOREIGN TABLE aoc2020_day21 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day12.input');


CREATE TEMPORARY TABLE instructions
(  
	id SERIAL,
	move CHAR,
	val INT
);



INSERT INTO instructions(move, val)
SELECT 
SUBSTR(x, 1, 1),
SUBSTR(x, 2)::INT
FROM aoc2020_day21;

--------------------------



CREATE TEMPORARY TABLE instructions
(  
	id SERIAL,
	move CHAR,
	val INT
);


INSERT INTO instructions(move, val)
VALUES
('F', 10),
('N', 3),
('F', 7),
('R', 90),
('F', 11);




-- Part 1

WITH RECURSIVE cte(step, x, y, orientation) AS 
(
	SELECT 0, 0, 0, 'E' 
	UNION ALL
	SELECT step + 1,
	CASE WHEN move = 'E' THEN x + val
		 WHEN move = 'W' THEN x - val
		 WHEN move = 'F' AND orientation = 'E' THEN x + val
		 WHEN move = 'F' AND orientation = 'W' THEN x - val
	ELSE x END,
	CASE WHEN move = 'N' THEN y + val
		 WHEN move = 'S' THEN y - val
		 WHEN move = 'F' AND orientation = 'N' THEN y + val
		 WHEN move = 'F' AND orientation = 'S' THEN y - val
	ELSE y END,
	CASE WHEN orientation = 'N' THEN 
			CASE WHEN move = 'R' THEN
					CASE WHEN val = 90 THEN 'E'
						WHEN val = 180 THEN 'S'
						ELSE 'W' END
				WHEN  move = 'L' THEN
					CASE WHEN val = 90 THEN 'W'
						WHEN val = 180 THEN 'S'
						ELSE 'E' END
				
				ELSE orientation END
		
		
		WHEN orientation = 'S' THEN 
			CASE WHEN move = 'R' THEN
					CASE WHEN val = 90 THEN 'W'
						WHEN val = 180 THEN 'N'
						ELSE 'E' END
				WHEN  move = 'L' THEN
					CASE WHEN val = 90 THEN 'E'
						WHEN val = 180 THEN 'N'
					ELSE 'W' END
				ELSE orientation END
				
				
		WHEN orientation = 'E' THEN 
			CASE WHEN move = 'R' THEN
					CASE WHEN val = 90 THEN 'S'
					WHEN val = 180 THEN 'W'
					ELSE 'N' END
				WHEN  move = 'L' THEN
					CASE WHEN val = 90 THEN 'N'
					WHEN val =  180 THEN 'W'
					ELSE 'S' END
				
				ELSE orientation END
		
		WHEN orientation = 'W' THEN 
			CASE WHEN move = 'R' THEN
					CASE WHEN val = 90 THEN 'N'
					WHEN val = 180 THEN 'E'
					ELSE 'S' END
				WHEN  move = 'L' THEN
					CASE WHEN val = 90 THEN 'S'
					WHEN val =  180 THEN 'E'
					ELSE 'N' END
			ELSE orientation END
		 
		END
			
FROM cte c
JOIN instructions 
	ON id = step + 1

)

SELECT ABS(x) + ABS(y) FROM cte
ORDER BY step DESC
LIMIT 1 ;




-- Part 2


WITH RECURSIVE cte(step, x_wp, y_wp, x_ship, y_ship) AS 
(
	SELECT 0, 10, 1, 0, 0 
	UNION ALL
	SELECT step + 1,
	CASE WHEN move = 'E' THEN x_wp + val
		 WHEN move = 'W' THEN x_wp - val
		 WHEN move = 'L' THEN 
			CASE WHEN val = 90 THEN -1 * y_wp
				 WHEN val = 180 THEN -1 * x_wp
				 WHEN val = 270 THEN  y_wp END
		WHEN move = 'R' THEN 
			CASE WHEN val = 90 THEN  y_wp
				 WHEN val = 180 THEN -1 * x_wp
				 WHEN val = 270 THEN -1* y_wp END
		ELSE x_wp
		END,
	CASE WHEN move = 'N' THEN y_wp + val
		 WHEN move = 'S' THEN y_wp - val
		 WHEN move = 'L' THEN 
			CASE WHEN val = 90 THEN x_wp
				 WHEN val = 180 THEN -1 * y_wp
				 WHEN val = 270 THEN -1 * x_wp  END 
		WHEN move = 'R' THEN 
			CASE WHEN val = 90 THEN -1 * x_wp
				 WHEN val = 180 THEN -1 * y_wp
				 WHEN val = 270 THEN x_wp END
		ELSE y_wp
		END,
		
		CASE WHEN move = 'F' THEN x_ship + val * x_wp
			ELSE x_ship END,
		CASE WHEN move = 'F' THEN y_ship + val * y_wp
			ELSE y_ship END
		
FROM cte c
JOIN instructions 
	ON id = step + 1

)

SELECT ABS(x_ship) + ABS(y_ship) FROM cte
ORDER BY step DESC
LIMIT 1 ;










