SET lc_messages TO 'en_US.UTF-8';



CREATE SERVER aoc2018 FOREIGN  DATA wrapper file_fdw;




CREATE FOREIGN TABLE aoc2018_day1 (x INT)
SERVER aoc2018 options(filename 'D:\aoc2018.day1.input');




CREATE  TEMPORARY TABLE device
(
	id SERIAL,
	frequency INT
);


INSERT INTO device(frequency)
SELECT * FROM aoc2018_day1;



------------------------------------------------


CREATE  TEMPORARY TABLE device
(
	id SERIAL,
	frequency INT
);


INSERT INTO device(frequency)
 VALUES
(7),
(7),
(-2),
(-7),
(-4);

INSERT INTO device(frequency)
 VALUES
(1),
(-1);



-- Part 1

SELECT SUM(frequency) FROM device;


-- Part 2





WITH RECURSIVE total_sum AS 

(
		SELECT SUM(frequency) FROM device
), 


series AS 
(	
	
	SELECT id, SUM(frequency) OVER (ORDER BY id) AS partial_sum FROM device
) 



SELECT  CASE WHEN (TABLE total_sum) = 0 THEN COALESCE(b.partial_sum,0) ELSE  b.partial_sum END  AS answer
FROM series a 
LEFT JOIN series b 
	ON a.id != b.id AND b.partial_sum >= a.partial_sum AND
		CASE WHEN (TABLE total_sum) = 0 THEN b.partial_sum - a.partial_sum = 0	
			ELSE MOD(b.partial_sum - a.partial_sum, (TABLE total_sum)) = 0 END
ORDER BY b.partial_sum - a.partial_sum, a.id LIMIT 1;



