
CREATE FOREIGN TABLE aoc2022_day3 (x text)
SERVER aoc2022 options(filename 'D:\aoc2022.day3.input');



CREATE TEMPORARY TABLE  rucksack (
  id  SERIAL ,
  item TEXT
  );


INSERT INTO rucksack(item)
SELECT
*
FROM aoc2022_day3;




-- Part 1


WITH t AS 
(
SELECT id,  SUBSTR(item, 1,LENGTH(item)/2) AS first_comp , SUBSTR(item,LENGTH(item)/2+1) AS second_comp FROM rucksack
),

cte1 AS 
(
SELECT DISTINCT id, lit  FROM t CROSS JOIN STRING_TO_TABLE(first_comp, NULL) AS lit
),

cte2 AS 
(
SELECT DISTINCT id, lit  FROM t CROSS JOIN STRING_TO_TABLE(second_comp, NULL) AS lit
)

SELECT SUM(CASE WHEN lit = LOWER(lit) THEN ASCII(lit)-96 ELSE  ASCII(lit)-38 END)
AS answer
FROM cte1 NATURAL JOIN cte2 ;





-- Part 2



WITH t AS 
(
SELECT id,  item, NTILE((SELECT COUNT(*)/3 FROM rucksack)::INT ) OVER (ORDER BY id) AS bucket FROM rucksack
),

cte1 AS 
(
SELECT DISTINCT bucket, lit  FROM t CROSS JOIN STRING_TO_TABLE(item, NULL) AS lit
WHERE MOD(id,3) = 1

),

cte2 AS 
(
SELECT DISTINCT bucket, lit  FROM t CROSS JOIN STRING_TO_TABLE(item, NULL) AS lit
WHERE MOD(id,3) = 2

),
cte3 AS 
(
SELECT DISTINCT bucket, lit  FROM t CROSS JOIN STRING_TO_TABLE(item, NULL) AS lit
WHERE MOD(id,3) = 0

)

SELECT SUM(CASE WHEN lit = LOWER(lit) THEN ASCII(lit)-96 ELSE  ASCII(lit)-38 END)
AS answer FROM cte1 NATURAL JOIN cte2 NATURAL JOIN cte3;

