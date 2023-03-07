SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2015_day17(x text)
SERVER aoc2018 options(filename 'D:\aoc2015.day17.input');


CREATE TEMPORARY TABLE containers
(
	id SERIAL,
	volume INT
	
	
);

INSERT INTO containers(volume)
SELECT x::INT FROM aoc2015_day17;


SELECT c1.volume + c2.volume + c3.volume AS total
FROM containers c1
JOIN containers c2
	ON c1.id != c2.id
JOIN containers c3
	ON c2.id != c3.id
	AND c1.id != c3.id
ORDER BY total DESC;






-- Part 1


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


-- Part 2


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

