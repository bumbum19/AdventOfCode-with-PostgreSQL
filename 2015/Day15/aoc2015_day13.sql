--- Day 13: Knights of the Dinner Table ---

/*


In years past, the holiday feast with your family hasn't gone so well. Not everyone gets along! This year, you resolve, will be different.
You're going to find the optimal seating arrangement and avoid all those awkward conversations.

You start by writing up a list of everyone invited and the amount their happiness would increase or decrease if they were to find themselves sitting next to each other person. 
You have a circular table that will be just big enough to fit everyone comfortably, and so each person will have exactly two neighbors.

For example, suppose you have only four attendees planned, and you calculate their potential happiness as follows:

Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.

Then, if you seat Alice next to David, Alice would lose 2 happiness units (because David talks so much), but David would gain 46 happiness units 
(because Alice is such a good listener), for a total change of 44.

If you continue around the table, you could then seat Bob next to Alice (Bob gains 83, Alice gains 54). Finally, seat Carol, who sits next to Bob 
(Carol gains 60, Bob loses 7) and David (Carol gains 55, David gains 41). The arrangement looks like this:

     +41 +46
+55   David    -2
Carol       Alice
+60    Bob    +54
     -7  +83

After trying every other seating arrangement in this hypothetical scenario, you find that this one is the most optimal, with a total change in happiness of 330.

What is the total change in happiness for the optimal seating arrangement of the actual guest list?

*/


-- Read data

CREATE FOREIGN TABLE aoc2015_day13(x text)
SERVER aoc2018 options(filename 'D:\aoc2015.day13.input');



-- Create base table 

CREATE TEMPORARY TABLE seat_arr
(
	person1 TEXT,
	person2 TEXT,
	preference INT

);


-- Insert data


INSERT INTO seat_arr
SELECT 
SPLIT_PART(x, ' ', 1), 
LEFT(SPLIT_PART(x, ' ', -1), -1),
CASE WHEN SPLIT_PART(x, ' ', 3) = 'gain' THEN SPLIT_PART(x, ' ', 4) ::INT
	ELSE -1 * SPLIT_PART(x, ' ', 4) ::INT END
FROM aoc2015_day13;




-- First Star


WITH RECURSIVE search_map(person1, person2, total_preference, depth) AS 
(
	SELECT *, 1
	FROM seat_arr 
	UNION ALL
	SELECT sa.person1, sa.person2, total_preference + preference, sm.depth + 1
	FROM seat_arr sa
	JOIN search_map sm
		ON sa.person1 = sm.person2
) CYCLE person1 SET is_cycle USING path
,

paths AS 
(

	SELECT path::TEXT[] AS path ,  total_preference
	FROM search_map 
	WHERE  NOT is_cycle 
	AND person2 =   LEFT(SUBSTR((path::TEXT[])[1], 2), -1)
	AND depth = (SELECT COUNT(DISTINCT person1)   FROM  seat_arr)
)



SELECT  p1.total_preference + p2.total_preference AS happiness
FROM paths p1
JOIN paths p2
	ON p1.path = ARRAY_REVERSE(p2.path)
ORDER BY happiness DESC
LIMIT 1;




--- Part Two ---

/*

In all the commotion, you realize that you forgot to seat yourself. At this point, you're pretty apathetic toward the whole thing, 
and your happiness wouldn't really go up or down regardless of who you sit next to. You assume everyone else would be just as ambivalent about sitting next to you, too.

So, add yourself to the list, and give all happiness relationships that involve you a score of 0.

What is the total change in happiness for the optimal seating arrangement that actually includes yourself?




*/


-- Second Star


WITH RECURSIVE search_map(person1, person2, total_preference, depth) AS 
(
	SELECT *, 1
	FROM seat_arr 
	UNION ALL
	SELECT sa.person1, sa.person2, total_preference + preference, sm.depth + 1
	FROM seat_arr sa
	JOIN search_map sm
		ON sa.person1 = sm.person2
) CYCLE person1 SET is_cycle USING path
,

paths AS 
(

	SELECT path::TEXT[] AS path ,  total_preference
	FROM search_map 
	WHERE  NOT is_cycle 
	AND person2 =   LEFT(SUBSTR((path::TEXT[])[1], 2), -1)
	AND depth = (SELECT COUNT(DISTINCT person1)   FROM  seat_arr)
),

arrangements AS
(
	SELECT  p1.total_preference + p2.total_preference AS happiness,  p1.path
	FROM paths p1
	JOIN paths p2
		ON p1.path = ARRAY_REVERSE(p2.path)
),

pairs AS 
(
	SELECT '(' || s1.person1 || ')' AS person1, '(' || s1.person2 || ')'  AS person2, 
	s1.preference + s2.preference AS mutual_affection
	FROM seat_arr s1
	JOIN seat_arr s2
		ON s1.person1 = s2.person2
		AND s2.person1 = s1.person2

)


SELECT happiness - mutual_affection AS new_happiness
FROM arrangements
JOIN pairs
	ON array_position(path, person2 ) - array_position(path,  person1) = 1
ORDER BY new_happiness DESC
LIMIT 1; 

