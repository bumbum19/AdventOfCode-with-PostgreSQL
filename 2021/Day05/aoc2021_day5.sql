
--- Day 5: Hydrothermal Venture ---

/*

You come across a field of hydrothermal vents on the ocean floor! These vents constantly produce large, opaque clouds, so it would be best to avoid them if possible.

They tend to form in lines; the submarine helpfully produces a list of nearby lines of vents (your puzzle input) for you to review. For example:

0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2

Each line of vents is given as a line segment in the format x1,y1 -> x2,y2 where x1,y1 are the coordinates of one end the line segment and x2,y2 are 
the coordinates of the other end. These line segments include the points at both ends. In other words:

   - An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
   - An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.

For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2.

So, the horizontal and vertical lines from the above list would produce the following diagram:

.......1..
..1....1..
..1....1..
.......1..
.112111211
..........
..........
..........
..........
222111....

In this diagram, the top left corner is 0,0 and the bottom right corner is 9,9. Each position is shown as the number of lines which cover that point or .
if no line covers that point. The top-left pair of 1s, for example, comes from 2,2 -> 2,1; the very bottom row is formed by the overlapping lines 0,9 -> 5,9 and 0,9 -> 2,9.

To avoid the most dangerous areas, you need to determine the number of points where at least two lines overlap. In the above example, this is anywhere in the diagram 
with a 2 or larger - a total of 5 points.

Consider only horizontal and vertical lines. At how many points do at least two lines overlap
?
*/



CREATE FOREIGN TABLE aoc2021_day5 (a text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day5.input');
 



CREATE TEMPORARY TABLE  hydrothermal  
(
      x1  INT,
      y1  INT,
      x2  INT,
      y2  INT,
      PRIMARY KEY (x1,y1,x2,y2)
);

INSERT INTO hydrothermal
SELECT 
SPLIT_PART(REPLACE(a,' -> ', ','),',',1)::INT,
SPLIT_PART(REPLACE(a,' -> ', ','),',',2)::INT,
SPLIT_PART(REPLACE(a,' -> ', ','),',',3)::INT,
SPLIT_PART(REPLACE(a,' -> ', ','),',',4)::INT 
FROM aoc2021_day5;




-- Solution


WITH grid AS NOT MATERIALIZED 
(
   SELECT x,y
   FROM GENERATE_SERIES(0,999) AS x 
   CROSS JOIN GENERATE_SERIES(0,999) AS y
),


hydrothermal_vert AS
(
   SELECT x1, y1, y2 FROM  hydrothermal 
   WHERE x1 = x2 
),


hydrothermal_horiz  AS
(
   SELECT y1, x1, x2  FROM  hydrothermal 
   WHERE y1 = y2 
),

cte AS 
(
   SELECT x,y
   FROM grid 
   JOIN hydrothermal_vert  
      ON ( y  >=y1 AND y <= y2 OR  y  >=y2 AND y <= y1 )  
      AND x = x1  
   UNION ALL
   SELECT x,y
   FROM grid 
   JOIN hydrothermal_horiz  
      ON (x  >=x1 AND x <= x2 OR  x  >=x2 AND x <= x1 )  
      AND y = y1
),
 
cte2 AS 
(
   SELECT x,y FROM cte 
   GROUP BY x,y 
   HAVING COUNT(*) >= 2
)

SELECT COUNT(*) FROM cte2;


--- Part Two ---

/*

Unfortunately, considering only horizontal and vertical lines doesn't give you the full picture; you need to also consider diagonal lines.

Because of the limits of the hydrothermal vent mapping system, the lines in your list will only ever be horizontal, vertical, or a diagonal line at exactly 45 degrees. 
In other words:

   - An entry like 1,1 -> 3,3 covers points 1,1, 2,2, and 3,3.
   - An entry like 9,7 -> 7,9 covers points 9,7, 8,8, and 7,9.

Considering all lines from the above example would now produce the following diagram:

1.1....11.
.111...2..
..2.1.111.
...1.2.2..
.112313211
...1.2....
..1...1...
.1.....1..
1.......1.
222111....

You still need to determine the number of points where at least two lines overlap. In the above example, this is still anywhere in the diagram with a 2 or 
larger - now a total of 12 points.

Consider all of the lines. At how many points do at least two lines overlap?
*/


-- Solution

-- Query may need about 10 seconds!!!


WITH grid AS NOT MATERIALIZED (
    SELECT x,y
FROM GENERATE_SERIES(0,999) AS x CROSS JOIN GENERATE_SERIES(0,999) AS y
),


hydrothermal_vert AS

(SELECT x1, y1, y2 FROM   hydrothermal WHERE 
x1 = x2 ),

hydrothermal_horiz  AS
(SELECT y1, x1, x2  FROM   hydrothermal WHERE 
y1 = y2 ),

hydrothermal_diag1 AS
(SELECT  x1, y1, x2, y2 FROM hydrothermal WHERE 
x1 - x2 = y1 - y2 
 ),
 
hydrothermal_diag2 AS

(SELECT  x1, y1, x2, y2 FROM hydrothermal WHERE 
 x1 - x2 = -(y1 - y2) 
 ),

cte AS 
(SELECT x,y
FROM grid 
JOIN hydrothermal_vert ON 
 ( y  >=y1 AND y <= y2 OR  y  >=y2 AND y <= y1 )  AND x = x1  

 UNION ALL

SELECT x,y
FROM grid 
JOIN hydrothermal_horiz ON 
 ( x  >=x1 AND x <= x2 OR  x  >=x2 AND x <= x1 )  AND y = y1
 
 UNION ALL

 SELECT x,y
FROM grid 
JOIN hydrothermal_diag1 ON 
 ( x  >=x1 AND x <= x2 OR  x  >=x2 AND x <= x1 )   AND (x - x1 = y - y1)
 
 UNION ALL

SELECT x,y
FROM grid 
JOIN hydrothermal_diag2 ON 
 ( x  >=x1 AND x <= x2 OR  x  >=x2 AND x <= x1 )   AND (x - x1 = -(y - y1))
 ),
 
cte2 AS 
(SELECT x,y FROM cte GROUP BY x,y HAVING COUNT(*) >= 2)

SELECT COUNT(*) FROM cte2;


