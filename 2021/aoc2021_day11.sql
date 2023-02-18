SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2021_day11 (a text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day11.input');



 
 CREATE TEMPORARY TABLE  octopuses  (
  row_num  SERIAL,
  heights  INT[]
  );
  
  
INSERT INTO  octopuses(heights)
	VALUES 
	(ARRAY[1,1,1,1,1]),
	 (ARRAY[1,9,9,9,1]),
	 (ARRAY[1,9,1,9,1]),
	 (ARRAY[1,9,9,9,1]),
	 (ARRAY[1,1,1,1,1]);
	 


 CREATE TEMPORARY TABLE  octopuses  (
  row_num SERIAL,
  heights  INT[]
  );	 
	 
	 
INSERT INTO  octopuses(heights)
VALUES 
(STRING_TO_ARRAY('5483143223',NULL)::INT[]),
(STRING_TO_ARRAY('2745854711',NULL)::INT[]),
(STRING_TO_ARRAY('5264556173',NULL)::INT[]),
(STRING_TO_ARRAY('6141336146',NULL)::INT[]),
(STRING_TO_ARRAY('6357385478',NULL)::INT[]),
(STRING_TO_ARRAY('4167524645',NULL)::INT[]),
(STRING_TO_ARRAY('2176841721',NULL)::INT[]),
(STRING_TO_ARRAY('6882881134',NULL)::INT[]),
(STRING_TO_ARRAY('4846848554',NULL)::INT[]),
(STRING_TO_ARRAY('5283751526',NULL)::INT[])
;
	 
 
  CREATE TEMPORARY TABLE  octopuses  (
  row_num SERIAL,
  heights  INT[]
  );	 
	 
  
  
INSERT INTO octopuses(heights)
SELECT STRING_TO_ARRAY(a, NULL)::INT[] FROM aoc2021_day11;









-- Part 1

WITH RECURSIVE cte(step, x, heights) AS 
(
	SELECT 0, row_num AS x, heights FROM octopuses
	UNION ALL
	SELECT * FROM
	(
		WITH  RECURSIVE cte_copy AS 
		(
			SELECT * FROM cte 
		),
		
		current_step AS
		(
			SELECT DISTINCT step FROM cte_copy
		 
		),
			
		cte_inner( substep, x, y, height, flashed) AS 
		(
			SELECT  0, x, y, MOD(height + 1, 10), CASE WHEN  height = 9 THEN TRUE ELSE FALSE END
			FROM cte_copy CROSS JOIN UNNEST(heights) WITH ORDINALITY AS t(height, y)
			UNION ALL
			SELECT * FROM
	        (
				WITH cte_inner_copy AS 
			    (
					SELECT * FROM cte_inner 
				),
				
				cte2_inner AS
			    (
			
					SELECT *,
				    LAG(flashed) OVER w1 AS west,
					LEAD(flashed) OVER w1 AS east,
					LAG(flashed) OVER w2 AS north,
					LEAD(flashed) OVER w2 AS south
					FROM cte_inner_copy
					WINDOW w1 AS (PARTITION BY x ORDER BY y),
					       w2 AS (PARTITION BY y ORDER BY x)
				),
				
				cte3_inner AS
			    (
			
					SELECT *,
				    LAG(north) OVER w AS north_west,
					LEAD(north) OVER w AS north_east,
					LAG(south) OVER w AS south_west,
					LEAD(south) OVER w AS south_east
					FROM cte2_inner
					WINDOW w AS (PARTITION BY x ORDER BY y)
				)
				
				
				
				
				SELECT  substep + 1, x, y, 
				CASE WHEN t.height > 9 THEN 0 ELSE t.height END ,
				CASE WHEN t.height > 9 THEN TRUE WHEN t.height BETWEEN 1 AND 9 THEN FALSE ELSE NULL  END
				FROM cte3_inner 
				CROSS JOIN LATERAL (VALUES(
				CASE WHEN height > 0 THEN 
				height + 
				CASE  WHEN   west THEN 1 ELSE 0 END +
				CASE  WHEN   east THEN 1 ELSE 0 END +
				CASE  WHEN   north THEN 1 ELSE 0 END +
				CASE  WHEN   south THEN 1 ELSE 0 END +
				CASE  WHEN   north_west THEN 1 ELSE 0 END +
				CASE  WHEN  north_east THEN 1 ELSE 0 END +
				CASE  WHEN   south_west THEN 1 ELSE 0 END +
				CASE  WHEN  south_east THEN 1 ELSE 0 END
				ELSE 0 END
				)) AS t(height)
				WHERE EXISTS
				(
				SELECT * FROM cte_inner_copy WHERE flashed
				)
		            
		    
			
			
			
			
			) AS dt_inner
		
		
		
		),
		
		cte4_inner AS
		(
		
			SELECT DISTINCT ON (x, y) x, y, height 
			FROM cte_inner
			ORDER BY x, y, substep DESC
		)
		
		SELECT (TABLE current_step) + 1, x, ARRAY_AGG(height ORDER BY y)
		FROM cte4_inner
		WHERE (TABLE current_step) < 100
		GROUP BY x
		
		
	) AS dt

)

SELECT  SUM(CASE WHEN height = 0 THEN 1 ELSE 0 END) FROM cte CROSS JOIN UNNEST(heights) AS height ;



-- Part 2


WITH RECURSIVE cte(step, x, heights) AS 
(
	SELECT 0, row_num AS x, heights FROM octopuses
	UNION ALL
	SELECT * FROM
	(
		WITH  RECURSIVE cte_copy AS 
		(
			SELECT * FROM cte 
		),
		
		current_step AS
		(
			SELECT DISTINCT step FROM cte_copy
		 
		),
			
		cte_inner( substep, x, y, height, flashed) AS 
		(
			SELECT  0, x, y, MOD(height + 1, 10), CASE WHEN  height = 9 THEN TRUE ELSE FALSE END
			FROM cte_copy CROSS JOIN UNNEST(heights) WITH ORDINALITY AS t(height, y)
			UNION ALL
			SELECT * FROM
	        (
				WITH cte_inner_copy AS 
			    (
					SELECT * FROM cte_inner 
				),
				
				cte2_inner AS
			    (
			
					SELECT *,
				    LAG(flashed) OVER w1 AS west,
					LEAD(flashed) OVER w1 AS east,
					LAG(flashed) OVER w2 AS north,
					LEAD(flashed) OVER w2 AS south
					FROM cte_inner_copy
					WINDOW w1 AS (PARTITION BY x ORDER BY y),
					       w2 AS (PARTITION BY y ORDER BY x)
				),
				
				cte3_inner AS
			    (
			
					SELECT *,
				    LAG(north) OVER w AS north_west,
					LEAD(north) OVER w AS north_east,
					LAG(south) OVER w AS south_west,
					LEAD(south) OVER w AS south_east
					FROM cte2_inner
					WINDOW w AS (PARTITION BY x ORDER BY y)
				)
				
				
				
				
				SELECT  substep + 1, x, y, 
				CASE WHEN t.height > 9 THEN 0 ELSE t.height END ,
				CASE WHEN t.height > 9 THEN TRUE WHEN t.height BETWEEN 1 AND 9 THEN FALSE ELSE NULL  END
				FROM cte3_inner 
				CROSS JOIN LATERAL (VALUES(
				CASE WHEN height > 0 THEN 
				height + 
				CASE  WHEN   west THEN 1 ELSE 0 END +
				CASE  WHEN   east THEN 1 ELSE 0 END +
				CASE  WHEN   north THEN 1 ELSE 0 END +
				CASE  WHEN   south THEN 1 ELSE 0 END +
				CASE  WHEN   north_west THEN 1 ELSE 0 END +
				CASE  WHEN  north_east THEN 1 ELSE 0 END +
				CASE  WHEN   south_west THEN 1 ELSE 0 END +
				CASE  WHEN  south_east THEN 1 ELSE 0 END
				ELSE 0 END
				)) AS t(height)
				WHERE EXISTS
				(
				SELECT * FROM cte_inner_copy WHERE flashed
				)
		            
		    
			
			
			
			
			) AS dt_inner
		
		
		
		),
		
		cte4_inner AS
		(
		
			SELECT DISTINCT ON (x, y) x, y, height 
			FROM cte_inner
			ORDER BY x, y, substep DESC
		)
		
		SELECT (TABLE current_step) + 1, x, ARRAY_AGG(height ORDER BY y)
		FROM cte4_inner
		WHERE (SELECT SUM(height) FROM cte4_inner) > 0
		GROUP BY x
		
		
	) AS dt

)

SELECT  MAX(step) + 1 FROM cte ;









