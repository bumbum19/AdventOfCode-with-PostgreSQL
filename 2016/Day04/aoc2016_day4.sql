--- Day 4: Security Through Obscurity ---

/*


Finally, you come across an information kiosk with a list of rooms. Of course, the list is encrypted and full of decoy data,
but the instructions to decode the list are barely hidden nearby. Better remove the decoy data first.

Each room consists of an encrypted name (lowercase letters separated by dashes) followed by a dash, a sector ID, and a checksum in square brackets.

A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization. For example:

   - aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
   - a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
   - not-a-real-room-404[oarel] is a real room.
   - totally-real-room-200[decoy] is not.

Of the real rooms from the list above, the sum of their sector IDs is 1514.

What is the sum of the sector IDs of the real rooms?
*/





-- Read data


CREATE FOREIGN TABLE aoc2016_day4 (x TEXT)
SERVER aoc2016 options(filename 'D:\aoc2016.day4.input');


-- Create base table

CREATE  TEMPORARY TABLE rooms
(
	id SERIAL PRIMARY KEY ,
	encrypted_name TEXT,
	sector_id INT,
	check_sum TEXT
	
);


-- Insert data

INSERT INTO rooms(encrypted_name, sector_id, check_sum)
SELECT 
LEFT(SPLIT_PART(x,'[',1),-4),
REGEXP_REPLACE(x, '\D', '', 'g')::INT,
LEFT(SPLIT_PART(x,'[',2),-1)
FROM aoc2016_day4;


-- First Star

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


--- Part Two ---

/*


With all the decoy data out of the way, it's time to decrypt this list and get moving.

The room names are encrypted by a state-of-the-art shift cipher, which is nearly unbreakable without the right software. 
However, the information kiosk designers at Easter Bunny HQ were not expecting to deal with a master cryptographer like yourself.

To decrypt a room name, rotate each letter forward through the alphabet a number of times equal to the room's sector ID. A becomes B, B becomes C, Z becomes A, and so on. 
Dashes become spaces.

For example, the real name for qzmt-zixmtkozy-ivhz-343 is very encrypted name.

What is the sector ID of the room where North Pole objects are stored?
*/




-- Second Star


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
GROUP BY id, sector_id 
HAVING STRING_AGG(word, ' ' ORDER BY word_pos) ILIKE  '%northpole%'; 



