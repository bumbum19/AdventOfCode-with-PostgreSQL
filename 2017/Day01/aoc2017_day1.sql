SET lc_messages TO 'en_US.UTF-8';



CREATE SERVER aoc2017 FOREIGN  DATA wrapper file_fdw;




CREATE FOREIGN TABLE aoc2017_day1 (x text)
SERVER aoc2017 options(filename 'D:\aoc2017.day1.input');


CREATE  TEMPORARY TABLE captcha
(
	pos SERIAL,
	digit INT
);


INSERT INTO captcha(digit)
SELECT STRING_TO_TABLE(x,NULL)::INT FROM aoc2017_day1;


-------------------------------

CREATE  TEMPORARY TABLE captcha
(
	pos SERIAL,
	digit INT
);

INSERT INTO captcha(digit)
VALUES 
(1),
(1),
(1),
(1);



-- Part 1


WITH first_digit AS 

(  
	SELECT digit FROM captcha WHERE pos = 1


),

cte AS 
(
	SELECT digit, 
	COALESCE(LEAD(digit) OVER (ORDER BY pos), (TABLE first_digit ) ) AS next_digit
	FROM captcha
)


SELECT SUM(digit) FROM cte WHERE digit = next_digit;



-- Part 2



WITH n_rows AS 

(  
	SELECT COUNT(*) FROM captcha 

),

cte AS 
(
	SELECT digit, 
	COALESCE(LEAD(digit,((TABLE n_rows)/ 2)::INT) OVER w, 
			 LAG(digit, ((TABLE n_rows)/ 2)::INT) OVER w) AS next_digit
	FROM captcha
	WINDOW w AS (ORDER BY pos)

)


SELECT SUM(digit) FROM cte WHERE digit = next_digit;
