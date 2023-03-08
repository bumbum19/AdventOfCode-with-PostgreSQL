--- Day 9: All in a Single Night ---


/*

Every year, Santa manages to deliver all of his presents in a single night.

This year, however, he has some new locations to visit; his elves have provided him the distances between every pair of locations. 
He can start and end at any two (different) locations he wants, but he must visit each location exactly once. What is the shortest distance he can travel to achieve this?

For example, given the following distances:

London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141

The possible routes are therefore:

Dublin -> London -> Belfast = 982
London -> Dublin -> Belfast = 605
London -> Belfast -> Dublin = 659
Dublin -> Belfast -> London = 659
Belfast -> Dublin -> London = 605
Belfast -> London -> Dublin = 982

The shortest of these is London -> Dublin -> Belfast = 605, and so the answer is 605 in this example.

What is the distance of the shortest route?

*/



-- Read data

CREATE FOREIGN TABLE aoc2015_day9(x text)
SERVER aoc2015 options(filename 'D:\aoc2015.day9.input');



-- Create base table

CREATE TEMPORARY TABLE city_map
(
	city1 TEXT,
	city2 TEXT,
	distance INT

);



-- Insert data


INSERT INTO city_map
SELECT 
SPLIT_PART(x, 'to', 1), 
SPLIT_PART(SPLIT_PART(x, ' to ', 2), '=', 1) ,
SPLIT_PART(SPLIT_PART(x, ' to ', 2), '=', 2)::INT 
FROM aoc2015_day9;



-- First Star

WITH RECURSIVE city_map_all AS
(
	TABLE city_map
	UNION ALL 
	SELECT city2, city1, distance FROM city_map
),



search_map(city1, city2, total_distance, depth) AS 
(
	SELECT city1, city2, distance, 1
	FROM city_map
	UNION ALL
	SELECT cm.city1, cm.city2, total_distance + distance, sm.depth + 1
	FROM city_map_all cm
	JOIN search_map sm
		ON cm.city1 = sm.city2
) CYCLE city1 SET is_cycle USING path

SELECT MIN(total_distance - distance) 
FROM search_map 
NATURAL JOIN city_map_all
WHERE  NOT is_cycle 
AND depth = (SELECT COUNT(DISTINCT city1)  FROM  city_map_all) ;



--- Part Two ---

/*

The next year, just to show off, Santa decides to take the route with the longest distance instead.

He can still start and end at any two (different) locations he wants, and he still must visit each location exactly once.

For example, given the distances above, the longest route would be 982 via (for example) Dublin -> London -> Belfast.

What is the distance of the longest route?

*/


-- Second Star


WITH RECURSIVE city_map_all AS
(
	TABLE city_map
	UNION ALL 
	SELECT city2, city1, distance FROM city_map


),



search_map(city1, city2, total_distance, depth) AS 
(
	SELECT city1, city2, distance, 1
	FROM city_map 
	UNION ALL
	SELECT cm.city1, cm.city2, total_distance + distance, sm.depth + 1
	FROM city_map_all cm
	JOIN search_map sm
		ON cm.city1 = sm.city2
) CYCLE city1 SET is_cycle USING path

SELECT MAX(total_distance - distance) 
FROM search_map 
NATURAL JOIN city_map_all
WHERE  NOT is_cycle 
AND depth = (SELECT COUNT(DISTINCT city1)  FROM  city_map_all) ;
