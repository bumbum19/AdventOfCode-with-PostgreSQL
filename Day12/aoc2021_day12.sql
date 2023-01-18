



CREATE FOREIGN TABLE aoc2021_day12 (a text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day12.input');
 
 
 
 
CREATE TEMPORARY TABLE  caves (
id  SERIAL,
v1  text, 
v2 text
);


INSERT INTO caves(v1,v2)
SELECT 
SPLIT_PART(a,'-',1),
SPLIT_PART(a,'-',2)
FROM aoc2021_day12;

-- Part 1

WITH RECURSIVE s AS 


(SELECT v1, v2 FROM caves 
WHERE v1 != 'end' AND v2 !=  'start'
UNION ALL  
SELECT v2, v1 FROM caves
WHERE v1 !=  'start' AND v2 != 'end' )
,

 t(v1,v2, is_cycle, path) AS 

(

SELECT *, FALSE, ARRAY[s.v1]  
FROM s WHERE v1 = 'start'
UNION ALL
SELECT s.v1, s.v2, CASE WHEN s.v1 = LOWER(s.v1) THEN s.v1 = ANY(path) ELSE FALSE END,
    CASE WHEN s.v2 != 'end' THEN path || s.v1 ELSE  path || s.v1  || s.v2 END
 FROM  s 
 JOIN t
 ON s.v1 = t.v2 AND NOT is_cycle
) 


SELECT COUNT(path) FROM t WHERE NOT is_cycle AND v2 = 'end' ;


-- Part 2


WITH RECURSIVE s AS 


(SELECT v1, v2 FROM caves 
WHERE v1 != 'end' AND v2 !=  'start'
UNION ALL  
SELECT v2, v1 FROM caves 
WHERE v1 !=  'start' AND v2 != 'end'
)
,

 t(v1,v2, is_cycle, dummy, path) AS 

(

SELECT *, FALSE , FALSE, ARRAY[s.v1]  
FROM s WHERE v1 = 'start'
UNION ALL
SELECT s.v1, s.v2, 
		CASE WHEN s.v1 = LOWER(s.v1)  THEN s.v1 = ANY(path) 
			 ELSE FALSE 
		END,
		CASE WHEN s.v1 = LOWER(s.v1) AND s.v1 = ANY(path) AND NOT dummy  THEN TRUE 
		   WHEN s.v1 = LOWER(s.v1) AND s.v1 = ANY(path) AND dummy  THEN FALSE 
		   ELSE dummy 
		END,
     CASE WHEN s.v2 != 'end' THEN path || s.v1 ELSE  path || s.v1  || s.v2 END
 FROM  s 
 JOIN t
 ON s.v1 = t.v2 AND (NOT is_cycle OR dummy)

) 


SELECT COUNT(*) FROM t 
WHERE (NOT is_cycle OR dummy) 
AND v2 = 'end' 
;

















