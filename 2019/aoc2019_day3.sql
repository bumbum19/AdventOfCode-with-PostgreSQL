SET lc_messages TO 'en_US.UTF-8';




CREATE FOREIGN TABLE aoc2019_day3 (a text)
SERVER aoc2019 options(filename 'D:\aoc2019.day3.input');



CREATE TEMPORARY TABLE wires
(
	id SERIAL, 
	wire path
);





INSERT INTO wires(wire)

WITH cte AS
(
	SELECT a, ROW_NUMBER() OVER () AS rnk FROM aoc2019_day3

),
cte2 AS
(
	SELECT  n, rnk,
	CASE WHEN v LIKE 'R%' THEN RIGHT(v,-1)::INT WHEN v LIKE 'L%' THEN -1*RIGHT(v,-1)::INT ELSE 0 END AS x,
	CASE WHEN v LIKE 'U%' THEN RIGHT(v,-1)::INT WHEN v LIKE 'D%' THEN -1*RIGHT(v,-1)::INT ELSE 0 END AS y
    FROM cte CROSS JOIN  STRING_TO_TABLE(a,',') WITH ORDINALITY AS t(v, n)
),

cte3 AS
(
	SELECT n, rnk, 
	SUM(x) OVER w AS x, SUM(y) OVER w AS y 
	FROM cte2 WINDOW w AS (PARTITION BY rnk ORDER BY n)
	UNION
	VALUES (0,1,0,0)
	UNION
	VALUES (0,2,0,0)
	
	
	
)

SELECT  popen(string_agg(x::text|| ',' || y::text, ',' ORDER BY n)::path) AS path1 FROM cte3 
GROUP BY rnk;






-- Part 1



WITH  cte AS 

(

	SELECT BOX(POLYGON(PCLOSE(wire))) AS box FROM wires

),


enclosing_box AS
(
	SELECT (SELECT box FROM cte LIMIT 1) # (SELECT box FROM cte OFFSET 1) AS box

)
,


grid AS   

(
	SELECT * 
	FROM GENERATE_SERIES( (SELECT LEAST((box[0])[0],(box[1])[0])::INT    FROM  enclosing_box),
						  (SELECT GREATEST((box[0])[0],(box[1])[0])::INT FROM  enclosing_box)) AS x  
	CROSS JOIN  GENERATE_SERIES((SELECT LEAST((box[0])[1],(box[1])[1])::INT FROM  enclosing_box), 
								(SELECT GREATEST((box[0])[1],(box[1])[1])::INT FROM  enclosing_box)) AS y
	ORDER BY ABS(x) + ABS(y)
)

SELECT x + y AS min_distance FROM grid 
WHERE NOT EXISTS (SELECT * FROM wires WHERE NOT point(x,y) <@ wire) OFFSET 1 LIMIT 1;



-- Part 2


WITH cte AS 
(

	SELECT id ,n, REPLACE(REPLACE(v,'[(',''), ')]','') AS v
	FROM wires CROSS JOIN STRING_TO_TABLE( wire::text,'),(') WITH ORDINALITY AS t(v,n)

),


cte2 AS
(

	SELECT  id, n, 
	popen(string_agg(v, ',' ) OVER (PARTITION BY id ORDER BY n) ::path)  AS path 
	FROM cte 
	ORDER BY id, n
),


cte3 AS 
(



	SELECT a.n AS first_id, b.n AS second_id, (@-@ a.path)   +
	(@-@ b.path) AS total_length  
	FROM cte2 a JOIN cte2 b ON a.id < b.id AND a.path ?#  b.path
	ORDER BY total_length LIMIT 1
),

intersection_point AS 
(

	SELECT 
	(string_agg(v, ','  ORDER BY n)  FILTER (WHERE id = 1) ::lseg) # 
	(string_agg(v, ','  ORDER BY n)  FILTER (WHERE id = 2) ::lseg) 
	FROM cte 
	JOIN cte3 
		ON CASE WHEN id = 1 THEN n IN (first_id, first_id - 1) 
				ELSE n IN (second_id, second_id - 1) END

)


SELECT  SUM(@-@(path + (path '[(0,0),(0,0)]' + ( TABLE intersection_point))))
FROM cte2 JOIN cte3 
ON CASE WHEN id = 1 THEN n =  first_id - 1  
		ELSE n = second_id -1  END;









