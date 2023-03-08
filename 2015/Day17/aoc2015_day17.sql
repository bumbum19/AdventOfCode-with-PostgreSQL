--- Day 17: No Such Thing as Too Much ---

/*

The elves bought too much eggnog again - 150 liters this time. To fit it all into your refrigerator, you'll need to move it into smaller containers. 
You take an inventory of the capacities of the available containers.

For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters. If you need to store 25 liters, there are four ways to do it:

   - 15 and 10
   - 20 and 5 (the first 5)
   - 20 and 5 (the second 5)
   - 15, 5, and 5

Filling all containers entirely, how many different combinations of containers can exactly fit all 150 liters of eggnog?

*/


-- Read data

CREATE FOREIGN TABLE aoc2015_day17(x text)
SERVER aoc2015 options(filename 'D:\aoc2015.day17.input');


-- Create base table


CREATE TEMPORARY TABLE containers
(
	id SERIAL,
	volume INT
	
);


-- Insert data

INSERT INTO containers(volume)
SELECT x::INT FROM aoc2015_day17;


-- First Star


WITH RECURSIVE search_map(id, total_volume) AS 
(
	SELECT id, volume
	FROM containers
	UNION ALL
	SELECT c.id, total_volume + volume
	FROM containers c
	JOIN search_map sm
		ON sm.id < c.id
	WHERE total_volume < 150
) CYCLE id SET is_cycle USING path


SELECT COUNT(*) FROM search_map 
WHERE total_volume = 150
AND NOT is_cycle;


--- Part Two ---

/*

While playing with all the containers in the kitchen, another load of eggnog arrives! The shipping and receiving department is requesting as many containers as you can spare.

Find the minimum number of containers that can exactly fit all 150 liters of eggnog. How many different ways can you fill that number of containers and 
still hold exactly 150 litres?

In the example above, the minimum number of containers was two. There were three ways to use that many containers, and so the answer there would be 3.
*/


-- Second Star

WITH RECURSIVE search_map(id, total_volume) AS 
(
	SELECT id, volume
	FROM containers
	UNION ALL
	SELECT c.id, total_volume + volume
	FROM containers c
	JOIN search_map sm
		ON sm.id < c.id
	WHERE total_volume < 150
) CYCLE id SET is_cycle USING path


SELECT COUNT(*) AS cnt
FROM search_map 
CROSS JOIN LATERAL (VALUES (CARDINALITY(path::TEXT[]))) AS t(n_elements)
WHERE total_volume = 150
AND NOT is_cycle
GROUP BY n_elements
ORDER BY n_elements
LIMIT 1;

