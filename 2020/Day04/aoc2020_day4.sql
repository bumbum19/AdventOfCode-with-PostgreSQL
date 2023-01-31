CREATE FOREIGN TABLE aoc2020_day4 (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day4.input');



CREATE FOREIGN TABLE aoc2020_day4_test (x text)
SERVER aoc2020 options(filename 'D:\aoc2020.day4_test.input');


CREATE TEMPORARY TABLE passports
(
 id SERIAL,
 passport JSONB
);


INSERT INTO passports(passport)
WITH cte AS 

(
	SELECT x, ROW_NUMBER() OVER () AS line_number FROM aoc2020_day4

),

cte2 AS
(
	SELECT x, COUNT(*) FILTER (WHERE x = '') OVER (ORDER BY line_number) AS person FROM cte
),

cte3 AS 
(
	SELECT person, STRING_TO_TABLE(x, ' ') AS info FROM cte2 WHERE x != '' 
)

SELECT JSONB_OBJECT_AGG(SPLIT_PART(info,':',1),SPLIT_PART(info,':',2)) FROM cte3 GROUP BY person ORDER BY person;


UPDATE passports 
SET 
passport['byr'] = TO_JSONB((passport ->> 'byr')::INT),
passport['eyr'] = TO_JSONB((passport ->> 'eyr')::INT),
passport['iyr'] = TO_JSONB((passport ->> 'iyr')::INT),
passport['hgt'] = TO_JSONB(CASE WHEN  passport ->> 'hgt' LIKE '%cm%' THEN  NULLIF(LEFT(passport ->> 'hgt',-2),'')::INT
ELSE ROUND(NULLIF(LEFT(passport ->> 'hgt',-2),'')::INT*2.54,0) END )
;




-- Part 1


WITH cte AS 
(
	SELECT id, COUNT(*) AS p_size FROM passports CROSS JOIN JSONB_OBJECT_KEYS( passport - 'cid' )
	GROUP BY id
)


SELECT COUNT(*) FROM cte WHERE p_size = 7;


-- Part 2

SELECT COUNT(*)  FROM passports
WHERE passport @? '$.byr[*] ? (@ >= 1920 && @ <= 2002)'
AND  passport @? '$.iyr[*] ? (@ >= 2010 && @ <= 2020)'
AND passport @? '$.eyr[*] ? (@ >= 2020 && @ <= 2030)'
AND passport @? '$.hgt[*] ? (@ >= 150 && @ <= 193)'
AND passport @? '$.hcl[*] ? (@ like_regex "^\#([0-9]|[a-f]){6}$")'
AND passport @? '$.ecl[*] ? (@ like_regex "^amb|blu|brn|gry|grn|hzl|oth$")'
AND passport @? '$.pid[*] ? (@ like_regex "^\\d{9}$")'
;

