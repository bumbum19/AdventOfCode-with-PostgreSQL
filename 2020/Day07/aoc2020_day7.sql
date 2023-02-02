CREATE FOREIGN TABLE aoc2020_day7 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day7.input',NULL '');


CREATE FOREIGN TABLE aoc2020_day7_test (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day7_test.input',NULL '');










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





-- Part 1


WITH RECURSIVE cte (bag) AS 
(  
	SELECT bag1 FROM bag_containment  JOIN bags b ON bag2 = b.id 
	WHERE color = 'gold' AND pattern = 'shiny'
	UNION   
	SELECT bg.bag1 FROM bag_containment bg JOIN cte ON cte.bag = bg.bag2
	
)

SELECT COUNT(*) FROM cte JOIN bags b ON cte.bag = b.id; 





-- Part 2




WITH RECURSIVE cte (bag, volume) AS 
(  
	SELECT id, 1 FROM bags   
	WHERE color = 'gold' AND pattern = 'shiny'
	UNION  ALL 
	SELECT bg.bag2, volume * weight FROM bag_containment bg JOIN cte ON cte.bag = bg.bag1
	
)

SELECT SUM(volume) - 1 AS n_bags FROM cte JOIN bags b ON cte.bag = b.id ;



	





