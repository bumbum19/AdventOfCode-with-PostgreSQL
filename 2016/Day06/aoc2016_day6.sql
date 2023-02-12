CREATE FOREIGN TABLE aoc2016_day6 (x TEXT)
SERVER aoc2016 options(filename 'D:\aoc2016.day6.input');




CREATE TEMPORARY TABLE signals
(

	id SERIAL,
	code TEXT

);


INSERT INTO signals(code)
TABLE aoc2016_day6;



-- Part 1





WITH cte AS 
(

	SELECT DISTINCT ON (pos) pos, letter, COUNT(*) AS cnt 
	FROM signals  
	CROSS JOIN STRING_TO_TABLE(code, NULL) WITH ORDINALITY AS t(letter, pos)
	GROUP BY pos, letter
	ORDER BY pos, cnt DESC, letter

)

SELECT STRING_AGG(letter,'' ORDER BY pos) FROM cte;



-- Part 2


WITH cte AS 
(

	SELECT DISTINCT ON (pos) pos, letter, COUNT(*) AS cnt 
	FROM signals  
	CROSS JOIN STRING_TO_TABLE(code, NULL) WITH ORDINALITY AS t(letter, pos)
	GROUP BY pos, letter
	ORDER BY pos, cnt , letter

)

SELECT STRING_AGG(letter,'' ORDER BY pos) FROM cte;
