--- Day 6: Tuning Trouble ---

/*

The preparations are finally complete; you and the Elves leave camp on foot and begin to make your way toward the star fruit grove.

As you move through the dense undergrowth, one of the Elves gives you a handheld device. He says that it has many fancy features, 
but the most important one to set up right now is the communication system.

However, because he's heard you have significant experience dealing with signal-based systems, 
he convinced the other Elves that it would be okay to give you their one malfunctioning device - surely you'll have no problem fixing it.

As if inspired by comedic timing, the device emits a few colorful sparks.

To be able to communicate with the Elves, the device needs to lock on to their signal. The signal is a series of seemingly-random characters 
that the device receives one at a time.

To fix the communication system, you need to add a subroutine to the device that detects a start-of-packet marker in the datastream. 
In the protocol being used by the Elves, the start of a packet is indicated by a sequence of four characters that are all different.

The device will send your subroutine a datastream buffer (your puzzle input); your subroutine needs to identify the first position where 
the four most recently received characters were all different. Specifically, it needs to report the number of characters from the beginning of 
the buffer to the end of the first such four-character marker.

For example, suppose you receive the following datastream buffer:

mjqjpqmgbljsphdztnvjfqwrcgsmlb

After the first three characters (mjq) have been received, there haven't been enough characters received yet to find the marker. 
The first time a marker could occur is after the fourth character is received, making the most recent four characters mjqj. Because j is repeated, this isn't a marker.

The first time a marker appears is after the seventh character arrives. Once it does, the last four characters received are jpqm, which are all different.
In this case, your subroutine should report the value 7, because the first start-of-packet marker is complete after 7 characters have been processed.

Here are a few more examples:

   - bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 5
   - nppdvjthqldpwncqszvftbrmjlhg: first marker after character 6
   - nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 10
   - zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 11

How many characters need to be processed before the first start-of-packet marker is detected?


*/




CREATE FOREIGN TABLE aoc2022_day6 (x text)
SERVER aoc2022 options(filename 'D:\aoc2022.day6.input');


CREATE TEMPORARY TABLE  marker (
buffer text
 );
 
 INSERT INTO marker 
 SELECT *
 FROM 
 aoc2022_day6;


WITH cte AS 
(
	SELECT n, lit, LAG(lit,1) OVER w AS lag1, LAG(lit,2) OVER w AS lag2, LAG(lit,3) OVER w AS lag3 
	FROM marker CROSS JOIN  STRING_TO_TABLE(buffer, NULL) WITH ORDINALITY AS t(lit,n) 
	WINDOW w AS (ORDER BY n)
)

SELECT MIN(n) FROM cte WHERE lit != lag1 AND lit != lag2 AND lit != lag3 AND 
lag1 != lag2 AND lag1 != lag3 AND lag2 != lag3;





--- Part Two ---

/*

Your device's communication system is correctly detecting packets, but still isn't working. It looks like it also needs to look for messages.

A start-of-message marker is just like a start-of-packet marker, except it consists of 14 distinct characters rather than 4.

Here are the first positions of start-of-message markers for all of the above examples:

   - mjqjpqmgbljsphdztnvjfqwrcgsmlb: first marker after character 19
   - bvwbjplbgvbhsrlpgdmjqwftvncz: first marker after character 23
   - nppdvjthqldpwncqszvftbrmjlhg: first marker after character 23
   - nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: first marker after character 29
   - zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: first marker after character 26

How many characters need to be processed before the first start-of-message marker is detected?


*/


WITH RECURSIVE cte AS
(

	SELECT   n, lit, STRING_AGG(lit,'') OVER (ORDER BY n RANGE BETWEEN 13 PRECEDING AND CURRENT ROW) AS x
	FROM marker CROSS JOIN  STRING_TO_TABLE(buffer, NULL) WITH ORDINALITY AS t(lit,n) OFFSET 13
),

literals (id, lit) AS
(
	SELECT 97 , CHR(97)
	UNION ALL
	SELECT id+1, CHR(id+1) FROM literals
    	WHERE id < 122
)


SELECT n AS answer FROM cte JOIN literals l ON STRPOS(x,l.lit) > 0
GROUP BY n HAVING COUNT(*) = 14 ORDER BY n LIMIT 1; 






