CREATE FOREIGN TABLE aoc2017_day11 (x TEXT)
SERVER aoc2017 options(filename 'D:\aoc2017.day11.input');



CREATE TEMPORARY TABLE hex_grid
(
	id SERIAL,
	move TEXT
	
);

INSERT INTO hex_grid(move)
SELECT STRING_TO_TABLE(x, ',') FROM aoc2017_day11;


----------------------------------------------


CREATE TEMPORARY TABLE hex_grid
(
	id SERIAL,
	move TEXT
	
);

INSERT INTO hex_grid(move)
VALUES
('se'),
('sw'),
('se'),
('sw'),
('sw');

---------------------
CREATE TEMPORARY TABLE hex_grid
(
	id SERIAL,
	move TEXT
	
);

INSERT INTO hex_grid(move)
VALUES
('ne'),
('ne'),
('s'),
('s');











-- Part 1


WITH cte AS 
(
	SELECT 
	COUNT(*) FILTER (WHERE move = 's') AS s,
	COUNT(*) FILTER (WHERE move = 'n') AS n,
	COUNT(*) FILTER (WHERE move = 'ne') AS ne,
	COUNT(*) FILTER (WHERE move = 'sw') AS sw,
	COUNT(*) FILTER (WHERE move = 'nw') AS nw,
	COUNT(*) FILTER (WHERE move = 'se') AS se
	FROM hex_grid

)


SELECT 
CASE WHEN n > s THEN 
		CASE WHEN ne > sw THEN
			CASE WHEN nw > se THEN
				(n - s) + (ne - sw) + (nw - se) - LEAST(ne - sw, nw - se)
				ELSE 
				(ne - sw) + (n - s) + (se - nw) - LEAST(n - s, se - nw)
			END
			ELSE 
			CASE WHEN nw > se THEN
				(nw - se) + (sw - ne) + (n - s) - LEAST(sw - ne, n - s)
				ELSE 
				ABS(n - (s + (sw - ne)+ (se - nw))) 
			 END
			 END
	ELSE
		CASE WHEN ne > sw THEN
			CASE WHEN nw > se THEN
				ABS(s - (n + (nw - se)+ (ne - sw)))
				ELSE 
				(se - nw) + (s - n) + (ne - sw) - LEAST(s - n, ne - sw)
			END
			ELSE 
			CASE WHEN nw > se THEN
				(sw - ne) + (nw - se) + (s - n) - LEAST(nw - se, s - n)
				ELSE 
				(sw - ne) + (se - nw) + (s - n) - LEAST(sw - ne, se - nw)
			 END
			 END
	END 
			
			



FROM cte;





-- Part 2


WITH cte AS 
(
	SELECT 
	COUNT(*) FILTER (WHERE move = 's') OVER w AS s,
	COUNT(*) FILTER (WHERE move = 'n') OVER w AS n,
	COUNT(*) FILTER (WHERE move = 'ne') OVER w AS ne,
	COUNT(*) FILTER (WHERE move = 'sw') OVER w AS sw,
	COUNT(*) FILTER (WHERE move = 'nw') OVER w AS nw,
	COUNT(*) FILTER (WHERE move = 'se') OVER w AS se
	FROM hex_grid
	WINDOW w AS (ORDER BY id)

)


SELECT MAX(steps)
FROM cte 
CROSS JOIN LATERAL (VALUES(
CASE WHEN n > s THEN 
		CASE WHEN ne > sw THEN
			CASE WHEN nw > se THEN
				(n - s) + (ne - sw) + (nw - se) - LEAST(ne - sw, nw - se)
				ELSE 
				(ne - sw) + (n - s) + (se - nw) - LEAST(n - s, se - nw)
			END
			ELSE 
			CASE WHEN nw > se THEN
				(nw - se) + (sw - ne) + (n - s) - LEAST(sw - ne, n - s)
				ELSE 
				ABS(n - (s + (sw - ne)+ (se - nw))) 
			 END
			 END
	ELSE
		CASE WHEN ne > sw THEN
			CASE WHEN nw > se THEN
				ABS(s - (n + (nw - se)+ (ne - sw)))
				ELSE 
				(se - nw) + (s - n) + (ne - sw) - LEAST(s - n, ne - sw)
			END
			ELSE 
			CASE WHEN nw > se THEN
				(sw - ne) + (nw - se) + (s - n) - LEAST(nw - se, s - n)
				ELSE 
				(sw - ne) + (se - nw) + (s - n) - LEAST(sw - ne, se - nw)
			 END
			 END
	END 
)) AS t(steps);

		
		
