

CREATE FOREIGN TABLE aoc2017_day2 (x text)
SERVER aoc2017 options(filename 'D:\aoc2017.day2.input', DELIMITER ';');



CREATE  TEMPORARY TABLE spreadsheet
(
	id SERIAL,
	numbers INT[]
);


INSERT INTO spreadsheet(numbers)
SELECT  STRING_TO_ARRAY(REGEXP_REPLACE(x, '\s', ',', 'g'),',')::INT[] FROM aoc2017_day2;


-----------------
CREATE  TEMPORARY TABLE spreadsheet
(
	id SERIAL,
	numbers INT[]
);


INSERT INTO spreadsheet(numbers)
VALUES
(ARRAY[5,9,2,8]),
(ARRAY[9,4,7,3]),
(ARRAY[3,8,6,5]);


-- Part 1

WITH cte AS 
(
	SELECT id, MAX(num) - MIN(num) AS diff
	FROM spreadsheet CROSS JOIN  UNNEST(numbers) AS num
	GROUP BY id
)


SELECT SUM(diff) AS checksum FROM cte;


-- Part 2

WITH cte AS 
(
	SELECT id, num, pos
	FROM spreadsheet CROSS JOIN UNNEST(numbers)  WITH ORDINALITY AS t(num,pos)
)


SELECT SUM(GREATEST(a.num,b.num)/LEAST(a.num,b.num)) AS checksum
FROM cte a 
JOIN cte b 
	ON a.id = b.id 
	AND a.pos < b.pos
	AND GCD(a.num,b.num) IN (a.num,b.num);
	
	
	
11844


