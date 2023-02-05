--- Day 3: Crossed Wires ---

/*

The gravity assist was successful, and you're well on your way to the Venus refuelling station. During the rush back on Earth, 
the fuel management system wasn't completely installed, so that's next on the priority list.

Opening the front panel reveals a jumble of wires. Specifically, two wires are connected to a central port and extend outward on a grid. 
You trace the path each wire takes as it leaves the central port, one wire per line of text (your puzzle input).

The wires twist and turn, but the two wires occasionally cross paths. To fix the circuit, you need to find the intersection point closest to the central port.
Because the wires are on a grid, use the Manhattan distance for this measurement. While the wires do technically cross right at the central port where they both start, 
this point does not count, nor does a wire count as crossing with itself.

For example, if the first wire's path is R8,U5,L5,D3, then starting from the central port (o), it goes right 8, up 5, left 5, and finally down 3:

...........
...........
...........
....+----+.
....|....|.
....|....|.
....|....|.
.........|.
.o-------+.
...........

Then, if the second wire's path is U7,R6,D4,L4, it goes up 7, right 6, down 4, and left 4:

...........
.+-----+...
.|.....|...
.|..+--X-+.
.|..|..|.|.
.|.-X--+.|.
.|..|....|.
.|.......|.
.o-------+.
...........

These wires cross at two locations (marked X), but the lower-left one is closer to the central port: its distance is 3 + 3 = 6.

Here are a few more examples:

    R75,D30,R83,U83,L12,D49,R71,U7,L72
    U62,R66,U55,R34,D71,R55,D58,R83 = distance 159
    R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
    U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = distance 135

What is the Manhattan distance from the central port to the closest intersection?

*/




-- Read data

CREATE FOREIGN TABLE aoc2019_day3 (a text)
SERVER aoc2019 options(filename 'D:\aoc2019.day3.input');


-- Create base table

CREATE TEMPORARY TABLE wires
(
	id SERIAL, 
	wire path
);

-- Insert data

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

SELECT  popen(string_agg(x::text|| ',' || y::text, ',' ORDER BY n)::path) FROM cte3 
GROUP BY rnk;






-- First Star

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

--- Part Two ---

/*

It turns out that this circuit is very timing-sensitive; you actually need to minimize the signal delay.

To do this, calculate the number of steps each wire takes to reach each intersection; choose the intersection where the sum of both wires' steps is lowest. 
If a wire visits a position on the grid multiple times, use the steps value from the first time it visits that position when calculating the total value of a specific intersection.

The number of steps a wire takes is the total number of grid squares the wire has entered to get to that location, including the intersection being considered.
Again consider the example from above:

...........
.+-----+...
.|.....|...
.|..+--X-+.
.|..|..|.|.
.|.-X--+.|.
.|..|....|.
.|.......|.
.o-------+.
...........

In the above example, the intersection closest to the central port is reached after 8+5+5+2 = 20 steps by the first wire and 7+6+4+3 = 20 steps by the second wire for a total of 20+20 = 40 steps.

However, the top-right intersection is better: the first wire takes only 8+5+2 = 15 and the second wire takes only 7+6+2 = 15, a total of 15+15 = 30 steps.

Here are the best steps for the extra examples from above:

   - R75,D30,R83,U83,L12,D49,R71,U7,L72
     U62,R66,U55,R34,D71,R55,D58,R83 = 610 steps
   - R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
     U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = 410 steps

What is the fewest combined steps the wires must take to reach an intersection?


*/


-- Second Star


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


SELECT  SUM(@-@(path + (path '[(0,0)]' + ( TABLE intersection_point))))
FROM cte2 JOIN cte3 
ON CASE WHEN id = 1 THEN n =  first_id - 1  
		ELSE n = second_id -1  END;









