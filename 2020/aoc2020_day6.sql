CREATE FOREIGN TABLE aoc2020_day6 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day6.input',NULL '');


CREATE TEMPORARY TABLE declaration_form
(
	id SERIAL,
	team INT,
	questions CHAR[]
);

INSERT INTO declaration_form(team, questions)

WITH cte AS 
(
 SELECT x, ROW_NUMBER() OVER () AS row_num FROM aoc2020_day6


),

cte2 AS 
(
SELECT  COUNT(*) FILTER (WHERE x IS NULL) OVER (ORDER BY row_num)  , STRING_TO_ARRAY(x,NULL) AS x 
FROM cte 
)

SELECT * FROM cte2 WHERE x IS NOT NULL;


-- Part 1

WITH cte AS 
(

	SELECT  CARDINALITY(ARRAY_AGG(DISTINCT x)) AS dim
	FROM declaration_form CROSS JOIN UNNEST(questions) AS x  GROUP BY team 

)


SELECT SUM(dim) FROM cte;


-- Part 2

CREATE OR REPLACE FUNCTION ARRAY_UNIQUE_INTERSECT(a ANYARRAY, b ANYARRAY) RETURNS ANYARRAY
    AS 'WITH cte(element) AS 
	     (SELECT UNNEST(a)  
		 INTERSECT
		 SELECT  UNNEST(b) 
		 )
		 SELECT ARRAY_AGG(element) FROM cte;'
		LANGUAGE SQL
		IMMUTABLE
	    RETURNS NULL ON NULL INPUT; 
	
	
CREATE OR REPLACE AGGREGATE ARRAY_UNIQUE_INTERSECT_AGG (ANYARRAY)
(
    sfunc = ARRAY_UNIQUE_INTERSECT,
    stype = ANYARRAY
);




WITH cte AS 
(

	SELECT team, CARDINALITY(ARRAY_UNIQUE_INTERSECT_AGG(questions)) AS dim
	FROM declaration_form   GROUP BY team 

)


SELECT SUM(dim) FROM cte ;



