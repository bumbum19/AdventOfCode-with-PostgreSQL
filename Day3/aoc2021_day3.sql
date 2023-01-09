CREATE FOREIGN TABLE aoc2021_day3 (num text)
SERVER aoc2021 options(filename 'D:\aoc2021.day3.input');


 CREATE TEMPORARY TABLE submarine (
 id  SERIAL,
 num  INT[12]
  
 );


INSERT INTO submarine(num)
SELECT string_to_array(num,NULL)::INT[12] FROM aoc2021_day3;
 



-- Part 1

WITH cte AS 
(SELECT UNNEST(num) AS bit, UNNEST(ARRAY[1,2,3,4,5,6,7,8,9,10,11,12]) AS pos FROM submarine ),
 
cte2 AS 
(SELECT pos, bit, COUNT(*) AS cnt
 FROM cte
 GROUP BY pos, bit),
 
cte3 AS 
(SELECT DISTINCT ON (pos) pos, bit FROM cte2 ORDER BY pos, cnt DESC)
 
 
 SELECT ARRAY_TO_STRING(ARRAY_AGG(bit ORDER BY pos),'')::BIT(12)::INT * 
 (~(ARRAY_TO_STRING(ARRAY_AGG(bit ORDER BY pos),'')::BIT(12)))::INT AS power_consumption
 FROM cte3;
 
-- Solution: 4191876

-- Part 2 


CREATE OR REPLACE FUNCTION finder()
RETURNS INT LANGUAGE plpgsql AS $$
DECLARE 
a INT;
b INT;
BEGIN

CREATE TEMPORARY TABLE diagnostic (
  num    INT[12],
  oxy_gen BOOL  DEFAULT TRUE,
  c02_srub  BOOL DEFAULT  TRUE
  )
 ON COMMIT DROP;

INSERT INTO diagnostic
SELECT num FROM submarine;


FOR i IN  1..12 LOOP
 

WITH cte  AS
(SELECT num[i] AS bit, COUNT(*) AS cnt FROM diagnostic 
WHERE oxy_gen GROUP BY num[i] )


UPDATE diagnostic SET oxy_gen = FALSE 
WHERE num[i] != (SELECT  bit  FROM cte 
ORDER BY cnt DESC, bit DESC LIMIT 1);


WITH cte2 AS
(SELECT num[i]  AS bit, COUNT(*) AS cnt FROM diagnostic 
WHERE c02_srub GROUP BY num[i] )


UPDATE diagnostic SET c02_srub = FALSE 
WHERE num[i] != (SELECT  bit  FROM cte2 
ORDER BY cnt, bit LIMIT 1);





END LOOP;
SELECT INTO a ARRAY_TO_STRING(num,'')::BIT(12)::INT FROM diagnostic WHERE oxy_gen;
SELECT INTO b ARRAY_TO_STRING(num,'')::BIT(12)::INT FROM diagnostic WHERE c02_srub;

RETURN a * b;
END
$$;




SELECT finder();


DROP FUNCTION finder;

