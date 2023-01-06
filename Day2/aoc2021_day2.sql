CREATE FOREIGN TABLE aoc2021_day2 (direction VARCHAR(7), steps INT)
SERVER aoc2021 options(filename 'D:\aoc2021.day2.input', delimiter ' ');
 
 
  CREATE TEMPORARY TABLE submarine (
  id  SERIAL,
  direction  VARCHAR(7),
  steps INT 
  
);


INSERT INTO submarine(direction, steps)
SELECT direction, steps FROM aoc2021_day2;
 
 
 
 -- Part 1
 
 
 SELECT 
 SUM(CASE WHEN direction = 'forward' THEN steps END ) *  
 SUM(CASE WHEN direction = 'down' THEN steps WHEN direction = 'up' THEN -steps END) AS answer
 FROM submarine;
 
 
 -- Part 2
 
 WITH cte AS 
 (SELECT direction, steps,  
  SUM(CASE WHEN direction = 'down' THEN steps 
		   WHEN direction = 'up' THEN -steps END) OVER (
				ORDER BY id ROWS UNBOUNDED PRECEDING) AS aim
  FROM submarine
  ) 
 

 
 SELECT 
 SUM(steps) * SUM(steps * aim) AS answer
 FROM cte WHERE direction = 'forward';
 
 