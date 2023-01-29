CREATE FOREIGN TABLE aoc2022_day4 (a text, b text)
SERVER aoc2022 options(filename 'D:\aoc2022.day4.input', delimiter ',');



CREATE TEMPORARY TABLE  camp (
  id  SERIAL ,
  sections1 INT4RANGE,
  sections2 INT4RANGE
  
  );


INSERT INTO camp(sections1, sections2)
SELECT
INT4RANGE(SPLIT_PART(a,'-',1)::INT,SPLIT_PART(a,'-',2)::INT,'[]'),INT4RANGE(SPLIT_PART(b,'-',1)::INT,SPLIT_PART(b,'-',2)::INT,'[]')
FROM aoc2022_day4;


-- Part 1

SELECT  COUNT(CASE WHEN sections1 <@ sections2 OR sections1 @> sections2 THEN TRUE ELSE NULL END) FROM camp;




-- Part 2


SELECT  COUNT(CASE WHEN sections1 && sections2 THEN TRUE ELSE NULL END) FROM camp;
