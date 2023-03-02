--- Day 12: Rain Risk ---

/*

Your ferry made decent progress toward the island, but the storm came in faster than anyone expected. The ferry needs to take evasive actions!

Unfortunately, the ship's navigation computer seems to be malfunctioning; rather than giving a route directly to safety, it produced extremely circuitous instructions.
When the captain uses the PA system to ask if anyone can help, you quickly volunteer.

The navigation instructions (your puzzle input) consists of a sequence of single-character actions paired with integer input values. After staring at them for a few minutes,
you work out what they probably mean:

   - Action N means to move north by the given value.
   - Action S means to move south by the given value.
   - Action E means to move east by the given value.
   - Action W means to move west by the given value.
   - Action L means to turn left the given number of degrees.
   - Action R means to turn right the given number of degrees.
   - Action F means to move forward by the given value in the direction the ship is currently facing.

The ship starts by facing east. Only the L and R actions change the direction the ship is facing. (That is, if the ship is facing east and the next instruction is N10, 
the ship would move north 10 units, but would still move east if the following action were F.)

For example:

F10
N3
F7
R90
F11

These instructions would be handled as follows:

   - F10 would move the ship 10 units east (because the ship starts by facing east) to east 10, north 0.
   - N3 would move the ship 3 units north to east 10, north 3.
   - F7 would move the ship another 7 units east (because the ship is still facing east) to east 17, north 3.
   - R90 would cause the ship to turn right by 90 degrees and face south; it remains at east 17, north 3.
   - F11 would move the ship 11 units south to east 17, south 8.

At the end of these instructions, the ship's Manhattan distance (sum of the absolute values of its east/west position and its north/south position) from 
its starting position is 17 + 8 = 25.

Figure out where the navigation instructions lead. What is the Manhattan distance between that location and the ship's starting position?

*/


-- Read data

CREATE FOREIGN TABLE aoc2020_day12 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day12.input');


-- Create base table


CREATE TEMPORARY TABLE instructions
(  
	id SERIAL,
	move CHAR,
	val INT
);

-- Insert data

INSERT INTO instructions(move, val)
SELECT 
SUBSTR(x, 1, 1),
SUBSTR(x, 2)::INT
FROM aoc2020_day21;




-- First Star


WITH RECURSIVE cte(step, x, y, orientation) AS 
(
	SELECT 0, 0, 0, 'E' 
	UNION ALL
	SELECT step + 1,
	CASE WHEN move = 'E' THEN x + val
		 WHEN move = 'W' THEN x - val
		 WHEN move = 'F' AND orientation = 'E' THEN x + val
		 WHEN move = 'F' AND orientation = 'W' THEN x - val
	ELSE x END,
	CASE WHEN move = 'N' THEN y + val
		 WHEN move = 'S' THEN y - val
		 WHEN move = 'F' AND orientation = 'N' THEN y + val
		 WHEN move = 'F' AND orientation = 'S' THEN y - val
	ELSE y END,
	CASE WHEN orientation = 'N' THEN 
			CASE WHEN move = 'R' THEN
					CASE WHEN val = 90 THEN 'E'
						WHEN val = 180 THEN 'S'
						ELSE 'W' END
				WHEN  move = 'L' THEN
					CASE WHEN val = 90 THEN 'W'
						WHEN val = 180 THEN 'S'
						ELSE 'E' END
				
				ELSE orientation END
		
		
		WHEN orientation = 'S' THEN 
			CASE WHEN move = 'R' THEN
					CASE WHEN val = 90 THEN 'W'
						WHEN val = 180 THEN 'N'
						ELSE 'E' END
				WHEN  move = 'L' THEN
					CASE WHEN val = 90 THEN 'E'
						WHEN val = 180 THEN 'N'
					ELSE 'W' END
				ELSE orientation END
				
				
		WHEN orientation = 'E' THEN 
			CASE WHEN move = 'R' THEN
					CASE WHEN val = 90 THEN 'S'
					WHEN val = 180 THEN 'W'
					ELSE 'N' END
				WHEN  move = 'L' THEN
					CASE WHEN val = 90 THEN 'N'
					WHEN val =  180 THEN 'W'
					ELSE 'S' END
				
				ELSE orientation END
		
		WHEN orientation = 'W' THEN 
			CASE WHEN move = 'R' THEN
					CASE WHEN val = 90 THEN 'N'
					WHEN val = 180 THEN 'E'
					ELSE 'S' END
				WHEN  move = 'L' THEN
					CASE WHEN val = 90 THEN 'S'
					WHEN val =  180 THEN 'E'
					ELSE 'N' END
			ELSE orientation END
		 
		END
FROM cte c
JOIN instructions 
	ON id = step + 1

)

SELECT ABS(x) + ABS(y) FROM cte
ORDER BY step DESC
LIMIT 1 ;




--- Part Two ---

/*

Before you can give the destination to the captain, you realize that the actual action meanings were printed on the back of the instructions the whole time.

Almost all of the actions indicate how to move a waypoint which is relative to the ship's position:

    Action N means to move the waypoint north by the given value.
    Action S means to move the waypoint south by the given value.
    Action E means to move the waypoint east by the given value.
    Action W means to move the waypoint west by the given value.
    Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
    Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
    Action F means to move forward to the waypoint a number of times equal to the given value.

The waypoint starts 10 units east and 1 unit north relative to the ship. The waypoint is relative to the ship; that is, if the ship moves, the waypoint moves with it.

For example, using the same instructions as above:

   - F10 moves the ship to the waypoint 10 times (a total of 100 units east and 10 units north), leaving the ship at east 100, north 10. 
     The waypoint stays 10 units east and 1 unit north of the ship.
   - N3 moves the waypoint 3 units north to 10 units east and 4 units north of the ship. The ship remains at east 100, north 10.
   - F7 moves the ship to the waypoint 7 times (a total of 70 units east and 28 units north), leaving the ship at east 170, north 38. 
     The waypoint stays 10 units east and 4 units north of the ship.
   - R90 rotates the waypoint around the ship clockwise 90 degrees, moving it to 4 units east and 10 units south of the ship. The ship remains at east 170, north 38.
   - F11 moves the ship to the waypoint 11 times (a total of 44 units east and 110 units south), leaving the ship at east 214, south 72. 
     The waypoint stays 4 units east and 10 units south of the ship.

After these operations, the ship's Manhattan distance from its starting position is 214 + 72 = 286.

Figure out where the navigation instructions actually lead. What is the Manhattan distance between that location and the ship's starting position?




*/

WITH RECURSIVE cte(step, x_wp, y_wp, x_ship, y_ship) AS 
(
	SELECT 0, 10, 1, 0, 0 
	UNION ALL
	SELECT step + 1,
	CASE WHEN move = 'E' THEN x_wp + val
		 WHEN move = 'W' THEN x_wp - val
		 WHEN move = 'L' THEN 
			CASE WHEN val = 90 THEN -1 * y_wp
				 WHEN val = 180 THEN -1 * x_wp
				 WHEN val = 270 THEN  y_wp END
		WHEN move = 'R' THEN 
			CASE WHEN val = 90 THEN  y_wp
				 WHEN val = 180 THEN -1 * x_wp
				 WHEN val = 270 THEN -1* y_wp END
		ELSE x_wp
		END,
	CASE WHEN move = 'N' THEN y_wp + val
		 WHEN move = 'S' THEN y_wp - val
		 WHEN move = 'L' THEN 
			CASE WHEN val = 90 THEN x_wp
				 WHEN val = 180 THEN -1 * y_wp
				 WHEN val = 270 THEN -1 * x_wp  END 
		WHEN move = 'R' THEN 
			CASE WHEN val = 90 THEN -1 * x_wp
				 WHEN val = 180 THEN -1 * y_wp
				 WHEN val = 270 THEN x_wp END
		ELSE y_wp
		END,
		
		CASE WHEN move = 'F' THEN x_ship + val * x_wp
			ELSE x_ship END,
		CASE WHEN move = 'F' THEN y_ship + val * y_wp
			ELSE y_ship END
		
FROM cte c
JOIN instructions 
	ON id = step + 1

)

SELECT ABS(x_ship) + ABS(y_ship) FROM cte
ORDER BY step DESC
LIMIT 1 ;
