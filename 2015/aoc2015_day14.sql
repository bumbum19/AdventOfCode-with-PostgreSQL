SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2015_day14(x text)
SERVER aoc2018 options(filename 'D:\aoc2015.day14.input');


CREATE TEMPORARY TABLE reindeers
(
	id SERIAL,
	name TEXT,
	speed INT,
	max_time INT,
	rest_time INT
	

);

INSERT INTO reindeers(name, speed, max_time, rest_time)
SELECT 
SPLIT_PART(x,' ', 1), 
SPLIT_PART(x,' ', 4)::INT,
SPLIT_PART(x,' ', 7)::INT, 
SPLIT_PART(x,' ', 14)::INT
FROM aoc2015_day14;


----



CREATE TEMPORARY TABLE reindeers
(
	id SERIAL,
	name TEXT,
	speed INT,
	max_time INT,
	rest_time INT
	

);

INSERT INTO reindeers(name, speed, max_time, rest_time)
VALUES
('Comet', 14, 10, 127),
('Dancer', 16, 11, 162);







 
 
 -- Part 1
 
SELECT speed * DIV(2503, max_time + rest_time)* max_time + 
	CASE WHEN MOD(2503, max_time + rest_time) >= max_time 
			THEN max_time * speed 
		ELSE 
			MOD(2503, max_time + rest_time) * speed END AS distance
FROM reindeers
ORDER BY distance DESC
LIMIT 1;
 
 
-- Part 2

SELECT COUNT(*) AS points
FROM GENERATE_SERIES(1, 2503) AS travel_time
CROSS JOIN LATERAL 
(
	SELECT id
	FROM reindeers
	CROSS JOIN LATERAL 
	(
		VALUES(
				speed * DIV(travel_time, max_time + rest_time)* max_time + 
					CASE WHEN MOD(travel_time, max_time + rest_time) >= max_time 
							THEN max_time * speed 
						ELSE 
							MOD(travel_time, max_time + rest_time) * speed END
			   )
    ) AS t(distance)
	ORDER BY distance DESC
	LIMIT 1
) AS dt
GROUP BY id
ORDER BY points DESC
LIMIT 1;
