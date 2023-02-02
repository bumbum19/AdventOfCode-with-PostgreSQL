--- Day 7: Handy Haversacks ---

/*

You land at the regional airport in time for your next flight. In fact, it looks like you'll even have time to grab some food: 
all flights are currently delayed due to issues in luggage processing.

Due to recent aviation regulations, many rules (your puzzle input) are being enforced about bags and their contents; 
bags must be color-coded and must contain specific quantities of other color-coded bags. Apparently, nobody responsible for these regulations considered how long they would take to enforce!

For example, consider the following rules:

light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.

These rules specify the required contents for 9 bag types. In this example, every faded blue bag is empty, 
every vibrant plum bag contains 11 bags (5 faded blue and 6 dotted black), and so on.

You have a shiny gold bag. If you wanted to carry it in at least one other bag, how many different bag colors would be valid for the outermost bag? 
(In other words: how many colors can, eventually, contain at least one shiny gold bag?)

In the above rules, the following options would be available to you:

   - A bright white bag, which can hold your shiny gold bag directly.
   - A muted yellow bag, which can hold your shiny gold bag directly, plus some other bags.
   - A dark orange bag, which can hold bright white and muted yellow bags, either of which could then hold your shiny gold bag.
   - A light red bag, which can hold bright white and muted yellow bags, either of which could then hold your shiny gold bag.

So, in this example, the number of bag colors that can eventually contain at least one shiny gold bag is 4.

How many bag colors can eventually contain at least one shiny gold bag? (The list of rules is quite long; make sure you get all of it.)

*/

-- Read data

CREATE FOREIGN TABLE aoc2020_day7 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day7.input',NULL '');


-- Create basic tables

CREATE TEMPORARY TABLE bags
(
	id SERIAL,
	color TEXT,
	pattern TEXT
);


CREATE TEMPORARY TABLE bag_containment
(
	id SERIAL,
	bag1 INT ,
	bag2 INT,
	weight INT
	
);

-- Insert data

INSERT INTO bags(color, pattern)
SELECT 
SPLIT_PART(x,' ',2),
SPLIT_PART(x,' ',1)
FROM aoc2020_day7;





INSERT INTO bag_containment(bag1, bag2, weight)
WITH cte AS 
(
	SELECT 
	REPLACE(SPLIT_PART(x,'contain',1),'bags','') AS bag1,
	REPLACE(NULLIF(TRIM(RIGHT(REPLACE(bag2,'bags',''), -3),' .'),'other'),'bag','') AS bag2,
	NULLIF(TRIM(SPLIT_PART(bag2,' ',2)),'no')::INT AS weight
	FROM aoc2020_day7 CROSS JOIN UNNEST(STRING_TO_ARRAY(SPLIT_PART(x,'contain',2),',')) AS bag2 
),
cte2 AS 
(

	SELECT 
	SPLIT_PART(bag1,' ',2) AS color1,  SPLIT_PART(bag1,' ',1) AS pattern1, 
	SPLIT_PART(bag2,' ',2) AS color2,  SPLIT_PART(bag2,' ',1) AS pattern2, 
	weight  FROM cte 
)
SELECT  b1.id, b2.id, weight FROM cte2 JOIN bags b1 ON b1.color = cte2.color1 AND  b1.pattern= cte2.pattern1 
JOIN bags b2 ON b2.color = cte2.color2 AND  b2.pattern = cte2.pattern2 ;





-- First Star


WITH RECURSIVE cte (bag) AS 
(  
	SELECT bag1 FROM bag_containment  JOIN bags b ON bag2 = b.id 
	WHERE color = 'gold' AND pattern = 'shiny'
	UNION   
	SELECT bg.bag1 FROM bag_containment bg JOIN cte ON cte.bag = bg.bag2
	
)

SELECT COUNT(*) FROM cte JOIN bags b ON cte.bag = b.id; 




--- Part Two ---

/*

It's getting pretty expensive to fly these days - not because of ticket prices, but because of the ridiculous number of bags you need to buy!

Consider again your shiny gold bag and the rules from the above example:

   - faded blue bags contain 0 other bags.
   - dotted black bags contain 0 other bags.
   - vibrant plum bags contain 11 other bags: 5 faded blue bags and 6 dotted black bags.
   - dark olive bags contain 7 other bags: 3 faded blue bags and 4 dotted black bags.

So, a single shiny gold bag must contain 1 dark olive bag (and the 7 bags within it) plus 2 vibrant plum bags (and the 11 bags within each of those): 
1 + 1*7 + 2 + 2*11 = 32 bags!

Of course, the actual rules have a small chance of going several levels deeper than this example; be sure to count all of the bags, 
even if the nesting becomes topologically impractical!

Here's another example:

shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.

In this example, a single shiny gold bag must contain 126 other bags.

How many individual bags are required inside your single shiny gold bag?

*/

-- Second Star


WITH RECURSIVE cte (bag, volume) AS 
(  
	SELECT id, 1 FROM bags   
	WHERE color = 'gold' AND pattern = 'shiny'
	UNION  ALL 
	SELECT bg.bag2, volume * weight FROM bag_containment bg JOIN cte ON cte.bag = bg.bag1
	
)

SELECT SUM(volume) - 1 AS n_bags FROM cte JOIN bags b ON cte.bag = b.id ;

