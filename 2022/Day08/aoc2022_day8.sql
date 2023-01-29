CREATE FOREIGN TABLE aoc2022_day8(x text)
 SERVER aoc2022 options(filename 'D:\aoc2022.day8.input');
 
 
 
 
 CREATE TEMPORARY TABLE  forest  (
  x  SERIAL,
  heights  INT[]
  );
  
  
  
INSERT INTO forest(heights)
SELECT STRING_TO_ARRAY(x, NULL)::INT[] FROM aoc2022_day8;
 

----------------------------
 CREATE TEMPORARY TABLE  forest  (
  x  SERIAL,
  heights  INT[]
  );
  

INSERT INTO  forest(heights)
VALUES 
(STRING_TO_ARRAY('30373',NULL)::INT[]),
(STRING_TO_ARRAY('25512',NULL)::INT[]),
(STRING_TO_ARRAY('65332',NULL)::INT[]),
(STRING_TO_ARRAY('33549',NULL)::INT[]),
(STRING_TO_ARRAY('35390',NULL)::INT[])
;



-- Part 1

 
WITH cte AS 
(
 
	SELECT x, y, height,
	COALESCE(MAX(height) OVER (PARTITION BY x ORDER BY y RANGE BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ),-1) AS west,
	COALESCE(MAX(height) OVER (PARTITION BY x ORDER BY y DESC RANGE BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ),-1) AS east,
	COALESCE(MAX(height) OVER (PARTITION BY y ORDER BY x RANGE BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ),-1) AS north,
	COALESCE(MAX(height) OVER (PARTITION BY y ORDER BY x DESC RANGE BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING ),-1) AS south
	FROM forest 
	CROSS JOIN UNNEST(heights) WITH ORDINALITY AS t (height, y)
)



SELECT COUNT(*) FROM cte WHERE height > west   OR height > east OR height > north OR height > south ;





-- Part 2

WITH cte AS
(
	SELECT x, y, height
	FROM forest 
	CROSS JOIN UNNEST(heights) WITH ORDINALITY AS t (height, y)
),


 look_left AS 
(

	SELECT DISTINCT ON (a.x, a.y) a.*, COALESCE(a.y - b.y, a.y -1) AS left_score FROM cte a LEFT JOIN cte b ON
	a.x = b.x AND b.y < a.y AND b.height >= a.height
	ORDER BY a.x, a.y, b.y DESC
),



look_right AS

(
	SELECT DISTINCT ON (a.x, a.y) a.*, COALESCE(b.y - a.y, (SELECT CARDINALITY(heights) FROM forest LIMIT 1)- a.y
	) AS right_score FROM cte a LEFT JOIN cte b ON
	a.x = b.x AND b.y > a.y AND b.height >= a.height
	ORDER BY a.x, a.y, b.y 
	
),

 look_up AS 
(

	SELECT DISTINCT ON (a.x, a.y) a.*, COALESCE(a.x - b.x, a.x -1) AS up_score FROM cte a LEFT JOIN cte b ON
	a.x > b.x AND b.y = a.y AND b.height >= a.height
	ORDER BY a.x, a.y, b.x DESC
),


 look_down AS 
(

	SELECT DISTINCT ON (a.x, a.y) a.*, COALESCE(b.x - a.x, (SELECT COUNT(*) FROM forest )- a.x
	) AS down_score FROM cte a LEFT JOIN cte b ON
	a.x < b.x AND b.y = a.y AND b.height >= a.height
	ORDER BY a.x, a.y, b.x 
)

SELECT left_score *  right_score * up_score * down_score AS scenic_score
FROM look_left 
NATURAL JOIN  look_right  
NATURAL JOIN  look_up  
NATURAL JOIN  look_down
ORDER BY scenic_score DESC
LIMIT 1

;
























