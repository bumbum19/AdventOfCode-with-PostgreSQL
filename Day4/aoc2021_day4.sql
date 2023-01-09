
CREATE FOREIGN TABLE aoc2021_day4 (line text)
SERVER aoc2021 options(filename 'D:\aoc2021.day4.input');

CREATE TEMPORARY TABLE bingo (
  id SERIAL,
  board INT,
  col1  INT,
  col2  INT,
  col3  INT,
  col4  INT,
  col5  INT
  
);




INSERT INTO bingo (board,col1,col2,col3,col4,col5) 

WITH cte AS 
(SELECT line,
	   ROW_NUMBER() OVER ()  AS rnk,
       	 NTILE(100) OVER () AS board
FROM   aoc2021_day4
WHERE line != '' 
)
SELECT 
board ,
SPLIT_PART(LTRIM(REPLACE(line,'  ',' ')), ' ', 1)::INT  ,
       SPLIT_PART(LTRIM(REPLACE(line,'  ',' ')), ' ', 2) ::INT ,
	   SPLIT_PART(LTRIM(REPLACE(line,'  ',' ')), ' ', 3)::INT , 
	   SPLIT_PART(LTRIM(REPLACE(line,'  ',' ')), ' ', 4) ::INT ,
	   SPLIT_PART(LTRIM(REPLACE(line,'  ',' ')), ' ', 5) ::INT 

FROM cte WHERE rnk > 1
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


WITH bingo2 AS 
(
SELECT board, ROW_NUMBER() OVER 
	(PARTITION BY board 
	 ORDER BY id) AS x_pos, 
UNNEST(ARRAY[1,2,3,4,5]) AS y_pos ,
UNNEST(ARRAY[col1, col2, col3, col4, col5]) AS num
FROM bingo
),

cte AS 

(
SELECT id, board, COUNT(*) OVER 
	(PARTITION BY board, x_pos, y_pos 
	 ORDER BY id ROWS UNBOUNDED PRECEDING) AS cnt 
FROM bingo2 JOIN  marker USING(num) 
GROUP BY GROUPING SETS (
    (id, board, x_pos),
    (id, board, y_pos) )
	
	

),


cte2 AS

(
SELECT board, id, num * SUM(num) OVER 
		(PARTITION BY board 
		 ORDER BY id DESC  ROWS UNBOUNDED PRECEDING EXCLUDE CURRENT ROW) AS score
 FROM  bingo2 JOIN  marker USING(num)    
GROUP BY board, id, num  
)


SELECT score 
FROM cte2 
WHERE (board,id) IN 
	(SELECT board, id FROM cte WHERE  cnt = 5  ORDER BY id, board LIMIT 1) ; 

-- Solution: 21070


-- Part 2


WITH bingo2 AS 
(
SELECT board, ROW_NUMBER() OVER 
	(PARTITION BY board 
	 ORDER BY id) AS x_pos, 
UNNEST(ARRAY[1,2,3,4,5]) AS y_pos ,
UNNEST(ARRAY[col1, col2, col3, col4, col5]) AS num
FROM bingo
),

cte AS 

(
SELECT id, board, COUNT(*) OVER 
	(PARTITION BY board, x_pos, y_pos 
	 ORDER BY id ROWS UNBOUNDED PRECEDING) AS cnt 
FROM bingo2 JOIN  marker USING(num) 
GROUP BY GROUPING SETS (
    (id, board, x_pos),
    (id, board, y_pos) )
	
	

),


cte2 AS

(
SELECT board, id, num * SUM(num) OVER 
	(PARTITION BY board 
	 ORDER BY id DESC  ROWS UNBOUNDED PRECEDING EXCLUDE CURRENT ROW) AS score
 FROM  bingo2 JOIN  marker USING(num)    
GROUP BY board, id, num  
),



cte3 AS 


(

SELECT DISTINCT ON (board) board, id FROM cte 
WHERE  cnt = 5  ORDER BY board, id 

)



SELECT score FROM cte2 WHERE (board,id) 
	IN (SELECT board, id FROM cte3 ORDER BY id DESC, board DESC LIMIT 1) ; 






