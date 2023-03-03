SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2019_day6 (x text)
SERVER aoc2019 options(filename 'D:\aoc2019.day6.input');



CREATE FOREIGN TABLE aoc2019_day6_test (x text)
SERVER aoc2019 options(filename 'D:\aoc2019.day6_test.input');


CREATE TEMPORARY TABLE orbits
(
	orbit1 TEXT,
	orbit2 TEXT

);



INSERT INTO orbits
SELECT SPLIT_PART(x, ')', 1), SPLIT_PART(x, ')', 2)
FROM aoc2019_day6_test;





-- Part 1





WITH RECURSIVE orbits_search(e1, e2) AS 
(
	SELECT orbit2, orbit1 FROM orbits
	UNION 
	SELECT e1, orbit1 
	FROM orbits
	JOIN orbits_search
		ON orbit2 = e2
	
)


SELECT COUNT(*) FROM orbits_search;


-- Part 2


WITH RECURSIVE orbits_simple AS 
(
	TABLE orbits
	UNION ALL
	SELECT orbit2, orbit1 FROM orbits

),


orbits_search(e1, e2, depth) AS 
(
	SELECT orbit1, orbit2, 1  
	FROM orbits_simple 
	WHERE orbit1 = 'YOU' OR orbit2 = 'YOU'
	UNION  ALL
	SELECT orbit1, orbit2, os.depth + 1
	FROM orbits_simple o
	JOIN orbits_search os
		ON orbit1 = e2
	
) CYCLE e1 SET is_cycle USING path


SELECT depth - 2 
FROM orbits_search
WHERE e2 = 'SAN'
ORDER BY depth 
LIMIT 1;
