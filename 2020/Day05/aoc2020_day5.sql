

CREATE FOREIGN TABLE aoc2020_day5 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day5.input');


CREATE TEMPORARY TABLE plane
(
	seat_num SERIAL,
	row_code TEXT,
	column_code TEXT
);


INSERT INTO plane(row_code, column_code)
VALUES
('FBFBBFF','RLR'),
('BFFFBBF','RRR'),
('FFFBBBF','RRR'),
('BBFFBBF','RLL');

CREATE TEMPORARY TABLE plane
(
	seat_num SERIAL,
	row_code TEXT,
	column_code TEXT
);


INSERT INTO plane(row_code, column_code)

SELECT SUBSTR(x,1,7), SUBSTR(x,8,3) FROM aoc2020_day5;




-- Part 1

WITH row_encoding AS 
(

	SELECT seat_num, SUM(CASE WHEN x = 'B' THEN POW(2,7-pos) ELSE 0 END) AS row_num
	FROM plane 
	CROSS JOIN STRING_TO_TABLE(row_code, NULL) WITH ORDINALITY AS t(x, pos)
    GROUP BY seat_num, row_code
 
),

column_encoding AS 
(

	SELECT seat_num, SUM(CASE WHEN x = 'R' THEN POW(2,3-pos) ELSE 0 END) AS column_num
	FROM plane 
	CROSS JOIN STRING_TO_TABLE(column_code, NULL) WITH ORDINALITY AS t(x, pos)
    GROUP BY seat_num
)



SELECT row_num * 8 + column_num AS seat_id
FROM row_encoding
NATURAL JOIN column_encoding
ORDER BY seat_id DESC
LIMIT 1
;



-- Part 2


WITH row_encoding AS 
(

	SELECT seat_num, SUM(CASE WHEN x = 'B' THEN POW(2,7-pos) ELSE 0 END) AS row_num
	FROM plane 
	CROSS JOIN STRING_TO_TABLE(row_code, NULL) WITH ORDINALITY AS t(x, pos)
    GROUP BY seat_num, row_code
 
),

column_encoding AS 
(

	SELECT seat_num, SUM(CASE WHEN x = 'R' THEN POW(2,3-pos) ELSE 0 END) AS column_num
	FROM plane 
	CROSS JOIN STRING_TO_TABLE(column_code, NULL) WITH ORDINALITY AS t(x, pos)
    GROUP BY seat_num
),


cte AS 

(
SELECT  row_num * 8 + column_num AS seat_id
FROM row_encoding
NATURAL JOIN column_encoding
WHERE row_num NOT IN (0,127)
)


SELECT seat_id FROM GENERATE_SERIES((SELECT MIN(seat_id) FROM cte)::BIGINT,(SELECT MAX(seat_id) FROM cte)::BIGINT) AS seat_id

EXCEPT 

TABLE cte
;

