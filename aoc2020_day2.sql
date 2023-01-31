CREATE FOREIGN TABLE aoc2020_day2 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day2.input');



CREATE TEMPORARY TABLE passwords
(id SERIAL,
 lower_bound INT,
 upper_bound INT,
 letter CHAR,
 password TEXT
);


INSERT INTO passwords(lower_bound, upper_bound, letter, password)
SELECT 
SPLIT_PART(SPLIT_PART(x,' ',1),'-',1)::INT,
SPLIT_PART(SPLIT_PART(x,' ',1),'-',2)::INT,
SPLIT_PART(SPLIT_PART(x,' ',2),':',1),
SPLIT_PART(x,' ',3)
FROM aoc2020_day2;


SELECT ARRAY_POSITIONS(STRING_TO_ARRAY(password,NULL), letter) FROM passwords;


-- Part 1


SELECT COUNT(*) FROM passwords 
WHERE CARDINALITY(ARRAY_POSITIONS(STRING_TO_ARRAY(password,NULL), letter)) 
BETWEEN lower_bound AND upper_bound;


-- Part 2


SELECT COUNT(*) FROM passwords 
WHERE ARRAY[lower_bound] <@ ARRAY_POSITIONS(STRING_TO_ARRAY(password,NULL), letter) AND 
NOT ARRAY[upper_bound] <@ ARRAY_POSITIONS(STRING_TO_ARRAY(password,NULL), letter)
OR NOT ARRAY[lower_bound] <@ ARRAY_POSITIONS(STRING_TO_ARRAY(password,NULL), letter) AND 
 ARRAY[upper_bound] <@ ARRAY_POSITIONS(STRING_TO_ARRAY(password,NULL), letter)  
;