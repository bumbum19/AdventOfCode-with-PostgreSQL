--- Day 4: The Ideal Stocking Stuffer ---

/*

Santa needs help mining some AdventCoins (very similar to bitcoins) to use as gifts for all the economically forward-thinking little girls and boys.

To do this, he needs to find MD5 hashes which, in hexadecimal, start with at least five zeroes. The input to the MD5 hash is some secret key 
(your puzzle input, given below) followed by a number in decimal. To mine AdventCoins, you must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...) that produces such a hash.

For example:

   - If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043 starts with five zeroes (000001dbbfa...), 
     and it is the lowest such number to do so.
   - If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash starting with five zeroes is 1048970; that is, 
     the MD5 hash of pqrstuv1048970 looks like 000006136ef....

*/


-- Read data

CREATE FOREIGN TABLE aoc2015_day4 (x TEXT)
SERVER aoc2015 options(filename 'D:\aoc2015.day4.input');


-- Create base table

CREATE TEMPORARY TABLE coin
(

	secret_key TEXT
);


-- Insert data

INSERT INTO coin 
TABLE aoc2015_day4;



-- First Star

SELECT id 
FROM coin 
CROSS JOIN  GENERATE_SERIES(1, 1000000) AS id
CROSS JOIN LATERAL (VALUES(SUBSTR(MD5(secret_key|| id::TEXT), 1, 5))) AS dt(first_five)
WHERE SUBSTR(first_five, 1, 5) = '00000'
ORDER BY id
LIMIT 1;




--- Part Two ---



/*

Now find one that starts with six zeroes.

*/


-- Second Star

SELECT id 
FROM coin 
CROSS JOIN  GENERATE_SERIES(1, 10000000) AS id
CROSS JOIN LATERAL (VALUES(SUBSTR(MD5(secret_key|| id::TEXT), 1, 6))) AS dt(first_six)
WHERE SUBSTR(first_six, 1, 6) = '000000'
ORDER BY id
LIMIT 1;




