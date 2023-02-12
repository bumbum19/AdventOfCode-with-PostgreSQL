CREATE FOREIGN TABLE aoc2016_day7 (x TEXT)
SERVER aoc2016 options(filename 'D:\aoc2016.day7.input');




CREATE TEMPORARY TABLE addresses
(

	id SERIAL,
	address TEXT

);


INSERT INTO addresses( address)
TABLE aoc2016_day7;

---------------------



CREATE TEMPORARY TABLE addresses
(

	id SERIAL,
	address TEXT

);

INSERT INTO addresses( address)
VALUES
('aba[bab]xyz'),
('xyx[xyx]xyx'),
('aaa[kek]eke'),
('zazbz[bzb]cdb');



-- Part 1

WITH look_outside AS 
(


	SELECT  id, four_char,
	CASE WHEN four_char = REVERSE(four_char) AND SUBSTR(four_char,1,1) != SUBSTR(four_char,2,1) THEN TRUE ELSE FALSE END AS abba
	FROM addresses 
	CROSS JOIN  GENERATE_SERIES(1, REGEXP_COUNT(address, '\[') + 1) AS x 
	CROSS JOIN SPLIT_PART(SPLIT_PART(address || ']' , ']', x), '[', 1)  AS word
	CROSS JOIN GENERATE_SERIES(1,  LENGTH(word) -4 + 1) AS y
	CROSS JOIN SUBSTR(word, y, 4 ) AS four_char
	

),


look_inside AS 
(
	SELECT  id, four_char,
	CASE WHEN four_char = REVERSE(four_char) AND SUBSTR(four_char,1,1) != SUBSTR(four_char,2,1) THEN TRUE ELSE FALSE END AS abba
	FROM addresses 
	CROSS JOIN  GENERATE_SERIES(1, REGEXP_COUNT(address, '\[')) AS x 
	CROSS JOIN SPLIT_PART(SPLIT_PART(address, '[', x+1),']',1)  AS word
	CROSS JOIN GENERATE_SERIES(1,  LENGTH(word) -4 + 1) AS y
	CROSS JOIN SUBSTR(word, y, 4 ) AS four_char
	
),

combined AS
(

	SELECT id FROM look_outside GROUP BY id HAVING BOOL_OR(abba)
	EXCEPT ALL
	SELECT id FROM look_inside GROUP BY id HAVING BOOL_OR(abba)

)


SELECT COUNT(*) FROM combined;




-- Part 2

WITH look_outside AS 
(


	SELECT  id, three_char,
	CASE WHEN three_char = REVERSE(three_char) AND SUBSTR(three_char, 1, 1) != SUBSTR(three_char, 2, 1) THEN TRUE ELSE FALSE END AS aba
	FROM addresses 
	CROSS JOIN  GENERATE_SERIES(1, REGEXP_COUNT(address, '\[') + 1) AS x 
	CROSS JOIN SPLIT_PART(SPLIT_PART(address || ']' , ']', x), '[', 1)  AS word
	CROSS JOIN GENERATE_SERIES(1,  LENGTH(word) -3 + 1) AS y
	CROSS JOIN SUBSTR(word, y, 3 ) AS three_char
	

),


look_inside AS 
(
	SELECT  id, three_char,
	CASE WHEN three_char = REVERSE(three_char) AND SUBSTR(three_char, 1, 1) != SUBSTR(three_char, 2, 1) THEN TRUE ELSE FALSE END AS aba
	FROM addresses 
	CROSS JOIN  GENERATE_SERIES(1, REGEXP_COUNT(address, '\[')) AS x 
	CROSS JOIN SPLIT_PART(SPLIT_PART(address, '[', x+1),']', 1)  AS word
	CROSS JOIN GENERATE_SERIES(1,  LENGTH(word) -3 + 1) AS y
	CROSS JOIN SUBSTR(word, y, 3 ) AS three_char
	
),

combined AS
(

	SELECT id, three_char FROM look_outside WHERE aba
	INTERSECT ALL
	SELECT id, SUBSTR(three_char,2,1) || SUBSTR(three_char,1,1) ||  SUBSTR(three_char,2,1) FROM look_inside WHERE aba

)


SELECT COUNT(DISTINCT id) FROM combined;