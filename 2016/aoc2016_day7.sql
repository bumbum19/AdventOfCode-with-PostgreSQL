--- Day 7: Internet Protocol Version 7 ---

/*


While snooping around the local network of EBHQ, you compile a list of IP addresses (they're IPv7, of course; IPv6 is much too limited). 
You'd like to figure out which IPs support TLS (transport-layer snooping).

An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA. An ABBA is any four-character sequence which consists of a pair of two 
different characters followed by the reverse of that pair, such as xyyx or abba. However, the IP also must not have an ABBA within any hypernet sequences, 
which are contained by square brackets.

For example:

   - abba[mnop]qrst supports TLS (abba outside square brackets).
   - abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
   - aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
   - ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).

How many IPs in your puzzle input support TLS?
*/


-- Read data


CREATE FOREIGN TABLE aoc2016_day7 (x TEXT)
SERVER aoc2016 options(filename 'D:\aoc2016.day7.input');


-- Create base table

CREATE TEMPORARY TABLE addresses
(

	id SERIAL,
	address TEXT

);


-- Insert data

INSERT INTO addresses( address)
TABLE aoc2016_day7;




-- First Star

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




--- Part Two ---

/*

You would also like to know which IPs support SSL (super-secret listening).

An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in the supernet sequences (outside any square bracketed sections), 
and a corresponding Byte Allocation Block, or BAB, anywhere in the hypernet sequences. An ABA is any three-character sequence
which consists of the same character twice with a different character between them, such as xyx or aba.
A corresponding BAB is the same characters but in reversed positions: yxy and bab, respectively.

For example:

   - aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square brackets).
   - xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
   - aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence is not related, because the interior character must be different).
   - zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even though zaz and zbz overlap).

How many IPs in your puzzle input support SSL?
*/

-- Second Star

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

