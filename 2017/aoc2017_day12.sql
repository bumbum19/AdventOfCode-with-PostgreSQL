SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2017_day12 (x TEXT)
SERVER aoc2017 options(filename 'D:\aoc2017.day12.input');



CREATE TEMPORARY TABLE pipes
(
	id_1 INT,
	id_2 INT,
	PRIMARY KEY(id_1, id_2)
);

INSERT INTO pipes
SELECT SPLIT_PART(x, '<->', 1)::INT , z::INT 
FROM aoc2017_day12 
CROSS JOIN SPLIT_PART(x, '<->', 2) AS y
CROSS JOIN STRING_TO_TABLE(y, ',') AS z;




-- Part 1

 WITH RECURSIVE cte(id) AS
(
	SELECT 0
	UNION
	SELECT CASE WHEN id_1 != id THEN id_1 ELSE id_2 END
	FROM cte
	JOIN pipes
		  ON id IN (id_1, id_2)

)


SELECT COUNT(*) FROM cte;





-- Part 2


WITH RECURSIVE vertices(id) AS 
(

	SELECT id_1 FROM pipes
	UNION
    SELECT id_2 FROM pipes



),


 
cte(id, branch) AS 
(
    SELECT id, ROW_NUMBER() OVER () FROM vertices
	UNION 
	SELECT CASE WHEN id_1 != id THEN id_1 ELSE id_2 END, branch
	FROM cte 
	JOIN pipes 
		ON id IN (id_1, id_2)

),

cte2 AS
(

	SELECT DISTINCT ON (id) id, branch FROM cte
	ORDER BY id, branch
)



SELECT COUNT(DISTINCT branch) FROM cte2;