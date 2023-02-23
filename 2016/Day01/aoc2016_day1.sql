--- Day 1: No Time for a Taxicab ---

/*

Santa's sleigh uses a very high-precision clock to guide its movements, and the clock's oscillator is regulated by stars. 
Unfortunately, the stars have been stolen... by the Easter Bunny. To save Christmas, Santa needs you to retrieve all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. 
Each puzzle grants one star. Good luck!

You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near", unfortunately, is as close as you can get - 
the instructions on the Easter Bunny Recruiting Document the Elves intercepted start here, and nobody had time to work them out further.

The Document indicates that you should start at the given coordinates (where you just landed) and face North. 
Then, follow the provided sequence: either turn left (L) or right (R) 90 degrees, then walk forward the given number of blocks, ending at a new intersection.

There's no time to follow such ridiculous instructions on foot, though, so you take a moment and work out the destination. 
Given that you can only walk on the street grid of the city, how far is the shortest path to the destination?

For example:

   - Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
   - R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
   - R5, L5, R5, R3 leaves you 12 blocks away.

How many blocks away is Easter Bunny HQ?
*/



-- Create new server

CREATE SERVER aoc2016 FOREIGN  DATA wrapper file_fdw;


-- Read data

CREATE FOREIGN TABLE aoc2016_day1 (x TEXT)
SERVER aoc2016 options(filename 'D:\aoc2016.day1.input');


-- Create base table


CREATE  TEMPORARY TABLE walk
(
	step SERIAL,
	direction CHAR,
	moves INT
);


-- Insert data

INSERT INTO walk(direction, moves)
SELECT SUBSTR(TRIM(y),1,1), SUBSTR(TRIM(y),2)::INT FROM aoc2016_day1
CROSS JOIN STRING_TO_TABLE(x, ',') AS y ;



-- First Star


WITH RECURSIVE cte(step, direction, orientation) AS 

(

	SELECT step, direction, 1 FROM walk WHERE step = 1
	UNION ALL
	SELECT 	w.step, w.direction, 
	CASE WHEN MOD(w.step, 2) = 0 THEN CASE WHEN cte.direction = 'R' AND orientation = 1 
		OR cte.direction = 'L' AND orientation = -1 THEN 1 ELSE -1 END
	ELSE CASE WHEN cte.direction = 'R' AND orientation = 1 
		OR cte.direction = 'L' AND orientation = -1 THEN -1 ELSE 1 END
		END
	FROM walk w
	JOIN cte 
		ON w.step = cte.step + 1
	
)


SELECT ABS(SUM( CASE WHEN direction = 'R' AND orientation = 1 
		OR direction = 'L' AND orientation = -1 THEN moves ELSE -moves END) FILTER (WHERE MOD(step,2)  =1)) +  
       ABS(SUM( CASE WHEN direction = 'R' AND orientation = 1 
		OR direction = 'L' AND orientation = -1 THEN -moves ELSE moves END) FILTER (WHERE MOD(step,2)  =0) ) AS distance
FROM cte 
JOIN walk 
	USING (step, direction);
 
 
--- Part Two ---


/*

Then, you notice the instructions continue on the back of the Recruiting Document. Easter Bunny HQ is actually at the first location you visit twice.

For example, if your instructions are R8, R4, R4, R8, the first location you visit twice is 4 blocks away, due East.

How many blocks away is the first location you visit twice?

*/
 
-- Second Star
 
WITH RECURSIVE cte(step, direction, orientation) AS 
(
	SELECT step, direction, 1 FROM walk WHERE step = 1
	UNION ALL
	SELECT 	w.step, w.direction, 
	CASE WHEN MOD(w.step, 2) = 0 THEN CASE WHEN cte.direction = 'R' AND orientation = 1 
		OR cte.direction = 'L' AND orientation = -1 THEN 1 ELSE -1 END
	ELSE CASE WHEN cte.direction = 'R' AND orientation = 1 
		OR cte.direction = 'L' AND orientation = -1 THEN -1 ELSE 1 END
		END
	FROM walk w
	JOIN cte 
		ON w.step = cte.step + 1
),

cte2 AS 
(

	SELECT step, COALESCE(SUM( CASE WHEN direction = 'R' AND orientation = 1 
			OR direction = 'L' AND orientation = -1 THEN moves ELSE -moves END) FILTER (WHERE MOD(step,2)  =1) OVER w, 0) AS x, 
			
		  COALESCE(SUM( CASE WHEN direction = 'R' AND orientation = 1 
			OR direction = 'L' AND orientation = -1 THEN -moves ELSE moves END) FILTER (WHERE MOD(step,2)  =0) OVER w, 0) AS y
	FROM cte 
	JOIN walk 
		USING (step, direction)
	WINDOW w AS (ORDER BY step)
	UNION ALL SELECT 0, 0, 0
),

cte3 AS 
(

	SELECT step, LSEG(POINT(x,y), POINT(LEAD(x) OVER w, LEAD(y) OVER w)) AS line
	FROM cte2
	WINDOW w AS (ORDER BY step)



)



SELECT  ABS((a.line # b.line)[0]) + ABS((a.line # b.line)[1]) AS answer
FROM cte3 a 
JOIN cte3 b
	ON a.step < b.step - 1
	AND a.line ?# b.line
ORDER BY b.step
LIMIT 1;






