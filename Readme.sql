-- First Copy the files Import1.csv and Import2.csv 
-- Import1.csv have the information of the states , cities , and location. 
-- Import2.csv have the information of the states.

-- Second Create the 2 tables and add the two columns

CREATE TABLE LOCATION (
    ID DECIMAL(18,0),
    COUNTRY  VARCHAR(4) UTF8,
    ZIPCODE  DECIMAL(10,0),
    CITY   VARCHAR(100) UTF8,
    LOC_STATE   VARCHAR(100) UTF8,
    ZIP   VARCHAR(4) UTF8,
	LOC_X DECIMAL(10,5),
	LOC_Y DECIMAL(10,5)
);

CREATE TABLE STATES (
    ID        DECIMAL(18,0),
    LOC_STATE VARCHAR(100) UTF8
);


ALTER TABLE AOL_SCHEMA.QUERYDIM ADD COLUMN STATE_ID DECIMAL(18,0);

ALTER TABLE AOL_SCHEMA.ANONIDDIM ADD COLUMN STATE_ID DECIMAL(18,0);


-- then import the 2 files. Remember to change the location of the file



IMPORT INTO AOL_SCHEMA.LOCATION FROM LOCAL CSV FILE '/Users/epanza/Documents/Beuth/BI/ED_TASK1/Import1.csv' 
ENCODING = 'UTF-8' 
ROW SEPARATOR = 'CRLF' 
COLUMN SEPARATOR = ',' 
COLUMN DELIMITER = '"' 
SKIP = 0 
REJECT LIMIT 0;


IMPORT INTO AOL_SCHEMA.STATES FROM LOCAL CSV FILE '/Users/epanza/Documents/Beuth/BI/ED_TASK1/Import2.csv' 
ENCODING = 'UTF-8' 
ROW SEPARATOR = 'CRLF' 
COLUMN SEPARATOR = ',' 
COLUMN DELIMITER = '"' 
SKIP = 0 
REJECT LIMIT 0;

-- then update the table QUERYDIM

update QUERYDIM set STATE_ID =1 where QUERY like '%alabama%';
update QUERYDIM set STATE_ID =2 where QUERY like '%alaska%';
update QUERYDIM set STATE_ID =3 where QUERY like '%arizona%';
update QUERYDIM set STATE_ID =4 where QUERY like '%arkansas%';
update QUERYDIM set STATE_ID =5 where QUERY like '%california%';
update QUERYDIM set STATE_ID =6 where QUERY like '%colorado%';
update QUERYDIM set STATE_ID =7 where QUERY like '%connecticut%';
update QUERYDIM set STATE_ID =8 where QUERY like '%delaware%';
update QUERYDIM set STATE_ID =9 where QUERY like '%district of columbia%';
update QUERYDIM set STATE_ID =10 where QUERY like '%florida%';
update QUERYDIM set STATE_ID =11 where QUERY like '%georgia%';
update QUERYDIM set STATE_ID =12 where QUERY like '%hawaii%';
update QUERYDIM set STATE_ID =13 where QUERY like '%idaho%';
update QUERYDIM set STATE_ID =14 where QUERY like '%illinois%';
update QUERYDIM set STATE_ID =15 where QUERY like '%indiana%';
update QUERYDIM set STATE_ID =16 where QUERY like '%iowa%';
update QUERYDIM set STATE_ID =17 where QUERY like '%kansas%';
update QUERYDIM set STATE_ID =18 where QUERY like '%kentucky%';
update QUERYDIM set STATE_ID =19 where QUERY like '%louisiana%';
update QUERYDIM set STATE_ID =20 where QUERY like '%maine%';
update QUERYDIM set STATE_ID =21 where QUERY like '%maryland%';
update QUERYDIM set STATE_ID =22 where QUERY like '%massachusetts%';
update QUERYDIM set STATE_ID =23 where QUERY like '%michigan%';
update QUERYDIM set STATE_ID =24 where QUERY like '%minnesota%';
update QUERYDIM set STATE_ID =25 where QUERY like '%mississippi%';
update QUERYDIM set STATE_ID =26 where QUERY like '%missouri%';
update QUERYDIM set STATE_ID =27 where QUERY like '%montana%';
update QUERYDIM set STATE_ID =28 where QUERY like '%nebraska%';
update QUERYDIM set STATE_ID =29 where QUERY like '%nevada%';
update QUERYDIM set STATE_ID =30 where QUERY like '%new hampshire%';
update QUERYDIM set STATE_ID =31 where QUERY like '%new jersey%';
update QUERYDIM set STATE_ID =32 where QUERY like '%new mexico%';
update QUERYDIM set STATE_ID =33 where QUERY like '%new york%';
update QUERYDIM set STATE_ID =34 where QUERY like '%north carolina%';
update QUERYDIM set STATE_ID =35 where QUERY like '%north dakota%';
update QUERYDIM set STATE_ID =36 where QUERY like '%ohio%';
update QUERYDIM set STATE_ID =37 where QUERY like '%oklahoma%';
update QUERYDIM set STATE_ID =38 where QUERY like '%oregon%';
update QUERYDIM set STATE_ID =39 where QUERY like '%pennsylvania%';
update QUERYDIM set STATE_ID =40 where QUERY like '%rhode island%';
update QUERYDIM set STATE_ID =41 where QUERY like '%south carolina%';
update QUERYDIM set STATE_ID =42 where QUERY like '%south dakota%';
update QUERYDIM set STATE_ID =43 where QUERY like '%tennessee%';
update QUERYDIM set STATE_ID =44 where QUERY like '%texas%';
update QUERYDIM set STATE_ID =45 where QUERY like '%utah%';
update QUERYDIM set STATE_ID =46 where QUERY like '%vermont%';
update QUERYDIM set STATE_ID =47 where QUERY like '%virginia%';
update QUERYDIM set STATE_ID =48 where QUERY like '%washington%';
update QUERYDIM set STATE_ID =49 where QUERY like '%west virginia%';
update QUERYDIM set STATE_ID =50 where QUERY like '%wisconsin%';
update QUERYDIM set STATE_ID =51 where QUERY like '%wyoming%';

-- then update the users first for DMV.

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 1
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 1) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 2
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 2) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 3
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 3) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 4
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 4) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 5
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 5) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 6
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 6) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 7
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 7) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 8
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 8) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 9
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 9) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 10
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 10) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 11
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 11) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 12
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 12) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 13
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 13) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 14
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 14) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 15
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 15) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 16
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 16) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 17
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 17) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 18
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 18) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 19
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 19) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 20
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 20) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 21
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 21) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 22
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 22) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 23
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 23) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 24
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 24) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 25
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 25) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 26
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 26) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 27
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 27) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 28
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 28) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 29
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 29) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 30
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 30) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 31
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 31) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 32
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 32) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 33
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 33) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 34
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 34) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 35
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 35) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 36
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 36) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 37
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 37) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 38
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 38) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 39
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 39) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 40
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 40) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 41
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 41) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 42
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 42) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 43
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 43) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 44
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 44) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 45
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 45) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 46
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 46) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 47
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 47) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 48
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 48) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 49
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 49) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 50
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 50) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 51
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 51) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 52
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%dmv%' and STATE_ID = 52) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

-- Then update the user for tax

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 1
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 1) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 2
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 2) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 3
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 3) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 4
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 4) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 5
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 5) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 6
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 6) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 7
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 7) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 8
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 8) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 9
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 9) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 10
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 10) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 11
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 11) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 12
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 12) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 13
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 13) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 14
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 14) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 15
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 15) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 16
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 16) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 17
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 17) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 18
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 18) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 19
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 19) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 20
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 20) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 21
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 21) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 22
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 22) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 23
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 23) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 24
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 24) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 25
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 25) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 26
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 26) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 27
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 27) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 28
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 28) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 29
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 29) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 30
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 30) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 31
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 31) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 32
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 32) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 33
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 33) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 34
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 34) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 35
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 35) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 36
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 36) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 37
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 37) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 38
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 38) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 39
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 39) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 40
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 40) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 41
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 41) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 42
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 42) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 43
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 43) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 44
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 44) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 45
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 45) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 46
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 46) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 47
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 47) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 48
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 48) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 49
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 49) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 50
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 50) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 51
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 51) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

UPDATE ANONIDDIM
SET ANONIDDIM.STATE_ID = 52
FROM ANONIDDIM
inner join

(
    SELECT DISTINCT FACTS.ANONID 'USERS'
        FROM FACTS 
        INNER JOIN (select QUERYDIM.ID 'ID_QUERY',QUERYDIM.STATE_ID
                    from QUERYDIM 
                    inner join STATES on STATES.ID = QUERYDIM.STATE_ID
                    WHERE query like '%tax%' and STATE_ID = 52) t on t.ID_QUERY = FACTS.QUERYID) t1
on ANONIDDIM.ANONID = t1.USERS;

-- and so on if we want to change the words


