--- Day 4: High-Entropy Passphrases ---

/*

A new system policy has been put in place that requires all accounts to use a passphrase instead of simply a password.
A passphrase consists of a series of words (lowercase letters) separated by spaces.

To ensure security, a valid passphrase must contain no duplicate words.

For example:

   - aa bb cc dd ee is valid.
   - aa bb cc dd aa is not valid - the word aa appears more than once.
   - aa bb cc dd aaa is valid - aa and aaa count as different words.

The system's full passphrase list is available as your puzzle input. How many passphrases are valid?
*/

-- Read data

CREATE FOREIGN TABLE aoc2017_day4 (x text)
SERVER aoc2017 options(filename 'D:\aoc2017.day4.input');

-- Create base table

CREATE TEMPORARY TABLE passphrases 
(

	id SERIAL,
	passphrase TEXT

);

-- Insert data

INSERT INTO passphrases(passphrase)
SELECT * FROM aoc2017_day4;


-- First Star


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


--- Part Two ---

/*

For added security, yet another system policy has been put in place. Now, a valid passphrase must contain no two words that are anagrams of each other - 
that is, a passphrase is invalid if any word's letters can be rearranged to form any other word in the passphrase.

For example:

   - abcde fghij is a valid passphrase.
   - abcde xyz ecdab is not valid - the letters from the third word can be rearranged to form the first word.
   - a ab abc abd abf abj is a valid passphrase, because all letters need to be used when forming another word.
   - iiii oiii ooii oooi oooo is valid.
   - oiii ioii iioi iiio is not valid - any of these words can be rearranged to form any other word.

Under this new system policy, how many passphrases are valid?
*/


-- Second Star

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
