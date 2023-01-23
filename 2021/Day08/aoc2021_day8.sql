
--- Day 8: Seven Segment Search ---

/*


You barely reach the safety of the cave when the whale smashes into the cave mouth, collapsing it. Sensors indicate another exit to this cave at a much greater depth, so you have no choice but to press on.

As your submarine slowly makes its way through the cave system, you notice that the four-digit seven-segment displays in your submarine are malfunctioning; they must have been damaged during the escape. You'll be in a lot of trouble without them, so you'd better figure out what's wrong.

Each digit of a seven-segment display is rendered by turning on or off any of seven segments named a through g:

  0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg

So, to render a 1, only segments c and f would be turned on; the rest would be off. To render a 7, only segments a, c, and f would be turned on.

The problem is that the signals which control the segments have been mixed up on each display. The submarine is still trying to display numbers by producing
output on signal wires a through g, but those wires are connected to segments randomly. Worse, the wire/segment connections are mixed up separately for each four-digit display! (All of the digits within a display use the same connections, though.)

So, you might know that only signal wires b and g are turned on, but that doesn't mean segments b and g are turned on: the only digit that uses two segments 
is 1, so it must mean segments c and f are meant to be on. With just that information, you still can't tell which wire (b/g) goes to which segment (c/f). 
For that, you'll need to collect more information.

For each display, you watch the changing signals for a while, make a note of all ten unique signal patterns you see, and then write down a single four 
digit output value (your puzzle input). Using the signal patterns, you should be able to work out which pattern corresponds to which digit.

For example, here is what you might see in a single entry in your notes:

acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf

(The entry is wrapped here to two lines so it fits; in your notes, it will all be on a single line.)

Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value. Within an entry, the same wire/segment 
connections are used (but you don't know what the connections actually are). The unique signal patterns correspond to the ten different ways the submarine tries
to render a digit using the current wire/segment connections. Because 7 is the only digit that uses three segments, dab in the above example means that to render 
a 7, signal lines d, a, and b are on. Because 4 is the only digit that uses four segments, eafb means that to render a 4, signal lines e, a, f, and b are on.

Using this information, you should be able to work out which combination of signal wires corresponds to each of the ten digits. Then, you can decode the 
four digit output value. Unfortunately, in the above example, all of the digits in the output value (cdfeb fcadb cdfeb cdbaf) use five segments and 
are more difficult to deduce.

For now, focus on the easy digits. Consider this larger example:

be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec |
fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef |
cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega |
efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga |
gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf |
gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf |
cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd |
ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg |
gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc |
fgae cfgab fg bagce

Because the digits 1, 4, 7, and 8 each use a unique number of segments, you should be able to tell which combinations of signals correspond to those digits. Counting only digits in the output values (the part after | on each line), in the above example, there are 26 instances of digits that use a unique number of segments (highlighted above).

In the output values, how many times do digits 1, 4, 7, or 8 appear?


*/


CREATE FOREIGN TABLE aoc2021_day8 (a text)
 SERVER aoc2022 options(filename 'D:\aoc2021.day8.input');
  
  
CREATE TEMPORARY TABLE  digits  (
id  SERIAL,
d1  text,
d2  text,
d3  text,
d4  text
);

INSERT INTO digits(d1,d2,d3,d4)
SELECT 
SPLIT_PART(REPLACE(a,' | ', ' '),' ',11),
SPLIT_PART(REPLACE(a,' | ', ' '),' ',12),
SPLIT_PART(REPLACE(a,' | ', ' '),' ',13),
SPLIT_PART(REPLACE(a,' | ', ' '),' ',14) 
FROM aoc2021_day8;



-- Solution

SELECT 
COUNT(*) FILTER (WHERE LENGTH(d1) IN (2,3,4,7)) +
COUNT(*) FILTER (WHERE LENGTH(d2) IN (2,3,4,7)) +
COUNT(*) FILTER (WHERE LENGTH(d3) IN (2,3,4,7)) +
COUNT(*) FILTER (WHERE LENGTH(d4) IN (2,3,4,7))  AS answer
FROM digits
;


--- Part Two ---

/*

Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:

acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf

After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:

 dddd
e    a
e    a
 ffff
g    b
g    b
 cccc

So, the unique signal patterns would correspond to the following digits:

   - acedgfb: 8
   - cdfbe: 5
   - gcdfa: 2
   - fbcad: 3
   - dab: 7
   - cefabd: 9
   - cdfgeb: 6
   - eafb: 4
   - cagedb: 0
   - ab: 1

Then, the four digits of the output value can be decoded:

   - cdfeb: 5
   - fcadb: 3
   - cdfeb: 5
   - cdbaf: 3

Therefore, the output value for this entry is 5353.

Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:

   - fdgacbe cefdb cefbgd gcbe: 8394
   - fcgedb cgb dgebacf gc: 9781
   - cg cg fdcagb cbg: 1197
   - efabcd cedba gadfec cb: 9361
   - gecf egdcabf bgf bfgea: 4873
   - gebdcfa ecba ca fadegcb: 8418
   - cefg dcbef fcge gbcadfe: 4548
   - ed bcgafe cdgba cbgef: 1625
   - gbdfcae bgc cg cgb: 8717
    -fgae cfgab fg bagce: 4315

Adding all of the output values in this larger example produces 61229.

For each entry, determine all of the wire/segment connections and decode the four-digit output values. What do you get if you add up all of the output values?
*/

CREATE TEMPORARY TABLE  digits2  (
  id  SERIAL,
  d0  text,
  d1  text,
  d2  text,
  d3  text,
  d4  text,
  d5  text,
  d6  text,
  d7  text,
  d8  text,
  d9  text
);

INSERT INTO digits2(d0,d1,d2,d3,d4,d5,d6,d7,d8,d9)
SELECT 
SPLIT_PART(a,' ',1),
SPLIT_PART(a,' ',2),
SPLIT_PART(a,' ',3),
SPLIT_PART(a,' ',4),
SPLIT_PART(a,' ',5),
SPLIT_PART(a,' ',6),
SPLIT_PART(a,' ',7),
SPLIT_PART(a,' ',8),
SPLIT_PART(a,' ',9),
SPLIT_PART(a,' ',10)
FROM aoc2021_day8;


-- Solution


WITH t AS 

(SELECT id, TO_JSONB(ARRAY[d0,d1,d2,d3,d4,d5,d6,d7,d8,d9]) AS c FROM digits2),


t2 AS 
(
SELECT  id,
to_jsonb(string_to_array(jsonb_array_elements_text(jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{2}$") ')),NULL)) AS d1,
to_jsonb(string_to_array(jsonb_array_elements_text(jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{4}$") ')),NULL)) AS d4,
to_jsonb(string_to_array(jsonb_array_elements_text(jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{3}$") ')),NULL)) AS d7,
to_jsonb(string_to_array(jsonb_array_elements_text(jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{7}$") ')),NULL)) AS d8
FROM t
),


t3 AS 
(
SELECT  id,
to_jsonb(string_to_array(jsonb_array_elements_text(
         jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{5}$") ')),NULL)) 
AS d235

FROM t),

t4 AS 
(
SELECT  id,
to_jsonb(string_to_array(jsonb_array_elements_text(
         jsonb_path_query_array(c::jsonb, '$[*] ? (@ like_regex "^[a-g]{6}$") ')),NULL)) 
AS d069

FROM t),

t5 AS 

(SELECT id, d235 AS d3, d069 AS d6  
 FROM t2 
 JOIN t3
   USING (id) 
 JOIN t4 
   USING (id)
 WHERE  d1 <@ d235 AND NOT d1 <@  d069 
) 
,

t6 AS 

(SELECT id, d069 AS d9  
 FROM t4 JOIN t5 USING (id) WHERE  d3 <@  d069 ),


t7 AS 

(SELECT id, d235 AS d5  
 FROM t3 
 JOIN t5 
   USING (id)
 WHERE  d235 <@  d6 ),

final AS 
(
SELECT id,  UNNEST(ARRAY[0,1,2,3,4,5,6,7,8,9]) AS digit, UNNEST(ARRAY[d069,d1,d235,d3,d4,d5,d6,d7,d8,d9]) AS encoding
FROM t2 
JOIN t3 
  USING (id) 
JOIN t4 
  USING (id) 
JOIN t5 
   USING (id) 
JOIN t6 
   USING (id) 
JOIN t7 
   USING (id) 
WHERE d069 NOT IN (d6,d9) AND d235 NOT IN (d3,d5) 
) ,

s AS
(
SELECT id, UNNEST(ARRAY[3,2,1,0]) AS pos, TO_JSONB(STRING_TO_ARRAY(UNNEST(ARRAY[d1,d2,d3,d4]), NULL)) AS encoding FROM digits
)

SELECT 
SUM(digit * POWER(10,pos)) AS answer 
FROM final JOIN s USING(id) 
WHERE final.encoding <@ s.encoding 
AND s.encoding <@ final.encoding ;

