SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2021_day10 (a text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day10.input');
 
 
  
 CREATE TEMPORARY TABLE  syntax_checker  (
  id  SERIAL,
  chunks  text
  );
  
  
  INSERT INTO syntax_checker (chunks)
  SELECT * FROM aoc2021_day10;
  
  
  

  
  
WITH RECURSIVE t (chunks, step) AS 
(
SELECT REPLACE(REPLACE(REPLACE(REPLACE(chunks, '()', ''),'[]', ''),'<>', ''),'{}', ''), 1  FROM syntax_checker
UNION ALL
SELECT REPLACE(REPLACE(REPLACE(REPLACE(chunks, '()', ''),'[]', ''),'<>', ''),'{}', ''), step + 1  FROM t
WHERE step < 100
),

 s AS 
(
SELECT CASE
 WHEN regexp_match(chunks,'[\}\]\)\>]') =  '{"}"}' THEN 1197
 WHEN regexp_match(chunks,'[\}\]\)\>]') =  '{>}' THEN 25137
 WHEN regexp_match(chunks,'[\}\]\)\>]') =  '{)}' THEN 3
 WHEN regexp_match(chunks,'[\}\]\)\>]') =  '{]}' THEN 57
 END AS score FROM t WHERE step = 100
)


SELECT SUM(score) FROM s;





-- Part 2

WITH RECURSIVE cte (id, chunks, step) AS 
(
SELECT id, REPLACE(REPLACE(REPLACE(REPLACE(chunks, '()', ''),'[]', ''),'<>', ''),'{}', ''), 1  FROM syntax_checker
UNION ALL
SELECT id, REPLACE(REPLACE(REPLACE(REPLACE(chunks, '()', ''),'[]', ''),'<>', ''),'{}', ''), step + 1  FROM cte
WHERE step < 100
),

 s AS 
(
SELECT id, chunks ,CASE
 WHEN regexp_match(chunks,'[\}\]\)\>]') IS  NULL THEN TRUE
 ELSE FALSE 
 END AS uncomplete FROM cte WHERE step = 100
),


cte2 AS 
(

SELECT id , symbol, pos
FROM s CROSS JOIN UNNEST(STRING_TO_ARRAY(chunks, NULL) ) WITH ORDINALITY AS t (symbol, pos) 
WHERE  uncomplete 
),

scores (symbol, score) AS (
    VALUES ('(', 1),
           ('[', 2),
           ('{', 3),
           ('<', 4)
		   
		   ),
           
		
cte3 AS 
(		
SELECT SUM(POWER(5,pos-1)*score) AS total_score  FROM cte2 JOIN scores USING (symbol) GROUP BY id
)

SELECT percentile_disc(0.5) WITHIN GROUP (ORDER BY total_score) AS answer   FROM cte3;
