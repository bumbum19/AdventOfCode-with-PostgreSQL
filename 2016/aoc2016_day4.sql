CREATE FOREIGN TABLE aoc2016_day4 (x TEXT)
SERVER aoc2016 options(filename 'D:\aoc2016.day4.input');




CREATE  TEMPORARY TABLE rooms
(
	id SERIAL PRIMARY KEY ,
	encrypted_name TEXT,
	sector_id INT,
	check_sum TEXT
	
);




INSERT INTO rooms(encrypted_name, sector_id, check_sum)
SELECT 
LEFT(SPLIT_PART(x,'[',1),-4),
REGEXP_REPLACE(x, '\D', '', 'g')::INT,
LEFT(SPLIT_PART(x,'[',2),-1)
FROM aoc2016_day4;


-- Part 1

WITH cte AS 
(

	SELECT id, letter, check_sum, sector_id, COUNT(*)  AS cnt
	FROM rooms 
	CROSS JOIN STRING_TO_TABLE(encrypted_name, '-') AS word
	CROSS JOIN STRING_TO_TABLE(word, NULL) AS letter
	GROUP BY id, letter
),

cte2 AS 

(

	SELECT  id, check_sum, sector_id, 
	SUBSTR(STRING_AGG(letter, '' ORDER BY cnt DESC, letter),1,5) AS check_word  
	FROM cte 
	GROUP BY id, check_sum, sector_id
)


SELECT SUM(sector_id) FROM cte2 WHERE check_word = check_sum;


-- Part 2


WITH cte AS 
(

	SELECT id, sector_id,  word_pos, letter_pos, CHR(MOD(ASCII(letter) - 97 + MOD(sector_id, 26), 26) + 97) AS letter
	FROM rooms 
	CROSS JOIN STRING_TO_TABLE(encrypted_name, '-')  WITH ORDINALITY AS t(word, word_pos)
	CROSS JOIN STRING_TO_TABLE(word, NULL) WITH ORDINALITY AS t2(letter, letter_pos)
	
),

cte2 AS 

(

	SELECT  id, sector_id, word_pos,
	STRING_AGG(letter, '' ORDER BY letter_pos)  AS word 
	FROM cte 
	GROUP BY id, sector_id, word_pos
)


SELECT sector_id  FROM cte2
GROUP BY id, sector_id HAVING STRING_AGG(word, ' ' ORDER BY word_pos) ILIKE  '%northpole%' ; 



