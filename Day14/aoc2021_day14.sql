SET lc_messages TO 'en_US.UTF-8';



CREATE FOREIGN TABLE aoc2021_day14 (x text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day14.input');
 
 
 CREATE TEMPORARY TABLE  polymer (
  day  INT,
  x  text


);

INSERT INTO polymer 
SELECT 0, x FROM aoc2021_day14 WHERE 
x != '' AND x NOT LIKE '%->%';










INSERT INTO polymer(day,x) VALUES (0,'NNCB');


CREATE TEMPORARY TABLE  rules (
  id  SERIAL,
  adj  CHAR(2),
  bet  CHAR(1)
  );
  
  
INSERT INTO rules(adj,bet)
SELECT 
SPLIT_PART(x,' -> ',1),
SPLIT_PART(x,' -> ',2)
FROM aoc2021_day14
WHERE 
x != '' AND x  LIKE '%->%';






INSERT INTO rules (adj, bet)
VALUES
('CH', 'B'),
('HH', 'N'),
('CB', 'H'),
('NH', 'C'),
('HB', 'C'),
('HC', 'B'),
('HN', 'C'),
('NN', 'C'),
('BH', 'H'),
('NC', 'B'),
('NB', 'B'),
('BN', 'B'),
('BB', 'N'),
('BC', 'B'),
('CC', 'N'),
('CN', 'C');

-- Part 1
 

WITH RECURSIVE s AS 
(

SELECT r1.adj AS v1, r2.adj AS v2 FROM rules r1 JOIN rules r2 ON 
SUBSTR(r1.adj,1,1) || r1.bet = r2.adj OR 
 r1.bet || SUBSTR(r1.adj,2) = r2.adj
),


t(v1,v2,step) AS 
(
SELECT SUBSTR(x,pos,2) AS v1, SUBSTR(x,pos,2) AS v2, 0
FROM polymer CROSS JOIN  GENERATE_SERIES(1,LENGTH(x)-1) AS pos
UNION ALL
SELECT t.v2, s.v2, step + 1
FROM t JOIN s ON
t.v2 = s.v1 WHERE step < 8
),

cte AS 
(

SELECT SUBSTR(v2,2),COUNT(*) + CASE WHEN SUBSTR((SELECT x FROM polymer),1,1) = SUBSTR(v2,2) THEN 1 ELSE 0 END  AS cnt 
FROM t WHERE step = 8 GROUP BY SUBSTR(v2,2) 
)


SELECT * FROM cte;

SELECT MAX(cnt) - MIN(cnt) AS answer FROM cte;


-- Part 2







WITH RECURSIVE s AS 
(

SELECT r1.adj AS v1, r2.adj AS v2 FROM rules r1 JOIN rules r2 ON 
SUBSTR(r1.adj,1,1) || r1.bet = r2.adj OR 
 r1.bet || SUBSTR(r1.adj,2) = r2.adj
),

t(v1,v2,step) AS 
(
SELECT DISTINCT v1 AS v1, v1 AS v2, 0
FROM s

UNION ALL
SELECT t.v1, s.v2, step + 1
FROM t JOIN s ON
t.v2 = s.v1 WHERE step < 10
),

cte AS  (
SELECT v1, v2, COUNT(*) AS cnt 
FROM t WHERE step = 10 GROUP BY v1, v2 
),

cte2 AS 
(

SELECT  a.v1, b.v2, SUM(a.cnt * b.cnt )::BIGINT    AS cnt
FROM cte a 
JOIN cte b 
	ON a.v2 = b.v1

GROUP BY a.v1, b.v2

),

cte3 AS 
(

SELECT  SUBSTR(b.v2,2), SUM(a.cnt * b.cnt )::BIGINT    +
CASE WHEN SUBSTR((SELECT x FROM polymer),1,1) = SUBSTR(b.v2,2) THEN 1 ELSE 0 END  AS cnt
FROM cte2 a 
JOIN (SELECT SUBSTR(x,pos,2) AS x FROM polymer CROSS JOIN  GENERATE_SERIES(1,LENGTH(x)-1) AS pos) AS u
	ON u.x = a.v1
JOIN cte2 b 
	ON a.v2 = b.v1

GROUP BY SUBSTR(b.v2,2)

)

SELECT MAX(cnt) - MIN(cnt) AS answer FROM cte3;











2965769177100

47452306833600



