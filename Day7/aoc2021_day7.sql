CREATE FOREIGN TABLE aoc2021_day7 (a text)
  SERVER aoc2022 options(filename 'D:\aoc2021.day7.input');
 




CREATE TEMPORARY TABLE   crabs  (
  id  SERIAL,
  pos  INT
  
); 
  
  

INSERT INTO crabs(pos)
SELECT regexp_split_to_table(a,',')::INT FROM  aoc2021_day7;



-- Part 1


WITH median AS 
(
SELECT percentile_disc(0.5) WITHIN GROUP (ORDER BY pos)  FROM crabs)




SELECT SUM(ABS(pos - (TABLE median))) AS costs FROM crabs;


-- Part 2


WITH mean_screw AS 
(
SELECT ROUND(AVG(pos)-0.5,0) FROM crabs)


SELECT SUM((POW(ABS(pos - (TABLE mean_screw)),2)+ ABS(pos - (TABLE mean))) / 2 ) AS costs FROM crabs;

