--- Day 11: Hex Ed ---

/*

Crossing the bridge, you've barely reached the other side of the stream when a program comes up to you, clearly in distress. "It's my child process," she says, 
"he's gotten lost in an infinite grid!"

Fortunately for her, you have plenty of experience with infinite grids.

Unfortunately for you, it's a hex grid.

The hexagons ("hexes") in this grid are aligned such that adjacent hexes can be found to the north, northeast, southeast, south, southwest, and northwest:

  \ n  /
nw +--+ ne
  /    \
-+      +-
  \    /
sw +--+ se
  / s  \

You have the path the child process took. Starting where he started, you need to determine the fewest number of steps required to reach him. 
(A "step" means to move from the hex you are in to any adjacent hex.)

For example:

   - ne,ne,ne is 3 steps away.
   - ne,ne,sw,sw is 0 steps away (back where you started).
   - ne,ne,s,s is 2 steps away (se,se).
   - se,sw,se,sw,sw is 3 steps away (s,s,sw).
*/


-- Read data

CREATE FOREIGN TABLE aoc2017_day11 (x TEXT)
SERVER aoc2017 options(filename 'D:\aoc2017.day11.input');



-- Create base table

CREATE TEMPORARY TABLE hex_grid
(
	id SERIAL,
	move TEXT
	
);

-- Insert data

INSERT INTO hex_grid(move)
SELECT STRING_TO_TABLE(x, ',') FROM aoc2017_day11;




-- First Star

-- Just doing some computations in a finetly generated abelian group


WITH cte AS 
(
	SELECT 
	COUNT(*) FILTER (WHERE move = 's') AS s,
	COUNT(*) FILTER (WHERE move = 'n') AS n,
	COUNT(*) FILTER (WHERE move = 'ne') AS ne,
	COUNT(*) FILTER (WHERE move = 'sw') AS sw,
	COUNT(*) FILTER (WHERE move = 'nw') AS nw,
	COUNT(*) FILTER (WHERE move = 'se') AS se
	FROM hex_grid

)


SELECT 
CASE WHEN n > s THEN 
		CASE WHEN ne > sw THEN
			CASE WHEN nw > se THEN
				(n - s) + (ne - sw) + (nw - se) - LEAST(ne - sw, nw - se)
				ELSE 
				(ne - sw) + (n - s) + (se - nw) - LEAST(n - s, se - nw)
			END
			ELSE 
			CASE WHEN nw > se THEN
				(nw - se) + (sw - ne) + (n - s) - LEAST(sw - ne, n - s)
				ELSE 
				ABS(n - (s + (sw - ne)+ (se - nw))) 
			 END
			 END
	ELSE
		CASE WHEN ne > sw THEN
			CASE WHEN nw > se THEN
				ABS(s - (n + (nw - se)+ (ne - sw)))
				ELSE 
				(se - nw) + (s - n) + (ne - sw) - LEAST(s - n, ne - sw)
			END
			ELSE 
			CASE WHEN nw > se THEN
				(sw - ne) + (nw - se) + (s - n) - LEAST(nw - se, s - n)
				ELSE 
				(sw - ne) + (se - nw) + (s - n) - LEAST(sw - ne, se - nw)
			 END
			 END
	END 
FROM cte;





--- Part Two ---

/*

How many steps away is the furthest he ever got from his starting position?

*/


-- Second Star

WITH cte AS 
(
	SELECT 
	COUNT(*) FILTER (WHERE move = 's') OVER w AS s,
	COUNT(*) FILTER (WHERE move = 'n') OVER w AS n,
	COUNT(*) FILTER (WHERE move = 'ne') OVER w AS ne,
	COUNT(*) FILTER (WHERE move = 'sw') OVER w AS sw,
	COUNT(*) FILTER (WHERE move = 'nw') OVER w AS nw,
	COUNT(*) FILTER (WHERE move = 'se') OVER w AS se
	FROM hex_grid
	WINDOW w AS (ORDER BY id)

)


SELECT MAX(steps)
FROM cte 
CROSS JOIN LATERAL (VALUES(
CASE WHEN n > s THEN 
		CASE WHEN ne > sw THEN
			CASE WHEN nw > se THEN
				(n - s) + (ne - sw) + (nw - se) - LEAST(ne - sw, nw - se)
				ELSE 
				(ne - sw) + (n - s) + (se - nw) - LEAST(n - s, se - nw)
			END
			ELSE 
			CASE WHEN nw > se THEN
				(nw - se) + (sw - ne) + (n - s) - LEAST(sw - ne, n - s)
				ELSE 
				ABS(n - (s + (sw - ne)+ (se - nw))) 
			 END
			 END
	ELSE
		CASE WHEN ne > sw THEN
			CASE WHEN nw > se THEN
				ABS(s - (n + (nw - se)+ (ne - sw)))
				ELSE 
				(se - nw) + (s - n) + (ne - sw) - LEAST(s - n, ne - sw)
			END
			ELSE 
			CASE WHEN nw > se THEN
				(sw - ne) + (nw - se) + (s - n) - LEAST(nw - se, s - n)
				ELSE 
				(sw - ne) + (se - nw) + (s - n) - LEAST(sw - ne, se - nw)
			 END
			 END
	END 
)) AS t(steps);
