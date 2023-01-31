CREATE FOREIGN TABLE aoc2020_day3 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day3.input');



CREATE TEMPORARY TABLE grid
(id SERIAL,
 pattern CHAR[]
);

INSERT INTO grid(pattern)
SELECT STRING_TO_ARRAY(x,NULL) 
FROM aoc2020_day3;

--------------------------------------------


CREATE TEMPORARY TABLE grid
(id SERIAL,
 pattern CHAR[]
);


INSERT INTO grid(pattern)
VALUES
(STRING_TO_ARRAY('..##.......',NULL)),
(STRING_TO_ARRAY('#...#...#..',NULL)),
(STRING_TO_ARRAY('.#....#..#.',NULL)),
(STRING_TO_ARRAY('..#.#...#.#',NULL)),
(STRING_TO_ARRAY('.#...##..#.',NULL)),
(STRING_TO_ARRAY('..#.##.....',NULL)),
(STRING_TO_ARRAY('.#.#.#....#',NULL)),
(STRING_TO_ARRAY('.#........#',NULL)),
(STRING_TO_ARRAY('#.##...#...',NULL)),
(STRING_TO_ARRAY('#...##....#',NULL)),
(STRING_TO_ARRAY('.#..#...#.#',NULL));




-- Part 1


WITH dim AS

(

	SELECT CARDINALITY(pattern) FROM grid LIMIT 1

)


SELECT SUM(CASE WHEN pattern[MOD(3*(id-1),(TABLE dim)) + 1] = '#' THEN 1 ELSE 0 END) FROM grid ;



-- Part 2

WITH dim AS

(

	SELECT CARDINALITY(pattern) FROM grid LIMIT 1

),

cte AS 
(

	SELECT x, 
	SUM(CASE WHEN pattern[MOD(x*(id-1),(TABLE dim)) + 1] = '#' THEN 1 ELSE 0 END) AS  slope_one,
	COALESCE(SUM(CASE WHEN pattern[MOD(id/2,(TABLE dim)) + 1] = '#' THEN 1 ELSE 0 END) FILTER (WHERE MOD(id,2) = 1 AND x = 1),1 ) AS slope_two
	FROM grid CROSS JOIN GENERATE_SERIES(1,7,2) AS x GROUP BY x 
)


--SELECT PRODUCT(slope_one*slope_two) FROM cte;


SELECT ROUND(EXP(SUM(LN(slope_one*slope_two)))::NUMERIC,0) FROM cte;





CREATE FUNCTION MULTIPLY(BIGINT, BIGINT) RETURNS BIGINT
    AS 'select $1 * $2;'
    LANGUAGE SQL
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;
	
	
	
CREATE AGGREGATE PRODUCT (BIGINT)
(
    sfunc = MULTIPLY,
    stype = BIGINT,
    initcond = '1'
);



