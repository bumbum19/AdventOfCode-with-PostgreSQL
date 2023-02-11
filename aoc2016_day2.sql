
CREATE FOREIGN TABLE aoc2016_day2 (x TEXT)
SERVER aoc2016 options(filename 'D:\aoc2016.day2.input');




CREATE  TEMPORARY TABLE instructions
(
	id SERIAL,
	instruction TEXT
	
);


INSERT INTO instructions(instruction)
SELECT * FROM aoc2016_day2;


-----------------------

CREATE  TEMPORARY TABLE instructions
(
	id SERIAL,
	instruction TEXT
	
);


INSERT INTO instructions(instruction)
VALUES 
('ULL'),
('RRDDD'),
('LURDL'),
('UUUUD');


-- Part 1


WITH RECURSIVE mapping(digit, vector) AS 
(
	VALUES 
	('1', POINT(-1,1)),
	('2', POINT(0,1)),
	('3', POINT(1,1)),
	('4', POINT(-1,0)),
	('5', POINT(0,0)),
	('6', POINT(1,0)),
	('7', POINT(-1,-1)),
	('8', POINT(0,-1)),
	('9', POINT(1,-1))

),

moves AS 
(
	SELECT id, move, ROW_NUMBER() OVER () AS pos, 
	CASE WHEN move = 'R' THEN 1 WHEN move = 'L' THEN -1 ELSE 0 END AS x,
	CASE WHEN move = 'U' THEN 1 WHEN move = 'D' THEN -1 ELSE 0 END AS y
    FROM instructions CROSS JOIN STRING_TO_TABLE(instruction,NULL)  AS move
),

walk(id, pos, x, y) AS 
(	

	SELECT id, pos, x, y FROM moves WHERE pos = 1
	UNION ALL
	SELECT m.id, m.pos, 
	CASE WHEN m.x + w.x > 1 THEN 1 WHEN m.x + w.x < -1 THEN -1 ELSE m.x + w.x END,
	CASE WHEN m.y + w.y > 1 THEN 1 WHEN m.y + w.y < -1 THEN -1 ELSE m.y + w.y END
	FROM moves m  JOIN walk w ON m.pos = w.pos + 1
),

cte AS 
(

	SELECT DISTINCT ON (id) id, pos, x, y FROM walk 
	ORDER BY id, pos DESC
)


SELECT STRING_AGG(digit, '' ORDER BY id) FROM cte 
JOIN mapping ON POINT(x,y) ~= vector;




-- Part 2





WITH RECURSIVE mapping(digit, vector) AS 
(
	VALUES 
	('2', POINT(-1,1)),
	('3', POINT(0,1)),
	('4', POINT(1,1)),
	('6', POINT(-1,0)),
	('7', POINT(0,0)),
	('8', POINT(1,0)),
	('A', POINT(-1,-1)),
	('B', POINT(0,-1)),
	('C', POINT(1,-1)),
	('9', POINT(2,0)),
	('5', POINT(-2,0)),
	('1', POINT(0,2)),
	('D', POINT(0,-2))

),

moves AS 
(
	SELECT id, move, ROW_NUMBER() OVER () AS pos, 
	CASE WHEN move = 'R' THEN 1 WHEN move = 'L' THEN -1 ELSE 0 END AS x,
	CASE WHEN move = 'U' THEN 1 WHEN move = 'D' THEN -1 ELSE 0 END AS y
    FROM instructions CROSS JOIN STRING_TO_TABLE(instruction,NULL)  AS move
),

walk(id, pos, x, y) AS 
(	

	SELECT 1, 0::BIGINT, -2, 0 
	UNION ALL
	SELECT m.id, m.pos, 
	CASE WHEN ROW(m.x + w.x, m.y + w.y) IN (SELECT vector[0], vector[1] FROM mapping) THEN m.x + w.x ELSE w.x END,
	CASE WHEN ROW(m.x + w.x, m.y + w.y) IN (SELECT vector[0], vector[1] FROM mapping) THEN m.y + w.y ELSE w.y END
	FROM moves m  JOIN walk w ON m.pos = w.pos + 1
),

cte AS 
(

	SELECT DISTINCT ON (id) id, pos, x, y FROM walk 
	ORDER BY id, pos DESC
)



SELECT STRING_AGG(digit, '' ORDER BY id) FROM cte 
JOIN mapping ON POINT(x,y) ~= vector;



('ULL'),
('RRDDD'),
('LURDL'),
('UUUUD');



 id | pos | x  | y
----+-----+----+----
  1 |   0 | -2 |  0
  1 |   1 | -2 |  1
  1 |   2 | -2 |  1
  1 |   3 | -2 |  1
  2 |   4 | -1 |  1
  2 |   5 |  0 |  1
  2 |   6 |  0 |  0
  2 |   7 |  0 | -1
  2 |   8 |  0 | -2
  3 |   9 | -1 | -2
  3 |  10 | -1 | -1
  3 |  11 |  0 | -1
  3 |  12 |  0 | -2
  3 |  13 | -1 | -2
  4 |  14 | -1 | -1
  4 |  15 | -1 |  0
  4 |  16 | -1 |  1
  4 |  17 | -1 |  1
  4 |  18 | -1 |  0
(19 Zeilen)









