CREATE FOREIGN TABLE aoc2021_day6 (a text)
  SERVER aoc2022 options(filename 'D:\aoc2021.day6.input');



CREATE TEMPORARY TABLE   laternfish  (
  day  INT,
  x  INT[]


);


INSERT INTO laternfish  (day,x)
SELECT 0 ,STRING_TO_ARRAY(a,',')::INT[]  FROM aoc2021_day6;



CREATE OR REPLACE FUNCTION add_array(a INT[], b INT[], OUT c INT[])
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
   ARRAY[CARDINALITY(ARRAY_POSITIONS(x, 0))])),-1, 6)             , 
   day + 1
   FROM cte WHERE day < 80

)

 SELECT CARDINALITY(x) FROM cte WHERE day = 80;





