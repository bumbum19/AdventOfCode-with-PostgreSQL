CREATE FOREIGN TABLE aoc2017_day6 (x TEXT)
SERVER aoc2017 options(filename 'D:\aoc2017.day6.input', DELIMITER ';');


CREATE TEMPORARY TABLE memory 
(


	
	block INT[]

);

INSERT INTO memory
SELECT  STRING_TO_ARRAY(REGEXP_REPLACE(x, '\s', ',', 'g'),',')::INT[]
FROM aoc2017_day6;

---------------------


CREATE TEMPORARY TABLE memory 
(


	
	block INT[]

);


INSERT INTO memory
VALUES (ARRAY[0, 2, 7,  0]);



-- Part 1



WITH RECURSIVE cardinality AS
(
	SELECT CARDINALITY(block) FROM memory


),


reallocation AS
(

	TABLE memory 
	UNION
	
	SELECT * FROM
	(
	 WITH rellacation_copy AS 
		(SELECT  pos, elem FROM reallocation CROSS JOIN UNNEST(block) WITH ORDINALITY AS t(elem, pos)),
		
	 choose_element AS 
	 (SELECT elem ,pos FROM rellacation_copy ORDER BY elem DESC, pos LIMIT 1
	  ),
	  
	  max_val AS 
	  (
	  SELECT elem FROM choose_element
	  
	  ),
	  
	  max_pos AS
	  (
	  SELECT pos FROM choose_element
	  )
	  
	  
	  
	  
	  
		
		SELECT ARRAY_AGG( CASE WHEN pos = (TABLE max_pos) THEN 0 ELSE elem END +
		
		
		                (TABLE max_val)/(TABLE cardinality) + 
		                   CASE WHEN pos > (TABLE max_pos) THEN
								 CASE WHEN pos - (TABLE max_pos) <= MOD((TABLE max_val),(TABLE cardinality))
										THEN 1 
									ELSE 
										0 END
								 WHEN  pos < (TABLE max_pos) THEN
								  CASE WHEN (TABLE cardinality)- (TABLE max_pos) + pos <= MOD((TABLE max_val),(TABLE cardinality))
										THEN 1 
									ELSE 
										0 END
								ELSE 0 END 
		                        
		
		                  
		              ORDER BY pos)

			FROM rellacation_copy
			
	  ) AS dt
	
		
)



SELECT COUNT(*) FROM reallocation;




-- Part 2



WITH RECURSIVE cardinality AS
(
	SELECT CARDINALITY(block) FROM memory


),





reallocation(step, block) AS
(

	SELECT 0, block FROM memory
	UNION ALL
	
	SELECT * FROM
	(
	 WITH reallacation_copy AS 
		(SELECT * FROM reallocation ),
	 
		  cte AS 
		  (
		  
		SELECT  step + 1 AS step, pos, elem 
		  FROM reallacation_copy CROSS JOIN UNNEST(block) WITH ORDINALITY AS t(elem, pos)
		 ),
		 
		 
		 

      	 
		 
		
		
		 choose_element AS 
		 (SELECT elem ,pos FROM cte ORDER BY elem DESC, pos LIMIT 1
		  ),
		  
		  max_val AS 
		  (
		  SELECT elem FROM choose_element
		  
		  ),
		  
		  max_pos AS
		  (
		  SELECT pos FROM choose_element
		  )
	  
	  
	  
	  
	  
		
		SELECT step, ARRAY_AGG( CASE WHEN pos = (TABLE max_pos) THEN 0 ELSE elem END +
		
		
		                (TABLE max_val)/(TABLE cardinality) + 
		                   CASE WHEN pos > (TABLE max_pos) THEN
								 CASE WHEN pos - (TABLE max_pos) <= MOD((TABLE max_val),(TABLE cardinality))
										THEN 1 
									ELSE 
										0 END
								 WHEN  pos < (TABLE max_pos) THEN
								  CASE WHEN (TABLE cardinality)- (TABLE max_pos) + pos <= MOD((TABLE max_val),(TABLE cardinality))
										THEN 1 
									ELSE 
										0 END
								ELSE 0 END 
		                        
		
		                  
		              ORDER BY pos) AS block

			FROM cte
			WHERE step < 50000
			GROUP BY step
			
			
	  ) AS dt
	
		
)


SELECT   LEAD(step) OVER w  - step AS length_cycle FROM reallocation
 WINDOW w AS (PARTITION BY block ORDER BY step)
 ORDER BY length_cycle
 LIMIT 1;
 
 









































CREATE OR REPLACE FUNCTION reduce_dim(anyarray)
RETURNS SETOF anyarray
LANGUAGE plpgsql
AS $function$
DECLARE s $1%type;
BEGIN
FOREACH s SLICE 1 IN ARRAY $1 LOOP
RETURN NEXT s;
END LOOP;
RETURN;
END;
$function$;