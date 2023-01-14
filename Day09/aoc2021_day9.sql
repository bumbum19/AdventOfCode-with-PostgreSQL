--- Day 9: Smoke Basin ---

/*

These caves seem to be lava tubes. Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.

If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of 
the floor of the nearby caves for you (your puzzle input).

Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:

2199943210
3987894921
9856789892
8767896789
9899965678

Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.

Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four 
adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. 
(Diagonal locations do not count as adjacent.)

In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), 
and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.

The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. 
The sum of the risk levels of all low points in the heightmap is therefore 15.

Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?
*/

-- Setup

CREATE FOREIGN TABLE aoc2021_day9 (a text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day9.input');



 
 CREATE TEMPORARY TABLE  lava_tubes  (
  id  SERIAL,
  heights  INT[]
  );
  
  
INSERT INTO lava_tubes(heights)
SELECT STRING_TO_ARRAY(a, NULL)::INT[] FROM aoc2021_day9;




-- Solution

	
WITH t AS 

(
SELECT id AS x, y, height
FROM lava_tubes 
CROSS JOIN UNNEST(heights) WITH ORDINALITY AS q(height, y)
),


t2 AS
(
SELECT *, 
LAG(height) OVER (PARTITION BY x ORDER BY y) AS west,
LEAD(height) OVER (PARTITION BY x ORDER BY y) AS east,
LAG(height) OVER (PARTITION BY y ORDER BY x) AS north,
LEAD(height) OVER (PARTITION BY y ORDER BY x) AS south

FROM t
),


t3 AS 

(
SELECT *, 
LAG(north) OVER (PARTITION BY x ORDER BY y) AS north_west,
LEAD(north) OVER (PARTITION BY x ORDER BY y) AS north_east,
LAG(south) OVER (PARTITION BY x ORDER BY y) AS south_west,
LEAD(south) OVER (PARTITION BY x ORDER BY y) AS south_east

FROM t2
)

SELECT MAX(height) AS answer FROM t3  
WHERE CASE  
WHEN LEAST(east, west, north, south, north_east, 
	 north_west, south_east, south_west) >= height
THEN TRUE ELSE FALSE END  ;




--- Part Two ---

/*

Next, you need to find the largest basins so you know what areas are most important to avoid.

A basin is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. 
Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.

The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.

The top-left basin, size 3:

2199943210
3987894921
9856789892
8767896789
9899965678

The top-right basin, size 9:

2199943210
3987894921
9856789892
8767896789
9899965678

The middle basin, size 14:

2199943210
3987894921
9856789892
8767896789
9899965678

The bottom-right basin, size 9:

2199943210
3987894921
9856789892
8767896789
9899965678

Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134.

What do you get if you multiply together the sizes of the three largest basins?



*/

-- Solution

-- Query may need about 5 seconds!!!

WITH RECURSIVE cte AS 

(
SELECT id AS x, y, height
FROM lava_tubes 
CROSS JOIN UNNEST(heights) WITH ORDINALITY AS q(height, y)
),


cte2 AS
(
SELECT *, 
LAG(height) OVER (PARTITION BY x ORDER BY y) AS west,
LEAD(height) OVER (PARTITION BY x ORDER BY y) AS east,
LAG(height) OVER (PARTITION BY y ORDER BY x) AS north,
LEAD(height) OVER (PARTITION BY y ORDER BY x) AS south

FROM cte
),


t AS 

(
SELECT *, 
LAG(north) OVER (PARTITION BY x ORDER BY y) AS north_west,
LEAD(north) OVER (PARTITION BY x ORDER BY y) AS north_east,
LAG(south) OVER (PARTITION BY x ORDER BY y) AS south_west,
LEAD(south) OVER (PARTITION BY x ORDER BY y) AS south_east
FROM cte2
),

s (x, y, height, basin) AS 
(
SELECT x,y, height, ROW_NUMBER() OVER () 
FROM t WHERE CASE  
WHEN LEAST(east, west, north, south,north_east, 
	   north_west, south_east, south_west) >= height
THEN TRUE ELSE FALSE END

UNION 

SELECT cte.x,cte.y, cte.height, basin
FROM s JOIN cte 
ON  cte.x = s.x AND cte.y IN (s.y - 1, s.y + 1 )
OR  cte.y = s.y AND cte.x IN (s.x - 1, s.x + 1 )
WHERE s.height <= cte.height
AND cte.height < 9

),

h AS 

(
SELECT COUNT(*) AS cnt FROM s  GROUP BY basin ORDER BY cnt DESC LIMIT 3
)


SELECT ROUND(EXP(SUM(LN(cnt)))::NUMERIC,0) FROM h;




