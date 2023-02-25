--- Day 8: I Heard You Like Registers ---


/*

ou receive a signal directly from the CPU. Because of your recent assistance with jump instructions, it would like you to compute the result of a series of 
unusual register instructions.

Each instruction consists of several parts: the register to modify, whether to increase or decrease that register's value, the amount by which to increase or decrease it,
and a condition. If the condition fails, skip the instruction without modifying the register. The registers all start at 0. The instructions look like this:

b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10

These instructions would be processed as follows:

   - Because a starts at 0, it is not greater than 1, and so b is not modified.
   - a is increased by 1 (to 1) because b is less than 5 (it is 0).
   - c is decreased by -10 (to 10) because a is now greater than or equal to 1 (it is 1).
   - c is increased by -20 (to -10) because c is equal to 10.

After this process, the largest value in any register is 1.

You might also encounter <= (less than or equal to) or != (not equal to). However, the CPU doesn't have the bandwidth to tell you what all the registers are named, 
and leaves that to you to determine.

What is the largest value in any register after completing the instructions in your puzzle input?

*/


-- Read data

CREATE FOREIGN TABLE aoc2017_day8 (x TEXT)
SERVER aoc2017 options(filename 'D:\aoc2017.day8.input');


-- Create base table


CREATE TEMPORARY TABLE reg_update 
(
	id SERIAL ,
	register TEXT,
	trans_val INT,
	comp_register TEXT,
	comp_operator TEXT,
	compare_val INT	
);


-- Insert data

INSERT INTO reg_update(register, trans_val, comp_register, comp_operator, compare_val)
SELECT 
SPLIT_PART(x, ' ', 1),
CASE WHEN SPLIT_PART(x, ' ', 2)  = 'dec' THEN -1 * SPLIT_PART(x, ' ', 3)::INT
ELSE SPLIT_PART(x, ' ', 3)::INT END,
SPLIT_PART(x, ' ', 5),
SPLIT_PART(x, ' ', 6),
SPLIT_PART(x, ' ', 7)::INT
FROM aoc2017_day8;


-- First Star

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



--- Part Two ---

/*

To be safe, the CPU also needs to know the highest value held in any register during this process so that it can decide how much memory to allocate to these operations. 
For example, in the above instructions, the highest value ever held was 10 (in register c after the third instruction was evaluated).

*/



--Second Star

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
FROM registers;
