CREATE SERVER aoc2022 FOREIGN  DATA wrapper file_fdw;
 
 
 
CREATE FOREIGN TABLE aoc2022_day1 (calories INT)
SERVER aoc2022 options(filename 'D:\aoc2022.day1.input', NULL '');






CREATE TEMPORARY TABLE  elves (
  id  SERIAL ,
  calories INT
  );
  
INSERT INTO elves(calories)
SELECT * FROM aoc2022_day1;
 


-- Part 1 


WITH t AS 
(
  
  
SELECT calories, COUNT(*) FILTER  (WHERE calories IS NULL) OVER (ORDER BY id ) + 1 AS elf FROM elves
)



SELECT SUM(calories) AS answer FROM t GROUP BY elf ORDER BY SUM(calories) DESC  LIMIT 1;





-- Part 2

WITH t AS 
(
  
  
SELECT calories, COUNT(*) FILTER  (WHERE calories IS NULL) OVER (ORDER BY id ) + 1 AS elf FROM elves
),

t2 AS 
(
SELECT SUM(calories) AS calories FROM t GROUP BY elf ORDER BY SUM(calories) DESC  LIMIT 3
)

SELECT SUM(calories) AS answer FROM t2;
