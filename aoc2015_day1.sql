SET lc_messages TO 'en_US.UTF-8';



CREATE SERVER aoc2015 FOREIGN  DATA wrapper file_fdw;




CREATE FOREIGN TABLE aoc2015_day1 (x TEXT)
SERVER aoc2015 options(filename 'D:\aoc2015.day1.input');



CREATE  TEMPORARY TABLE building
(
	floors TEXT
);

INSERT INTO building
TABLE aoc2015_day1;


-- Part 1


SELECT REGEXP_COUNT(floors, '\(') -  REGEXP_COUNT(floors, '\)') FROM building;



--Part 2



WITH cte AS
(
	SELECT pos, SUM(CASE WHEN ground = '(' THEN 1 ELSE -1 END) OVER (ORDER BY pos) AS basement
	FROM building CROSS JOIN STRING_TO_TABLE(floors,NULL) WITH ORDINALITY AS t( ground, pos)

)

SELECT pos FROM cte WHERE basement < 0 ORDER BY pos LIMIT 1;