CREATE FOREIGN TABLE aoc2017_day8 (x TEXT)
SERVER aoc2017 options(filename 'D:\aoc2017.day8.input');



CREATE TEMPORARY TABLE reg_update 
(
	id SERIAL ,
	register TEXT,
	trans_val INT,
	comp_register TEXT,
	comp_operator TEXT,
    compare_val INT	
	
);


INSERT INTO reg_update(register, trans_val, comp_register, comp_operator, compare_val)
SELECT 
SPLIT_PART(x, ' ', 1),
CASE WHEN SPLIT_PART(x, ' ', 2)  = 'dec' THEN -1 * SPLIT_PART(x, ' ', 3)::INT
ELSE SPLIT_PART(x, ' ', 3)::INT END,
SPLIT_PART(x, ' ', 5),
SPLIT_PART(x, ' ', 6),
SPLIT_PART(x, ' ', 7)::INT

FROM aoc2017_day8;



------------------------

CREATE TEMPORARY TABLE reg_update 
(
	id SERIAL,
	register TEXT,
	trans_val INT,
	comp_register TEXT,
	comp_operator TEXT,
    compare_val INT	
	
);


INSERT INTO reg_update(register, trans_val, comp_register, comp_operator, compare_val)
VALUES 
('b', 5, 'a', '>', 1),
('a', 1, 'b', '<', 5),
('c', 10, 'a', '>=', 1),
('c', -20, 'c', '==', 10);



























WITH RECURSIVE registers(register, step, val) AS 
(
	SELECT DISTINCT register, 0, 0 FROM reg_update
	UNION ALL
	SELECT * FROM
	(
		WITH registers_copy AS 
		(
			SELECT * FROM registers
		
		)
		
		SELECT  rc.register, step + 1,
		CASE WHEN rc.register = ru.register THEN
			CASE WHEN comp_operator = '<' AND 
				      dt.val < compare_val OR 
					  comp_operator = '<=' AND 
				      dt.val <= compare_val OR 
				      comp_operator = '>' AND 
				      dt.val > compare_val OR 
				      comp_operator = '>=' AND 
				      dt.val >= compare_val OR 
				     comp_operator = '==' AND 
				     dt.val = compare_val OR 
					 comp_operator = '!=' AND 
				     dt.val != compare_val 
					THEN rc.val + trans_val ELSE rc.val END
			ELSE rc.val END 
		
		
		
		
		FROM registers_copy rc 
		JOIN reg_update ru
			ON id = step + 1
		CROSS JOIN LATERAL( SELECT val FROM registers_copy WHERE comp_register = register ) AS dt
			
	) AS dt
	
	
)

SELECT DISTINCT ON (step) val 
FROM registers 
ORDER BY step DESC, val DESC 
LIMIT 1;



-- Part 2


WITH RECURSIVE registers(register, step, val) AS 
(
	SELECT DISTINCT register, 0, 0 FROM reg_update
	UNION ALL
	SELECT * FROM
	(
		WITH registers_copy AS 
		(
			SELECT * FROM registers
		
		)
		
		SELECT  rc.register, step + 1,
		CASE WHEN rc.register = ru.register THEN
			CASE WHEN comp_operator = '<' AND 
				      dt.val < compare_val OR 
					  comp_operator = '<=' AND 
				      dt.val <= compare_val OR 
				      comp_operator = '>' AND 
				      dt.val > compare_val OR 
				      comp_operator = '>=' AND 
				      dt.val >= compare_val OR 
				     comp_operator = '==' AND 
				     dt.val = compare_val OR 
					 comp_operator = '!=' AND 
				     dt.val != compare_val 
					THEN rc.val + trans_val ELSE rc.val END
			ELSE rc.val END 
		
		
		
		
		FROM registers_copy rc 
		JOIN reg_update ru
			ON id = step + 1
		CROSS JOIN LATERAL( SELECT val FROM registers_copy WHERE comp_register = register ) AS dt
			
	) AS dt
	
	
)

SELECT MAX(val)
FROM registers 
;
