CREATE FOREIGN TABLE aoc2019_day2 (x text)
SERVER aoc2019 options(filename 'D:\aoc2019.day2.input');


CREATE  TEMPORARY TABLE program
(
	id SERIAL PRIMARY KEY,
	pos SERIAL,
	num INT
);

INSERT INTO program(num)
SELECT UNNEST(STRING_TO_ARRAY(x,','))::INT FROM aoc2019_day2;


UPDATE program SET num = 12 WHERE pos = 2;
UPDATE program SET num = 2 WHERE pos = 3;
UPDATE program SET pos = pos - 1;




-- Part 1


WITH RECURSIVE cte(pos, num, step) AS
(

	SELECT pos, num, -1 FROM program
	UNION ALL 
	SELECT * FROM
	(WITH cte_copy AS 
		(SELECT * FROM cte) 
	SELECT pos, 
	CASE WHEN pos =(SELECT num FROM cte_copy WHERE  pos = 4*(step+1)+ 3) THEN 
		CASE WHEN (SELECT num FROM cte_copy WHERE  pos = 4*(step+1)) = 1 THEN 
			(SELECT num FROM cte_copy WHERE pos = (SELECT num FROM cte_copy WHERE  pos = 4*(step+1)+ 1) ) + 
			(SELECT num FROM cte_copy WHERE pos = (SELECT num FROM cte_copy WHERE  pos = 4*(step+1)+ 2) )
		 ELSE     
		 (SELECT num FROM cte_copy WHERE pos = (SELECT num FROM cte_copy WHERE  pos = 4*(step+1)+ 1) ) * 
		 (SELECT num FROM cte_copy WHERE pos = (SELECT num FROM cte_copy WHERE  pos = 4*(step+1)+ 2) )
		 END ELSE num END, step + 1
	FROM cte_copy
	WHERE (SELECT num FROM cte_copy WHERE pos = 4*(step+1)) != 99
    
	) AS dt

)


SELECT num FROM cte ORDER BY step DESC, pos LIMIT 1 ;

-- Part 2


WITH  grid AS
(

	SELECT * FROM GENERATE_SERIES(0,99) AS x CROSS JOIN GENERATE_SERIES(0,99) AS y
)


SELECT x*100 + y AS answer FROM grid 
CROSS JOIN LATERAL ( SELECT num FROM ( SELECT * FROM

(

WITH RECURSIVE cte(pos, num, step) AS


(

	SELECT pos ,CASE WHEN pos = 1 THEN x WHEN pos = 2 THEN y ELSE num  END  , -1 FROM program
	UNION ALL 
	SELECT * FROM
	(WITH cte_copy AS 
		(SELECT * FROM cte) 
	SELECT pos, 
	CASE WHEN pos =(SELECT num FROM cte_copy WHERE  pos = 4*(step+1) + 3) THEN 
		CASE WHEN (SELECT num FROM cte_copy WHERE   pos = 4*(step+1)) = 1 THEN 
			(SELECT num FROM cte_copy WHERE pos = (SELECT num FROM cte_copy WHERE  pos = 4*(step+1)+ 1) ) + 
			(SELECT num FROM cte_copy WHERE pos = (SELECT num FROM cte_copy WHERE  pos = 4*(step+1)+ 2) )
		 ELSE     
		 (SELECT num FROM cte_copy WHERE pos = (SELECT num FROM cte_copy WHERE  pos = 4*(step+1)+ 1) ) * 
		 (SELECT num FROM cte_copy WHERE pos = (SELECT num FROM cte_copy WHERE  pos = 4*(step+1)+ 2) )
		 END ELSE num END, step + 1
	FROM cte_copy
	WHERE (SELECT num FROM cte_copy WHERE pos = 4*(step+1)) != 99
    
	) AS dt

) 

SELECT * FROM cte  
)AS dt2 ) AS dt3 ORDER BY step DESC, pos LIMIT 1 ) AS dt4 WHERE dt4.num = 19690720  ;








