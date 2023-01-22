--- Day 14: Extended Polymerization ---

/*

The incredible pressures at this depth are starting to put a strain on your submarine. The submarine has polymerization equipment that would produce 
suitable materials to reinforce the submarine, and the nearby volcanically-active caves should even have the necessary input elements in sufficient quantities.

The submarine manual contains instructions for finding the optimal polymer formula; specifically, it offers a polymer template and a list of pair insertion rules
(your puzzle input). You just need to work out what polymer would result after repeating the pair insertion process a few times.

For example:

NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C

The first line is the polymer template - this is the starting point of the process.

The following section defines the pair insertion rules. A rule like AB -> C means that when elements A and B are immediately adjacent, 
element C should be inserted between them. These insertions all happen simultaneously.

So, starting with the polymer template NNCB, the first step simultaneously considers all three pairs:

   - The first pair (NN) matches the rule NN -> C, so element C is inserted between the first N and the second N.
   - The second pair (NC) matches the rule NC -> B, so element B is inserted between the N and the C.
   - The third pair (CB) matches the rule CB -> H, so element H is inserted between the C and the B.

Note that these pairs overlap: the second element of one pair is the first element of the next pair. Also, because all pairs are considered simultaneously, 
inserted elements are not considered to be part of a pair until the next step.

After the first step of this process, the polymer becomes NCNBCHB.

Here are the results of a few steps using the above rules:

Template:     NNCB
After step 1: NCNBCHB
After step 2: NBCCNBBBCBHCB
After step 3: NBBBCNCCNBBNBNBBCHBHHBCHB
After step 4: NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB

This polymer grows quickly. After step 5, it has length 97; After step 10, it has length 3073. After step 10, B occurs 1749 times, C occurs 298 times, H occurs 161 times, 
and N occurs 865 times; taking the quantity of the most common element (B, 1749) and subtracting the quantity of the least common element (H, 161) produces 1749 - 161 = 1588.

Apply 10 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the
most common element and subtract the quantity of the least common element?

*/


-- Setup

CREATE FOREIGN TABLE aoc2021_day14 (x text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day14.input');
 
 
 CREATE TEMPORARY TABLE  polymer (
  day  INT,
  x  text


);

INSERT INTO polymer 
SELECT 0, x FROM aoc2021_day14 WHERE 
x != '' AND x NOT LIKE '%->%';


CREATE TEMPORARY TABLE  rules (
  id  SERIAL,
  adj  CHAR(2),
  bet  CHAR(1)
  );
  
  
INSERT INTO rules(adj,bet)
SELECT 
SPLIT_PART(x,' -> ',1),
SPLIT_PART(x,' -> ',2)
FROM aoc2021_day14
WHERE 
x != '' AND x  LIKE '%->%';

-- Solution
 

WITH RECURSIVE s AS 
(

SELECT r1.adj AS v1, r2.adj AS v2 FROM rules r1 JOIN rules r2 ON 
SUBSTR(r1.adj,1,1) || r1.bet = r2.adj OR 
 r1.bet || SUBSTR(r1.adj,2) = r2.adj
),


t(v1,v2,step) AS 
(
SELECT SUBSTR(x,pos,2) AS v1, SUBSTR(x,pos,2) AS v2, 0
FROM polymer CROSS JOIN  GENERATE_SERIES(1,LENGTH(x)-1) AS pos
UNION ALL
SELECT t.v2, s.v2, step + 1
FROM t JOIN s ON
t.v2 = s.v1 WHERE step < 10
),

cte AS 
(

SELECT SUBSTR(v2,2),COUNT(*) + CASE WHEN SUBSTR((SELECT x FROM polymer),1,1) = SUBSTR(v2,2) THEN 1 ELSE 0 END  AS cnt 
FROM t WHERE step = 10 GROUP BY SUBSTR(v2,2) 
)

SELECT MAX(cnt) - MIN(cnt) AS answer FROM cte;


--- Part Two ---

/*
The resulting polymer isn't nearly strong enough to reinforce the submarine. You'll need to run more steps of the pair insertion process; a total of 40 steps should do it.

In the above example, the most common element is B (occurring 2192039569602 times) and the least common element is H (occurring 3849876073 times); 
subtracting these produces 2188189693529.

Apply 40 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and 
subtract the quantity of the least common element?

*/



-- Solution

WITH RECURSIVE s AS 
(

SELECT r1.adj AS v1, r2.adj AS v2 FROM rules r1 JOIN rules r2 ON 
SUBSTR(r1.adj,1,1) || r1.bet = r2.adj OR 
 r1.bet || SUBSTR(r1.adj,2) = r2.adj
),

t(v1,v2,step) AS 
(
SELECT DISTINCT v1 AS v1, v1 AS v2, 0
FROM s

UNION ALL
SELECT t.v1, s.v2, step + 1
FROM t JOIN s ON
t.v2 = s.v1 WHERE step < 10
),

cte AS  (
SELECT v1, v2, COUNT(*) AS cnt 
FROM t WHERE step = 10 GROUP BY v1, v2 
),

cte2 AS 
(

SELECT  a.v1, b.v2, SUM(a.cnt * b.cnt )::BIGINT    AS cnt
FROM cte a 
JOIN cte b 
	ON a.v2 = b.v1

GROUP BY a.v1, b.v2

),

cte3 AS 
(

SELECT  SUBSTR(b.v2,2), SUM(a.cnt * b.cnt )::BIGINT    +
CASE WHEN SUBSTR((SELECT x FROM polymer),1,1) = SUBSTR(b.v2,2) THEN 1 ELSE 0 END  AS cnt
FROM cte2 a 
JOIN (SELECT SUBSTR(x,pos,2) AS x FROM polymer CROSS JOIN  GENERATE_SERIES(1,LENGTH(x)-1) AS pos) AS u
	ON u.x = a.v1
JOIN cte2 b 
	ON a.v2 = b.v1

GROUP BY SUBSTR(b.v2,2)

)

SELECT MAX(cnt) - MIN(cnt) AS answer FROM cte3;
