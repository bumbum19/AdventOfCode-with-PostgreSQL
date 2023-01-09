SET lc_messages TO 'en_US.UTF-8';


SET client_encoding = 'UTF8';
SET client_encoding = 'latin1'


CREATE FOREIGN TABLE aoc2021_day6 (a text)
  SERVER aoc2022 options(filename 'D:\aoc2021.day6.input');



CREATE TEMPORARY TABLE   laternfish  (
  day  SERIAL,
  x  INT[]


);


INSERT INTO laternfish  (x)
SELECT STRING_TO_ARRAY(a,',')::INT[]  FROM aoc2021_day6;






CREATE FUNCTION add_array(a INT[3], b INT[3]) 
RETURNS INT[3] LANGUAGE plpgsql AS $$
DECLARE 
c INT[3];
BEGIN 
FOR i 
IN 1..3 LOOP
 c:= ARRAY_APPEND(c, a[i] + b[i]);
END LOOP;
RETURN c;  
END
$$;



CREATE FUNCTION inc(val integer) RETURNS integer AS $$
BEGIN
RETURN val + 1;
END
$$;







DO $$
DECLARE
  a INT[10]; -- start of packetmarker

BEGIN
FOR q IN 1..10 LOOP
 a := ARRAY_APPEND(a,1);
END LOOP;
RAISE NOTICE 'Characters before start-of-message marker: %', a;
END
$$;























 \timing on



 WITH RECURSIVE t AS
 (
   SELECT a, 1 from laternfish;

   UNION ALL







 )

 SELECT
 ARRAY_REPLACE(ARRAY_CAT(ARRAY_AGG(y-1), ARRAY_FILL(8, ARRAY[CARDINALITY(ARRAY_POSITIONS(ARRAY_AGG(y-1), 0))])),0,6)
 AS x FROM laternfish l CROSS JOIN UNNEST(l.x ) AS y;




 SELECT cardinality(array_positions(x, 1)) FROM laternfish ;



 select array_fill(0, ARRAY[4])


  SELECT
*
FROM laternfish l CROSS JOIN LATERAL UNNEST(l.x ) AS y;
