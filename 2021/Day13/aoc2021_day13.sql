--- Day 13: Transparent Origami ---

/*

You reach another volcanically active part of the cave. It would be nice if you could do some kind of thermal imaging so you could tell ahead of 
time which caves are too hot to safely enter.

Fortunately, the submarine seems to be equipped with a thermal camera! When you activate it, you are greeted with:

Congratulations on your purchase! To activate this infrared thermal imaging
camera system, please enter the code found on page 1 of the manual.

Apparently, the Elves have never used this feature. To your surprise, you manage to find the manual; as you go to open it, page 1 falls out. 
It's a large sheet of transparent paper! The transparent paper is marked with random dots and includes instructions on how to fold it up (your puzzle input). For example:

6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5

The first section is a list of dots on the transparent paper. 0,0 represents the top-left coordinate. The first value, x, increases to the right. 
The second value, y, increases downward. So, the coordinate 3,0 is to the right of 0,0, and the coordinate 0,7 is below 0,0. 
The coordinates in this example form the following pattern, where # is a dot on the paper and . is an empty, unmarked position:

...#..#..#.
....#......
...........
#..........
...#....#.#
...........
...........
...........
...........
...........
.#....#.##.
....#......
......#...#
#..........
#.#........

Then, there is a list of fold instructions. Each instruction indicates a line on the transparent paper and wants you to fold the paper up (for horizontal y=... lines) 
or left (for vertical x=... lines). In this example, the first fold instruction is fold along y=7, which designates the line formed by
all of the positions where y is 7 (marked here with -):

...#..#..#.
....#......
...........
#..........
...#....#.#
...........
...........
-----------
...........
...........
.#....#.##.
....#......
......#...#
#..........
#.#........

Because this is a horizontal line, fold the bottom half up. Some of the dots might end up overlapping after the fold is complete, 
but dots will never appear exactly on a fold line. The result of doing this fold looks like this:

#.##..#..#.
#...#......
......#...#
#...#......
.#.#..#.###
...........
...........

Now, only 17 dots are visible.

Notice, for example, the two dots in the bottom left corner before the transparent paper is folded; after the fold is complete, those dots appear 
in the top left corner (at 0,0 and 0,1). Because the paper is transparent, the dot just below them in the result (at 0,3) remains visible, as it can be seen through the transparent paper.

Also notice that some dots can end up overlapping; in this case, the dots merge together and become a single dot.

The second fold instruction is fold along x=5, which indicates this line:

#.##.|#..#.
#...#|.....
.....|#...#
#...#|.....
.#.#.|#.###
.....|.....
.....|.....

Because this is a vertical line, fold left:

#####
#...#
#...#
#...#
#####
.....
.....

The instructions made a square!

The transparent paper is pretty big, so for now, focus on just completing the first fold. After the first fold in the example above, 17 dots are visible - dots that end up overlapping after the fold is completed count as a single dot.

How many dots are visible after completing just the first fold instruction on your transparent paper?
*/

-- Read data

CREATE FOREIGN TABLE aoc2021_day13 (x text)
SERVER aoc2022 options(filename 'D:\aoc2021.day13.input');
 
-- Create base tables

CREATE TEMPORARY TABLE  paper 
(
	id  SERIAL,
	x  INT,
	y INT
);

CREATE TEMPORARY TABLE  folding  
(
	id  SERIAL,
	direction  text,
	pos INT
);



-- Insert data

INSERT INTO paper(x,y)
SELECT 
SPLIT_PART(x,',',1)::INT,
-1 * SPLIT_PART(x,',',2)::INT
FROM aoc2021_day13
WHERE x NOT LIKE '%f%' AND x != '';


INSERT INTO folding (direction, pos)
SELECT 
CASE WHEN x LIKE '%x%' THEN 'vertical' ELSE 'horizontal' END, 
CASE WHEN x LIKE '%x%' THEN SPLIT_PART(x,'=',2)::INT ELSE -1*SPLIT_PART(x,'=',2)::INT END
FROM aoc2021_day13
WHERE x  LIKE '%f%' AND x != '';


-- First Star


WITH t AS
(
	SELECT  DISTINCT
	CASE WHEN direction = 'vertical' THEN 
		CASE WHEN x < pos THEN x ELSE  x - 2*(x - pos) END
		ELSE x END AS x,
	CASE WHEN direction = 'horizontal' THEN 
		CASE WHEN y > pos THEN y ELSE  y - 2*(y - pos) END
		ELSE y END AS y
	FROM paper CROSS JOIN folding 
	WHERE folding.id = 1 
)

SELECT COUNT(*) FROM t;



--- Part Two ---

/*

Finish folding the transparent paper according to the instructions. The manual says the code is always eight capital letters.

What code do you use to activate the infrared thermal imaging camera system?
*/

-- Second Star

WITH RECURSIVE t(x, y, step) AS 
(

	SELECT x,y, 0 FROM paper
	UNION
	SELECT 
	CASE WHEN direction = 'vertical' THEN 
		CASE WHEN x < pos THEN x ELSE  x - 2*(x - pos) END
		ELSE x END,
	CASE WHEN direction = 'horizontal' THEN 
		CASE WHEN y > pos THEN y ELSE  y - 2*(y - pos) END
		ELSE y END,
	step + 1
	FROM t 
	JOIN folding 
		ON step+1 = id
	WHERE CASE WHEN direction = 'vertical' THEN x != pos ELSE y != pos END
),

t2 AS 
(
	SELECT * FROM t
	WHERE step = 
		(SELECT MAX(id) FROM folding)
),

t3 AS 
(
	SELECT x,y, CASE WHEN step ISNULL THEN '.' ELSE '#' END AS dot
	FROM GENERATE_SERIES((SELECT MIN(x) FROM t2), (SELECT MAX(x) FROM t2))  AS s1(x) 
	CROSS JOIN GENERATE_SERIES((SELECT MIN(y) FROM t2 ) , (SELECT MAX(y) FROM t2)) AS s2(y) 
	NATURAL LEFT JOIN t2
)

SELECT y, STRING_AGG(dot,'') FROM t3 GROUP BY y ORDER BY y DESC;


