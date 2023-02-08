

CREATE FOREIGN TABLE aoc2017_day4 (x text)
SERVER aoc2017 options(filename 'D:\aoc2017.day4.input');




CREATE TEMPORARY TABLE passphrases 
(


	id SERIAL,
	passphrase TEXT

);


INSERT INTO passphrases(passphrase)
SELECT * FROM aoc2017_day4;


-- Part 1


WITH cte AS 
(

	SELECT id, STRING_TO_TABLE(passphrase, ' ') AS word 
	FROM passphrases

),

duplicates AS
(
	TABLE cte
	EXCEPT ALL 
	SELECT DISTINCT id, word FROM cte
	ORDER BY id
)



SELECT COUNT(id) FROM passphrases WHERE id NOT IN (SELECT id FROM duplicates);


-- Part 2


WITH cte AS 
(

	SELECT id, word_id, letter
	FROM passphrases 
	CROSS JOIN STRING_TO_TABLE(passphrase, ' ') WITH ORDINALITY AS t(word, word_id)
	CROSS JOIN STRING_TO_TABLE(word, NULL) AS letter
	
	

),

duplicates AS
(
	SELECT  id, STRING_AGG(letter, '' ORDER BY letter) AS word  FROM  cte GROUP BY id, word_id
	EXCEPT ALL 
	SELECT DISTINCT id, STRING_AGG(letter, '' ORDER BY letter) AS word  FROM  cte GROUP BY id, word_id
	ORDER BY id
)



SELECT COUNT(id) FROM passphrases WHERE id NOT IN (SELECT id FROM duplicates);











WITH cte AS 
(

	SELECT id, word_id, letter
	FROM passphrases 
	CROSS JOIN STRING_TO_TABLE(passphrase, ' ') WITH ORDINALITY AS t(word, word_id)
	CROSS JOIN STRING_TO_TABLE(word, NULL) AS letter
	
	

)

SELECT  DISTINCT id, STRING_AGG(letter, '' ORDER BY letter) AS word  FROM  cte GROUP BY id, word_id;