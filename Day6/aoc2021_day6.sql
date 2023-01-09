SET lc_messages TO 'en_US.UTF-8';


SET client_encoding = 'UTF8';
SET client_encoding = 'latin1'


CREATE FOREIGN TABLE aoc2021_day6 (a text)
  SERVER aoc2022 options(filename 'D:\aoc2021.day6.input');



CREATE TEMPORARY TABLE   laternfish  (
  day  INT,
  x  INT[]


);


INSERT INTO laternfish(day,x) VALUES (0, ARRAY[3,4,3,1,2]);

INSERT INTO laternfish  (day,x)
SELECT 0 ,STRING_TO_ARRAY(a,',')::INT[]  FROM aoc2021_day6;








CREATE OR REPLACE FUNCTION add_array(
	a INT[],
	b INT[],
	OUT c INT[])
    LANGUAGE plpgsql
 AS $BODY$
BEGIN

	FOR i IN 1..CARDINALITY(a) LOOP
    c = ARRAY_APPEND(c, a[i]+b[i]);
	END LOOP;
	
END;
$BODY$;













-- Part 1


WITH RECURSIVE cte AS
 (
   SELECT x, day FROM laternfish
   UNION ALL
   SELECT ARRAY_REPLACE(ARRAY_CAT(ADD_ARRAY(x,ARRAY_FILL(-1, ARRAY[CARDINALITY(x)])),ARRAY_FILL(8, 
    ARRAY[CARDINALITY(ARRAY_POSITIONS(x, 0))])),-1,6)             , 
    day + 1
    FROM cte WHERE day < 80

)

 SELECT CARDINALITY(x) FROM cte WHERE day = 80;




 -- Part 2
 
 
 TRUNCATE laternfish;
 
 INSERT INTO laternfish(day,x) VALUES (0, ARRAY[8]);
 
 
 
 
 
 
 
 WITH RECURSIVE cte AS
 (
   SELECT day, x, CARDINALITY(x) AS cnt FROM laternfish
   UNION ALL
   SELECT day + 1,ARRAY_REPLACE(ARRAY_CAT(ADD_ARRAY(x,ARRAY_FILL(-1, ARRAY[CARDINALITY(x)])),ARRAY_FILL(8, 
    ARRAY[CARDINALITY(ARRAY_POSITIONS(x, 0))])),-1,6), CARDINALITY(ARRAY_REPLACE(ARRAY_CAT(ADD_ARRAY(x,ARRAY_FILL(-1, ARRAY[CARDINALITY(x)])),ARRAY_FILL(6, 
    ARRAY[CARDINALITY(ARRAY_POSITIONS(x, 0))])),-1,6))
    FROM cte WHERE day < 30

)

 SELECT day, cnt, POWER(2,day/7), x FROM cte;











WITH RECURSIVE t(x) AS 

(SELECT 0::NUMERIC,0::NUMERIC 
UNION ALL

SELECT x+1, POWER(2,x+1)::BIGINT FROM t WHERE x < 4)

SELECT * FROM t;