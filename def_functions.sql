
-- Define product aggregate function (not optimized for windows usage)




CREATE OR REPLACE FUNCTION  MULTIPLY(BIGINT, BIGINT) RETURNS BIGINT
    AS 'select $1 * $2;'
    LANGUAGE SQL
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;
	
	
CREATE OR REPLACE AGGREGATE PRODUCT  EXISTS (BIGINT)
(
    sfunc = MULTIPLY,
    stype = BIGINT,
    initcond = '1'
);
