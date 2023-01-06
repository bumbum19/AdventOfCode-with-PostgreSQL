CREATE FOREIGN TABLE aoc2021_day4 (line text)
SERVER aoc2021 options(filename 'D:\aoc2021.day4.input');

CREATE TEMPORARY TABLE bingo (
  col1  INT,
  col2  INT,
  col3  INT,
  col4  INT,
  col5  INT
  
);




INSERT INTO bingo

WITH cte AS 
(SELECT line,
	   ROW_NUMBER() OVER () AS rnk
FROM   aoc2021_day4
WHERE line != '' 
)
SELECT 
SPLIT_PART(LTRIM(REPLACE(line,'  ',' ')), ' ', 1)::INT AS col1 ,
SPLIT_PART(LTRIM(REPLACE(line,'  ',' ')), ' ', 2) ::INT AS col2,
SPLIT_PART(LTRIM(REPLACE(line,'  ',' ')), ' ', 3)::INT AS col3, 
SPLIT_PART(LTRIM(REPLACE(line,'  ',' ')), ' ', 4) ::INT AS col4,
SPLIT_PART(LTRIM(REPLACE(line,'  ',' ')), ' ', 5) ::INT AS col5

FROM cte WHERE rnk > 1
;



CREATE TEMPORARY TABLE bingo2 (
  board  INT,
  x_pos  INT,
  y_pos  INT,
  num INT
  
);



INSERT INTO bingo2


WITH cte AS
(SELECT *, NTILE(100) OVER () AS board FROM bingo)
,
cte2 AS
(SELECT 
*, ROW_NUMBER() OVER (PARTITION BY board) AS x_pos
FROM cte 
)

SELECT board, x_pos, 
UNNEST(ARRAY[1,2,3,4,5]),
UNNEST(ARRAY[col1, col2, col3, col4, col5]) 
FROM cte2
;




CREATE TEMPORARY TABLE marker (
  id  SERIAL,
  num  INT
  
);


INSERT INTO marker(num)

WITH cte AS 
(SELECT line,
	   ROW_NUMBER() OVER () AS rnk
FROM   aoc2021_day4
WHERE line != '' 
)
SELECT 
CAST(STRING_TO_TABLE(line,',') AS INT)

FROM cte WHERE rnk = 1
;



-- Part 1

WITH cte AS 

(
SELECT id, board, COUNT(*) OVER (PARTITION BY board, x_pos, y_pos ORDER BY id ROWS UNBOUNDED PRECEDING) AS cnt 
FROM bingo2 JOIN  marker USING(num) 
GROUP BY GROUPING SETS (
    (id, board, x_pos),
    (id, board, y_pos) )
	
	

),


cte2 AS

(
SELECT board, id, num*SUM(num) OVER (PARTITION BY board ORDER BY id DESC  ROWS UNBOUNDED PRECEDING EXCLUDE CURRENT ROW) AS score
 FROM  bingo2 JOIN  marker USING(num)    
GROUP BY board, id, num  
)


SELECT score FROM cte2 WHERE (board,id) IN (SELECT board, id FROM cte WHERE  cnt = 5  ORDER BY id, board LIMIT 1) ; 




-- Part 2


WITH cte AS 

(
SELECT id, board, COUNT(*) OVER (PARTITION BY board, x_pos, y_pos ORDER BY id ROWS UNBOUNDED PRECEDING) AS cnt 
FROM bingo2 JOIN  marker USING(num) 
GROUP BY GROUPING SETS (
    (id, board, x_pos),
    (id, board, y_pos) )
	
	

),


cte2 AS

(
SELECT board, id, num*SUM(num) OVER (PARTITION BY board ORDER BY id DESC  ROWS UNBOUNDED PRECEDING EXCLUDE CURRENT ROW) AS score
 FROM  bingo2 JOIN  marker USING(num)    
GROUP BY board, id, num  
),



cte3 AS 


(

SELECT DISTINCT ON (board) board, id FROM cte WHERE  cnt = 5  ORDER BY board , id 

)



SELECT score FROM cte2 WHERE (board,id) 
	IN (SELECT board, id FROM cte3 ORDER BY id DESC, board DESC LIMIT 1) ; 






