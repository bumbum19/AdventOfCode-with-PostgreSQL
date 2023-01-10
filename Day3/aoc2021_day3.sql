--- Day 3: Binary Diagnostic ---

-- Setup

CREATE FOREIGN TABLE aoc2021_day3 (num text)
SERVER aoc2021 options(filename 'D:\aoc2021.day3.input');


 CREATE TEMPORARY TABLE submarine (
 id  SERIAL,
 num  INT[12]
  
 );


INSERT INTO submarine(num)
SELECT string_to_array(num,NULL)::INT[12] FROM aoc2021_day3;
 



-- Part 1

-- Description


/*

The submarine has been making some odd creaking noises, so you ask it to produce a diagnostic report just in case.

The diagnostic report (your puzzle input) consists of a list of binary numbers which, when decoded properly, can tell you many useful things about the conditions 
of the submarine. The first parameter to check is the power consumption.

You need to use the binary numbers in the diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate). 
The power consumption can then be found by multiplying the gamma rate by the epsilon rate.

Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report. 
For example, given the following diagnostic report:

00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010

Considering only the first bit of each number, there are five 0 bits and seven 1 bits. Since the most common bit is 1, the first bit of the gamma rate is 1.

The most common second bit of the numbers in the diagnostic report is 0, so the second bit of the gamma rate is 0.

The most common value of the third, fourth, and fifth bits are 1, 1, and 0, respectively, and so the final three bits of the gamma rate are 110.

So, the gamma rate is the binary number 10110, or 22 in decimal.

The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used.
So, the epsilon rate is 01001, or 9 in decimal. Multiplying the gamma rate (22) by the epsilon rate (9) produces the power consumption, 198.

Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together.
What is the power consumption of the submarine? (Be sure to represent your answer in decimal, not binary.)


*/


-- Solution


WITH cte AS 
(SELECT UNNEST(num) AS bit, UNNEST(ARRAY[1,2,3,4,5,6,7,8,9,10,11,12]) AS pos FROM submarine ),
 
cte2 AS 
(SELECT pos, bit, COUNT(*) AS cnt
 FROM cte
 GROUP BY pos, bit),
 
cte3 AS 
(SELECT DISTINCT ON (pos) pos, bit FROM cte2 ORDER BY pos, cnt DESC)
 
 
 SELECT ARRAY_TO_STRING(ARRAY_AGG(bit ORDER BY pos),'')::BIT(12)::INT * 
 (~(ARRAY_TO_STRING(ARRAY_AGG(bit ORDER BY pos),'')::BIT(12)))::INT AS power_consumption
 FROM cte3;
 

-- Part 2 

-- Description


/*

The submarine has been making some odd creaking noises, so you ask it to produce a diagnostic report just in case.

The diagnostic report (your puzzle input) consists of a list of binary numbers which, when decoded properly, can tell you many useful things about the conditions 
of the submarine. The first parameter to check is the power consumption.

You need to use the binary numbers in the diagnostic report to generate two new binary numbers (called the gamma rate and the epsilon rate). 
The power consumption can then be found by multiplying the gamma rate by the epsilon rate.

Each bit in the gamma rate can be determined by finding the most common bit in the corresponding position of all numbers in the diagnostic report. 
For example, given the following diagnostic report:

00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010

Considering only the first bit of each number, there are five 0 bits and seven 1 bits. Since the most common bit is 1, the first bit of the gamma rate is 1.

The most common second bit of the numbers in the diagnostic report is 0, so the second bit of the gamma rate is 0.

The most common value of the third, fourth, and fifth bits are 1, 1, and 0, respectively, and so the final three bits of the gamma rate are 110.

So, the gamma rate is the binary number 10110, or 22 in decimal.

The epsilon rate is calculated in a similar way; rather than use the most common bit, the least common bit from each position is used.
So, the epsilon rate is 01001, or 9 in decimal. Multiplying the gamma rate (22) by the epsilon rate (9) produces the power consumption, 198.

Use the binary numbers in your diagnostic report to calculate the gamma rate and epsilon rate, then multiply them together.
What is the power consumption of the submarine? (Be sure to represent your answer in decimal, not binary.)


*/




CREATE OR REPLACE FUNCTION finder()
RETURNS INT LANGUAGE plpgsql AS $$
DECLARE 
a INT;
b INT;
BEGIN

CREATE TEMPORARY TABLE diagnostic (
  num    INT[12],
  oxy_gen BOOL  DEFAULT TRUE,
  c02_srub  BOOL DEFAULT  TRUE
  )
 ON COMMIT DROP;

INSERT INTO diagnostic
SELECT num FROM submarine;


FOR i IN  1..12 LOOP
 

WITH cte  AS
(SELECT num[i] AS bit, COUNT(*) AS cnt FROM diagnostic 
WHERE oxy_gen GROUP BY num[i] )


UPDATE diagnostic SET oxy_gen = FALSE 
WHERE num[i] != (SELECT  bit  FROM cte 
ORDER BY cnt DESC, bit DESC LIMIT 1);


WITH cte2 AS
(SELECT num[i]  AS bit, COUNT(*) AS cnt FROM diagnostic 
WHERE c02_srub GROUP BY num[i] )


UPDATE diagnostic SET c02_srub = FALSE 
WHERE num[i] != (SELECT  bit  FROM cte2 
ORDER BY cnt, bit LIMIT 1);





END LOOP;
SELECT INTO a ARRAY_TO_STRING(num,'')::BIT(12)::INT FROM diagnostic WHERE oxy_gen;
SELECT INTO b ARRAY_TO_STRING(num,'')::BIT(12)::INT FROM diagnostic WHERE c02_srub;

RETURN a * b;
END
$$;




SELECT finder();


DROP FUNCTION finder;

