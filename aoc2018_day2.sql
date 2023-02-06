
CREATE FOREIGN TABLE aoc2018_day2 (x INT)
SERVER aoc2018 options(filename 'D:\aoc2018.day2.input');




CREATE  TEMPORARY TABLE device
(
	id SERIAL,
	frequency INT
);