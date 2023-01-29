SET lc_messages TO 'en_US.UTF-8';


CREATE FOREIGN TABLE aoc2022_day11(x text)
 SERVER aoc2022 options(filename 'D:\aoc2022.day11.input');
 
 






CREATE TEMPORARY TABLE  monkeys  (
monkey  INT,
items  INT[],
polynomial INT[3],
test INT[3]
);


INSERT INTO monkeys
VALUES
(0,ARRAY[79,98],          ARRAY[0,19,0], ARRAY[23,2,3]),
(1,ARRAY[54, 65, 75, 74], ARRAY[6,1,0],  ARRAY[19,2,0]),
(2,ARRAY[79, 60, 97],     ARRAY[0,0,1],  ARRAY[13,1,3]),
(3,ARRAY[74],             ARRAY[3,1,0],  ARRAY[17,0,1]);
----------------------------------------------------------


CREATE TEMPORARY TABLE  monkeys  (
monkey  INT,
items  INT[],
polynomial INT[3],
test INT[3]
);









INSERT INTO monkeys
VALUES
(0, ARRAY[89, 95, 92, 64, 87, 68],          ARRAY[0,11,0], ARRAY[2,7,4]),
(1, ARRAY[87, 67],                          ARRAY[1,1,0],  ARRAY[13,3,6]),
(2, ARRAY[95, 79, 92, 82, 60],              ARRAY[6,1,0],  ARRAY[3,1,6]),
(3, ARRAY[67, 97, 56],                      ARRAY[0,0,1],  ARRAY[17,7,0]),
(4, ARRAY[80, 68, 87, 94, 61, 59, 50, 68],  ARRAY[0,7,0],  ARRAY[19,5,2]),
(5, ARRAY[ 73, 51, 76, 59],                 ARRAY[8,1,0],  ARRAY[7,2,1]),
(6, ARRAY[92],                              ARRAY[5,1,0],  ARRAY[11,3,0]),
(7 ,ARRAY[99, 76, 78, 76, 79, 90, 89],      ARRAY[7,1,0],  ARRAY[5,4,5]);








WITH RECURSIVE cte(step, substep,  monkey, item)  AS 

(
	SELECT 0, (SELECT COUNT(*) FROM monkeys) -1, monkey, UNNEST(items) AS item FROM monkeys
	UNION ALL
	SELECT CASE WHEN substep = (SELECT COUNT(*) FROM monkeys) -1 THEN step + 1 ELSE step END, MOD(substep + 1,(SELECT COUNT(*) FROM monkeys)), 
	CASE WHEN monkey = MOD(substep + 1,(SELECT COUNT(*) FROM monkeys)) THEN  
	CASE WHEN MOD((polynomial[1]+ item *polynomial[2]+ POW(item,2)*polynomial[3])::INT/3,test[1]) = 0 THEN test[2] ELSE test[3] END
	ELSE monkey END, 
	CASE WHEN monkey = MOD(substep + 1,(SELECT COUNT(*) FROM monkeys)) THEN
	(polynomial[1]+ item *polynomial[2]+ POW(item,2)*polynomial[3])::INT/3  ELSE item END
	FROM cte JOIN  monkeys 
	USING (monkey)
	WHERE   (step, substep) != ( 20, (SELECT COUNT(*) FROM monkeys) -1)
 ),
 
 
 
 
cte2 AS
(

	SELECT monkey ,COUNT(*) FILTER (WHERE CASE WHEN monkey = 0 THEN substep = (SELECT COUNT(*) FROM monkeys) -1 AND step < 20
	ELSE monkey - 1 = substep END ) AS cnt FROM cte WHERE step <= 20 GROUP BY monkey ORDER BY cnt DESC 
	--LIMIT 2
)


--TABLE cte;

--TABLE cte;


SELECT (SELECT cnt FROM  cte2 LIMIT 1) * (SELECT cnt FROM cte2 OFFSET 1 LIMIT 1);



-- Part 2



WITH RECURSIVE cte(step, substep,  monkey, item)  AS 

(
	SELECT 0, (SELECT COUNT(*) FROM monkeys) -1, monkey, UNNEST(items)::DECIMAL AS item FROM monkeys
	UNION ALL
	SELECT CASE WHEN substep = (SELECT COUNT(*) FROM monkeys) -1 THEN step + 1 ELSE step END, MOD(substep + 1,(SELECT COUNT(*) FROM monkeys)), 
	CASE WHEN monkey = MOD(substep + 1,(SELECT COUNT(*) FROM monkeys)) THEN  
	CASE WHEN MOD(MOD((polynomial[1]+ item * polynomial[2]+ POW(item,2)*polynomial[3])::DECIMAL,(SELECT EXP(SUM(LN(test[1])))::INT FROM monkeys)) ,
	test[1]) = 0 THEN test[2] ELSE test[3] END
	ELSE monkey END, 
	CASE WHEN monkey = MOD(substep + 1,(SELECT COUNT(*) FROM monkeys)) THEN
	MOD((polynomial[1]+ item *polynomial[2]+ POW(item,2)*polynomial[3])::DECIMAL,(SELECT EXP(SUM(LN(test[1])))::INT FROM monkeys))  ELSE item END
	FROM cte JOIN  monkeys 
	USING (monkey)
	WHERE   (step, substep) != ( 10000, (SELECT COUNT(*) FROM monkeys) -1)
 ),
 
 
 
 
cte2 AS
(

	SELECT monkey ,COUNT(*) FILTER (WHERE CASE WHEN monkey = 0 THEN substep = (SELECT COUNT(*) FROM monkeys) -1 AND step < 10000
	ELSE monkey - 1 = substep END ) AS cnt FROM cte WHERE step <= 10000 GROUP BY monkey ORDER BY cnt DESC
	
)





SELECT (SELECT cnt FROM  cte2 LIMIT 1) * (SELECT cnt FROM cte2 OFFSET 1 LIMIT 1);






SELECT EXP(SUM(LN(test[1])))::INT FROM monkeys;
SELECT EXP(SUM(LN(test[1]))) FROM monkeys;