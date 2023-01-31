CREATE SERVER aoc2020 FOREIGN  DATA wrapper file_fdw;




CREATE FOREIGN TABLE aoc2020_day1 (x INT)
SERVER aoc2020 options(filename 'D:\aoc2020.day1.input');


CREATE  TEMPORARY TABLE accounts
(id SERIAL,
 expense INT
);




INSERT INTO accounts(expense)
SELECT * FROM aoc2020_day1;


-- Part 1


SELECT a.expense * b.expense AS answer 
FROM accounts a 
JOIN accounts b 
	ON a.id < b.id 
WHERE a.expense + b.expense = 2020;


-- Part 2

SELECT a.expense * b.expense * c.expense AS answer 
FROM accounts a 
JOIN accounts b 
	ON a.id < b.id 
JOIN accounts c 
	ON b.id < c.id 
WHERE a.expense + b.expense  + c.expense = 2020;




