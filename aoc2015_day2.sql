
CREATE FOREIGN TABLE aoc2015_day2 (x TEXT)
SERVER aoc2015 options(filename 'D:\aoc2015.day2.input');



CREATE  TEMPORARY TABLE prisms
(
	id SERIAL,
	stretch INT,
	width INT,
	height INT
	
);


INSERT INTO prisms (stretch, width, height)
SELECT 
SPLIT_PART(x,'x',1)::INT,
SPLIT_PART(x,'x',2)::INT,
SPLIT_PART(x,'x',3)::INT
FROM aoc2015_day2;


-- Part 1


SELECT 
SUM
(
2 * (stretch * width +  stretch * height + width * height) + 
LEAST(stretch * width, stretch * height, width * height)
)  

FROM prisms;


-- Part 2


SELECT  SUM( 2 * (lenghts[1] + lenghts[2])
		    + stretch * width * height)
  
FROM prisms CROSS JOIN LATERAL (VALUES (SORT(ARRAY[stretch, width, height]))) AS t(lenghts);




