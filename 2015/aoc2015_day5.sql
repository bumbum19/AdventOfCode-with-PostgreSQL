CREATE FOREIGN TABLE aoc2015_day5 (x TEXT)
SERVER aoc2015 options(filename 'D:\aoc2015.day5.input');



CREATE TEMPORARY TABLE strings
(
    id SERIAL,
	line TEXT
);

INSERT INTO strings(line)
TABLE aoc2015_day5;


-- Part 1

SELECT COUNT(*) 
FROM strings
WHERE REGEXP_COUNT(line, 'a|e|i|o|u') >= 3
AND  REGEXP_COUNT(line, 'ab|cd|pq|xy') = 0
AND REGEXP_LIKE(line, '(\w)\1+');


-- Part 2


WITH first_rule AS 
(

	SELECT  id,  two_char, 
	COUNT(*) AS cnt, MIN(pos) AS lower_bound, MAX(pos) AS upper_bound
	FROM strings 
	CROSS JOIN  GENERATE_SERIES(1, LENGTH(line) - 1) AS pos 
	CROSS JOIN SUBSTR(line, pos, 2)  AS two_char
	GROUP BY id,  two_char
	

),


second_rule AS 
(
	SELECT  id, three_char,
	CASE WHEN SUBSTR(three_char, 1, 1) = SUBSTR(three_char, 3,1) THEN TRUE ELSE FALSE END AS check_rule
	FROM strings 
	CROSS JOIN  GENERATE_SERIES(1, LENGTH(line) - 2) AS pos 
	CROSS JOIN SUBSTR(line, pos, 3)  AS three_char
	
),



combined AS
(

	SELECT id FROM first_rule WHERE cnt >= 2 AND upper_bound - lower_bound > 1
	INTERSECT
	SELECT id FROM second_rule WHERE check_rule

)


SELECT COUNT(*) FROM combined;




