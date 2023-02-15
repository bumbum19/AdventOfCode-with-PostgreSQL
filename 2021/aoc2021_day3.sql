SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2021_day3 (num text)
SERVER aoc2021 options(filename 'D:\aoc2021.day3.input');


 CREATE TEMPORARY TABLE submarine (
 id  SERIAL,
 num  INT[12]
  
 );


INSERT INTO submarine(num)
SELECT string_to_array(num,NULL)::INT[12] FROM aoc2021_day3;
 



-- Part 1

WITH cte AS 
(
	SELECT pos, bit 
	FROM submarine 
	CROSS JOIN UNNEST(num) 
		WITH ORDINALITY AS t(bit, pos)
),
 
cte2 AS 
(
	SELECT DISTINCT ON (pos) pos, bit
	FROM cte
	GROUP BY pos, bit
	ORDER BY pos, COUNT(*) DESC
 )
 
 
 SELECT ARRAY_TO_STRING(ARRAY_AGG(bit ORDER BY pos),'')::BIT(12)::INT * 
 (~(ARRAY_TO_STRING(ARRAY_AGG(bit ORDER BY pos),'')::BIT(12)))::INT AS power_consumption
 FROM cte2;
 



-- Part 2 



WITH RECURSIVE oxygen(step, num) AS 
(
	SELECT 0, num FROM submarine
	UNION ALL
	SELECT * FROM
		(
			WITH cte_copy AS 
			( 
				SELECT  *  FROM oxygen
			), 
			  
			cte_inner AS 
			(
				  SELECT bit
				  FROM cte_copy 
				  CROSS JOIN UNNEST(num) 
				  WITH ORDINALITY AS t(bit, pos)
				  WHERE pos = step + 1
				  GROUP BY bit
				  ORDER BY COUNT(*) DESC, bit DESC
				  LIMIT 1
				  
			 ) 
			
			SELECT step+ 1, num 
			FROM cte_copy 
			JOIN cte_inner
				ON num[step+ 1] = bit
            WHERE step < 12


        ) AS dt
	
),


scrubber(step, num) AS 
(
	SELECT 0, num FROM submarine
	UNION ALL
	SELECT * FROM
		(
			WITH cte2_copy AS 
			( 
				SELECT  *  FROM scrubber
			), 
			  
			cte2_inner AS 
			(
				  SELECT bit
				  FROM cte2_copy
				  CROSS JOIN UNNEST(num) 
				  WITH ORDINALITY AS t(bit, pos)
				  WHERE pos = step + 1
				  GROUP BY bit
				  ORDER BY COUNT(*), bit 
				  LIMIT 1
				  
			 ) 
			
			SELECT step + 1, num 
			FROM cte2_copy 
			JOIN cte2_inner
				ON num[step + 1] = bit
            WHERE step < 12


        ) AS dt2
	
)





SELECT (SELECT ARRAY_TO_STRING(num,'')::BIT(12)::INT FROM oxygen WHERE step = 12) * 
	   (SELECT ARRAY_TO_STRING(num,'')::BIT(12)::INT  FROM scrubber WHERE step = 12) AS life_support_rating ;





















































































































CREATE TABLE test (
    num  BIT(12)
);


INSERT INTO test (num) VALUES
    (B'101'),
    (B'111'),
	(B'011'),
	(B'000'),
	(B'110');
	
SELECT	ARRAY_REPLACE(STRING_TO_ARRAY(REPLACE(B'110111110100'::VARCHAR(12),NULL)::INT[12],0,-1);