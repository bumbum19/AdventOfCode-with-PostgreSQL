

CREATE FOREIGN TABLE aoc2022_day2 (x text)
SERVER aoc2022 options(filename 'D:\aoc2022.day2.input');




CREATE TEMPORARY TABLE  game (
  round  SERIAL ,
  you TEXT,
  me TEXT
  );
  
INSERT INTO game(you, me)
SELECT
SPLIT_PART(x,' ',1),
SPLIT_PART(x,' ',2)
FROM aoc2022_day2;




-- Part 1

SELECT SUM(CASE WHEN you = 'A' THEN
				CASE  WHEN me = 'X' THEN 4 
					 WHEN me = 'Y' THEN  8
					 ELSE 3 END 
				WHEN you = 'B' THEN
				CASE  WHEN me = 'X' THEN 1 
					 WHEN me = 'Y' THEN  5
					 ELSE 9 END
			   ELSE   
			   CASE  WHEN me = 'X' THEN 7 
					 WHEN me = 'Y' THEN  2
					 ELSE 6 END
			   END )
			   
FROM game;


-- Part 2


SELECT SUM(CASE WHEN you = 'A' THEN
				CASE  WHEN me = 'X' THEN 3 
					 WHEN me = 'Y' THEN  4
					 ELSE 8 END 
				WHEN you = 'B' THEN
				CASE  WHEN me = 'X' THEN 1 
					 WHEN me = 'Y' THEN  5
					 ELSE 9 END
			   ELSE   
			   CASE  WHEN me = 'X' THEN 2 
					 WHEN me = 'Y' THEN  6
					 ELSE 7 END
			   END )
			   
FROM game;

			       
			   
					 
		 




