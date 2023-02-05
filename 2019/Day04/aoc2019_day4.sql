





CREATE FOREIGN TABLE aoc2019_day4 (x text)
SERVER aoc2019 options(filename 'D:\aoc2019.day4.input');

CREATE TEMPORARY TABLE password_range
 (
    lower_bound INT,
    upper_bound  INT
;


INSERT INTO password_range
SELECT SPLIT_PART(a,'-',1)::INT, SPLIT_PART(a,'-',2)::INT  FROM aoc2019_day4;



-- Part 1

 WITH cte AS

(

     SELECT x0*POW(10,0) + x1*POW(10,1) +  x2*POW(10,2) + x3*POW(10,3) + x4*POW(10,4) + x5*POW(10,5) AS num
     FROM GENERATE_SERIES(0,9) AS x0
     CROSS JOIN GENERATE_SERIES(0,9) AS x1
     CROSS JOIN GENERATE_SERIES(0,9) AS x2
      CROSS JOIN GENERATE_SERIES(0,9) AS x3
     CROSS JOIN GENERATE_SERIES(0,9) AS x4
     CROSS JOIN GENERATE_SERIES(0,9) AS x5
      WHERE x0 >= x1 AND x1 >= x2 AND x2 >= x3 AND x3 >= x4 AND x4 >= x5
      AND ( x0 = x1 OR x1 = x2 OR x2 = x3 OR x3 = x4 OR x4 = x5 )
 )



SELECT COUNT(*) FROM cte JOIN password_range ON num >= lower_bound AND num <= upper_bound;


-- Part 2

 
WITH cte AS

(

     SELECT x0*POW(10,0) + x1*POW(10,1) +  x2*POW(10,2) + x3*POW(10,3) + x4*POW(10,4) + x5*POW(10,5) AS num
     FROM GENERATE_SERIES(0,9) AS x0
     CROSS JOIN GENERATE_SERIES(0,9) AS x1
     CROSS JOIN GENERATE_SERIES(0,9) AS x2
      CROSS JOIN GENERATE_SERIES(0,9) AS x3
     CROSS JOIN GENERATE_SERIES(0,9) AS x4
     CROSS JOIN GENERATE_SERIES(0,9) AS x5
      WHERE x0 >= x1 AND x1 >= x2 AND x2 >= x3 AND x3 >= x4 AND x4 >= x5
      AND ( (x0 = x1 AND  x1 != x2              ) OR
            (x1 = x2 AND  x0 != x1 AND x2 != x3 ) OR
            (x2 = x3 AND  x1 != x2 AND x3 != x4 ) OR
            (x3 = x4 AND  x2 != x3 AND x4 != x5 ) OR
            (x4 = x5 AND  x3 != x4              )

          )
 )



SELECT COUNT(*) FROM cte JOIN password_range ON num >= lower_bound AND num <= upper_bound;
