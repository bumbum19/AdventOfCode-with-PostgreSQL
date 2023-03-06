SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2015_day9(x text)
SERVER aoc2018 options(filename 'D:\aoc2015.day9.input');



CREATE TEMPORARY TABLE city_map
(
	city1 TEXT,
	city2 TEXT,
	distance INT



);






INSERT INTO city_map
SELECT 
SPLIT_PART(x, 'to', 1), 
SPLIT_PART(SPLIT_PART(x, ' to ', 2), '=', 1) ,
SPLIT_PART(SPLIT_PART(x, ' to ', 2), '=', 2)::INT 
FROM aoc2015_day9;








-- Part 1

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



-- Part 2 


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







