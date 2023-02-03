CREATE SERVER aoc2020 FOREIGN  DATA wrapper file_fdw;




CREATE FOREIGN TABLE aoc2020_day1 (x INT)
SERVER aoc2020 options(filename 'D:\aoc2020.day1.input');
