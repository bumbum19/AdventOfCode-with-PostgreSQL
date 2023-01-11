
SET lc_messages TO 'en_US.UTF-8';




CREATE FOREIGN TABLE aoc2021_day8 (a text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day8.input');
  
  
  
  
  
  CREATE TEMPORARY TABLE  digits  (
  id  SERIAL,
  d1  text,
  d2  text,
  d3  text,
  d4  text
  
  
  
);

INSERT INTO digits(d1,d2,d3,d4)
SELECT 
SPLIT_PART(REPLACE(a,' | ', ' '),' ',11),
SPLIT_PART(REPLACE(a,' | ', ' '),' ',12),
SPLIT_PART(REPLACE(a,' | ', ' '),' ',13),
SPLIT_PART(REPLACE(a,' | ', ' '),' ',14) 
FROM aoc2021_day8;



-- Part 1

SELECT 
COUNT(*) FILTER (WHERE LENGTH(d1) IN (2,3,4,7)) +
COUNT(*) FILTER (WHERE LENGTH(d2) IN (2,3,4,7)) +
COUNT(*) FILTER (WHERE LENGTH(d3) IN (2,3,4,7)) +
COUNT(*) FILTER (WHERE LENGTH(d4) IN (2,3,4,7))  AS answer
FROM digits
;


-- Part 2


  CREATE TEMPORARY TABLE  digits2  (
  id  SERIAL,
  d0  text,
  d1  text,
  d2  text,
  d3  text,
  d4  text,
  d5  text,
  d6  text,
  d7  text,
  d8  text,
  d9  text
);

INSERT INTO digits2(d0,d1,d2,d3,d4,d5,d6,d7,d8,d9)
SELECT 
SPLIT_PART(a,' ',1),
SPLIT_PART(a,' ',2),
SPLIT_PART(a,' ',3),
SPLIT_PART(a,' ',4),
SPLIT_PART(a,' ',5),
SPLIT_PART(a,' ',6),
SPLIT_PART(a,' ',7),
SPLIT_PART(a,' ',8),
SPLIT_PART(a,' ',9),
SPLIT_PART(a,' ',10)
FROM aoc2021_day8;


SELECT * FROM digits2;



WITH t AS 

(SELECT id, TO_JSONB(ARRAY[d0,d1,d2,d3,d4,d5,d6,d7,d8,d9]) AS c FROM digits2),


t2 AS 
(
SELECT  id,
to_jsonb(string_to_array(jsonb_array_elements_text(jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{2}$") ')),NULL)) AS d1,
to_jsonb(string_to_array(jsonb_array_elements_text(jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{4}$") ')),NULL)) AS d4,
to_jsonb(string_to_array(jsonb_array_elements_text(jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{3}$") ')),NULL)) AS d7,
to_jsonb(string_to_array(jsonb_array_elements_text(jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{7}$") ')),NULL)) AS d8
FROM t
),


t3 AS 


(
SELECT  id,
to_jsonb(string_to_array(jsonb_array_elements_text(jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{5}$") ')),NULL)) 
AS d235

FROM t),

t4 AS 


(
SELECT  id,
to_jsonb(string_to_array(jsonb_array_elements_text(jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{6}$") ')),NULL)) 
AS d069

FROM t),





t5 AS 

(SELECT id, d235 AS d3, d069 AS d6  FROM t2 JOIN t3 USING (id) JOIN t4 USING (id) WHERE  d1 <@ d235 AND NOT d1 <@  d069 
) 
,

t6 AS 

(SELECT id, d069 AS d9  FROM t4 JOIN t5 USING (id) WHERE  d3 <@  d069 ),


t7 AS 

(SELECT id, d235 AS d5  FROM t3 JOIN t5 USING (id) WHERE  d235 <@  d6 ),





final AS 
(
SELECT id,  UNNEST(ARRAY[0,1,2,3,4,5,6,7,8,9]) AS digit, UNNEST(ARRAY[d069,d1,d235,d3,d4,d5,d6,d7,d8,d9]) AS encoding
FROM t2 JOIN t3 USING (id) JOIN t4 USING (id) JOIN t5 USING (id) JOIN t6 USING (id) JOIN t7 USING (id) 
WHERE d069 NOT IN (d6,d9) AND d235 NOT IN (d3,d5) 
) ,

s AS
(
SELECT id, UNNEST(ARRAY[3,2,1,0]) AS pos, TO_JSONB(STRING_TO_ARRAY(UNNEST(ARRAY[d1,d2,d3,d4]), NULL)) AS encoding FROM digits
)









SELECT SUM(digit*POWER(10,pos)) FROM final JOIN s USING(id) WHERE final.encoding <@ s.encoding AND s.encoding <@ final.encoding  ;



























