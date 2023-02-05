--- Day 4: Secure Container ---


/*

--- Day 4: Secure Container ---

You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.

However, they do remember a few key facts about the password:

   - It is a six-digit number.
   - The value is within the range given in your puzzle input.
   - Two adjacent digits are the same (like 22 in 122345).
     Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).

Other than the range rule, the following are true:

   - 111111 meets these criteria (double 11, never decreases).
   - 223450 does not meet these criteria (decreasing pair of digits 50).
   - 123789 does not meet these criteria (no double).

How many different passwords within the range given in your puzzle input meet these criteria?

*/


-- Read data

CREATE FOREIGN TABLE aoc2019_day4 (x text)
SERVER aoc2019 options(filename 'D:\aoc2019.day4.input');

-- Create base table

CREATE TEMPORARY TABLE password_range
 (
    lower_bound INT,
    upper_bound  INT
 );

  
-- Insert data

INSERT INTO password_range
SELECT SPLIT_PART(a,'-',1)::INT, SPLIT_PART(a,'-',2)::INT  
FROM aoc2019_day4;



-- First Star

 WITH cte AS

(

     SELECT x0 * POW(10,0) + x1 * POW(10,1) +  x2 * POW(10,2) + x3 * POW(10,3) + x4 * POW(10,4) + x5 * POW(10,5) AS num
     FROM GENERATE_SERIES(0,9) AS x0
     CROSS JOIN GENERATE_SERIES(0,9) AS x1
     CROSS JOIN GENERATE_SERIES(0,9) AS x2
     CROSS JOIN GENERATE_SERIES(0,9) AS x3
     CROSS JOIN GENERATE_SERIES(0,9) AS x4
     CROSS JOIN GENERATE_SERIES(0,9) AS x5
     WHERE x0 >= x1 AND x1 >= x2 AND x2 >= x3 AND x3 >= x4 AND x4 >= x5
     AND ( x0 = x1 OR x1 = x2 OR x2 = x3 OR x3 = x4 OR x4 = x5 )
 )



SELECT COUNT(*) FROM cte JOIN password_range ON num >= lower_bound AND num <= upper_bound;


--- Part Two ---
  
/*
  
An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.

Given this additional criterion, but still ignoring the range rule, the following are now true:

   - 112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
   - 123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
   - 111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).

How many different passwords within the range given in your puzzle input meet all of the criteria?
  
  
 */

 
-- Second Star
  
  
WITH cte AS
(
     SELECT x0 * POW(10,0) + x1 * POW(10,1) +  x2 * POW(10,2) + x3 * POW(10,3) + x4 * POW(10,4) + x5 * POW(10,5) AS num
     FROM GENERATE_SERIES(0,9) AS x0
     CROSS JOIN GENERATE_SERIES(0,9) AS x1
     CROSS JOIN GENERATE_SERIES(0,9) AS x2
     CROSS JOIN GENERATE_SERIES(0,9) AS x3
     CROSS JOIN GENERATE_SERIES(0,9) AS x4
     CROSS JOIN GENERATE_SERIES(0,9) AS x5
     WHERE x0 >= x1 AND x1 >= x2 AND x2 >= x3 AND x3 >= x4 AND x4 >= x5
     AND ( (x0 = x1 AND  x1 != x2              ) OR
           (x1 = x2 AND  x0 != x1 AND x2 != x3 ) OR
           (x2 = x3 AND  x1 != x2 AND x3 != x4 ) OR
           (x3 = x4 AND  x2 != x3 AND x4 != x5 ) OR
           (x4 = x5 AND  x3 != x4              )

         )
 )

SELECT COUNT(*) FROM cte JOIN password_range ON num >= lower_bound AND num <= upper_bound;
