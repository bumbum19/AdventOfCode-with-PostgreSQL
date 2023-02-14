SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2015_day4 (x TEXT)
SERVER aoc2015 options(filename 'D:\aoc2015.day4.input');




CREATE TEMPORARY TABLE coin
(

	secret_key TEXT
);


INSERT INTO coin 
TABLE aoc2015_day4;


-- Part 1

SELECT id 
FROM coin 
CROSS JOIN  GENERATE_SERIES(1, 1000000) AS id
CROSS JOIN LATERAL (VALUES(SUBSTR(MD5(secret_key|| id::TEXT), 1, 5))) AS dt(first_five)
WHERE SUBSTR(first_five, 1, 5) = '00000'
ORDER BY id
LIMIT 1;




-- Part 2

SELECT id 
FROM coin 
CROSS JOIN  GENERATE_SERIES(1, 10000000) AS id
CROSS JOIN LATERAL (VALUES(SUBSTR(MD5(secret_key|| id::TEXT), 1, 6))) AS dt(first_six)
WHERE SUBSTR(first_six, 1, 6) = '000000'
ORDER BY id
LIMIT 1;




10000000
254575
1038736