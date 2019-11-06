SELECT
    DMOZ_CATEGORIES.TOPIC_2,
	DMOZ_CATEGORIES.TOPIC_3,
    FACTS.STATE_ID,
    count(*)
from FACTS 
INNER JOIN URLDIM on URLDIM.ID = FACTS.URLID
INNER JOIN URL_CATEGORY on URLDIM.ID = URL_CATEGORY.URLID 
INNER JOIN DMOZ_CATEGORIES on DMOZ_CATEGORIES.CATID = URL_CATEGORY.CATEGORYID
INNER JOIN STATES on STATES.ID = FACTS.STATE_ID
where FACTS.CLICK=TRUE and DMOZ_CATEGORIES.TOPIC_2='Shopping'
GROUP BY
    CUBE(DMOZ_CATEGORIES.TOPIC_2,DMOZ_CATEGORIES.TOPIC_3,FACTS.STATE_ID);


 -----

alter table AOL_SCHEMA.ANONIDDIM drop column STATE_ID;
drop table AOL_SCHEMA.LOCATION;
alter table AOL_SCHEMA.QUERYDIM drop column STATE_ID;
drop table AOL_SCHEMA.STATES;
alter table AOL_SCHEMA.TIMEDIM drop column DATETIME;
alter table AOL_SCHEMA.FACTS drop column STATE_ID;


------


-- Show all queries for a given domain and their time since original search query --
-- 


SELECT userSession.ID
, userSession.QUERY
, userSession.STARTTIME
, TIMEDIM.DATETIME as queryTime
, SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime)
, URLDIM.THISDOMAIN
FROM FACTS
JOIN URLDIM on FACTS.URLID = URLDIM.ID
JOIN QUERYDIM on FACTS.QUERYID = QUERYDIM.ID
JOIN TIMEDIM on FACTS.TIMEID = TIMEDIM.ID
JOIN (SELECT FACTS.ANONID as ID, QUERYDIM.QUERY as QUERY, min(TIMEDIM.DATETIME) as startTime, max(TIMEDIM.DATETIME) as endTime 
	FROM FACTS
	JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
	JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
	GROUP BY FACTS.ANONID,
		EXTRACT(MONTH FROM TIMEDIM.DATETIME),
		EXTRACT(DAY FROM TIMEDIM.DATETIME),
		QUERYDIM.QUERY
	ORDER BY 1) as userSession
ON userSession.ID = FACTS.ANONID and userSession.QUERY = QUERYDIM.QUERY and to_char(userSession.STARTTIME, 'DD-MM-YYYY') = to_char(TIMEDIM.DATETIME, 'DD-MM-YYYY')
WHERE URLDIM.THISDOMAIN LIKE '%adidas%';


--------- give one row per query


SELECT FACTS.ANONID as ID
	, QUERYDIM.QUERY as QUERY
	,TIMEDIM."day of the month"
	,SECONDS_BETWEEN(max(TIMEDIM.DATETIME), min(TIMEDIM.DATETIME)) as Diff
	FROM FACTS
	JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
	JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
	where FACTS.ANONID = 329847
	GROUP BY FACTS.ANONID,
		QUERYDIM.QUERY,
		TIMEDIM."day of the month"
	ORDER BY 2;

------


SELECT FACTS.ANONID as ID
	, QUERYDIM.QUERY as QUERY
	,TIMEDIM."day of the month"
	,TIMEDIM.datetime
	,FACTS.Click
	FROM FACTS
	JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
	JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
	where FACTS.ANONID = 329847
	and QUERYDIM.QUERY = 'discovery chanel'
	ORDER BY 2;

------


SELECT 
	t1.ID
	,t1.monthAvg
	,avg(t1.Diff) as Average
FROM 
(
SELECT FACTS.ANONID as ID
	,TIMEDIM."month" as monthAvg
	,SECONDS_BETWEEN(max(TIMEDIM.DATETIME), min(TIMEDIM.DATETIME)) as Diff
	FROM FACTS
	JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
	JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
	GROUP BY FACTS.ANONID,
		QUERYDIM.QUERY,
		TIMEDIM."month"
	ORDER BY 2
) as t1
Group by t1.ID
	,t1.monthAvg
Order by 1;


-------

SELECT t1.*,
		(t1.diff - lag(t1.diff) over (partition by t1.QueryId order by t1.tiempo)) as prueba
FROM (
SELECT userSession.ID as userId
, userSession.QUERY as QueryId 
, userSession.STARTTIME as tiempo
, TIMEDIM.DATETIME as queryTime
, SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime) as diff
, URLDIM.THISDOMAIN
FROM FACTS
JOIN URLDIM on FACTS.URLID = URLDIM.ID
JOIN QUERYDIM on FACTS.QUERYID = QUERYDIM.ID
JOIN TIMEDIM on FACTS.TIMEID = TIMEDIM.ID
JOIN (
SELECT FACTS.ANONID as ID
	, QUERYDIM.QUERY as QUERY
	,min(TIMEDIM.DATETIME) as StartTime
	,max(TIMEDIM.DATETIME) 
	FROM FACTS
	JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
	JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
	where FACTS.ANONID = 329847
	GROUP BY FACTS.ANONID,
		QUERYDIM.QUERY
	order by 2
	) 
as userSession ON userSession.ID = FACTS.ANONID 
and userSession.QUERY = QUERYDIM.QUERY 
order by 2) as t1;


------- avg between url 

SELECT t1.*,
		ABS((t1.diff - lag(t1.diff) over (partition by t1.Query order by t1.UserId))) as DataPoint
FROM (
		SELECT
			userSession.ID as UserId
			, userSession.QUERY as Query
			, URLDIM.THISDOMAIN as ThisDomain
			, SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime) as diff
		FROM FACTS
		JOIN URLDIM on FACTS.URLID = URLDIM.ID
		JOIN QUERYDIM on FACTS.QUERYID = QUERYDIM.ID
		JOIN TIMEDIM on FACTS.TIMEID = TIMEDIM.ID
		JOIN (

				SELECT FACTS.ANONID as ID
				, QUERYDIM.QUERY as QUERY
				, min(TIMEDIM.DATETIME) as startTime
				, max(TIMEDIM.DATETIME) as endTime
				FROM FACTS
				JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
				JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
				GROUP BY FACTS.ANONID,
					EXTRACT(MONTH FROM TIMEDIM.DATETIME),
					EXTRACT(DAY FROM TIMEDIM.DATETIME),
					QUERYDIM.QUERY
				ORDER BY 1) as userSession
		ON to_char(userSession.STARTTIME, 'DD-MM-YYYY') = to_char(TIMEDIM.DATETIME, 'DD-MM-YYYY')
		where userSession.ID = FACTS.ANONID
		and userSession.QUERY = QUERYDIM.QUERY
		and URLDIM.THISDOMAIN like '%ebay%'
		group by userSession.ID as UserId
			, userSession.QUERY as Query
			, URLDIM.THISDOMAIN as ThisDomain
		having SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime) > 0
		order by 1,2,3
		) as t1;


--------- Query the DATAPOINTS

SELECT t1.userid as userid,
		t1.queryid,
		t1.timeid,
		t1.UrlId,
		ABS((t1.diff - lead(t1.diff) over (partition by t1.Query order by t1.UserId))) as DataPoint
	FROM (
			SELECT
						userSession.ID as UserId,
						URLDIM.THISDOMAIN as ThisDomain,
						FACTS.QUERYID as queryid,
						FACTS.TIMEID as timeid,
						FACTS.ANONID as AnonId,
						FACTS.URLID as UrlId,
						userSession.QUERY as Query,
						SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime) as diff
					FROM FACTS
					JOIN URLDIM on FACTS.URLID = URLDIM.ID
					JOIN QUERYDIM on FACTS.QUERYID = QUERYDIM.ID
					JOIN TIMEDIM on FACTS.TIMEID = TIMEDIM.ID
					JOIN (SELECT FACTS.ANONID as ID
						, QUERYDIM.QUERY as QUERY
						, min(TIMEDIM.DATETIME) as startTime
						, max(TIMEDIM.DATETIME) as endTime
						FROM FACTS
						JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
						JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
						--WHERE FACTS.ANONID = 417617
						GROUP BY FACTS.ANONID,
							EXTRACT(MONTH FROM TIMEDIM.DATETIME),
							EXTRACT(DAY FROM TIMEDIM.DATETIME),
							QUERYDIM.QUERY
						ORDER BY 1) as userSession
					ON to_char(userSession.STARTTIME, 'DD-MM-YYYY') = to_char(TIMEDIM.DATETIME, 'DD-MM-YYYY')
					where userSession.ID = FACTS.ANONID
					and userSession.QUERY = QUERYDIM.QUERY
					order by 1,2,3
		) as t1;

--------- Create Stage Table

CREATE TABLE STGTABLE (
	UserID decimal(18,0),
	QueryID decimal(18,0),
	TimeID decimal(18,0),
	urlID decimal(18,0),
	DataPoint decimal(18,0) );

---------

ALTER TABLE AOL_SCHEMA.FACTS ADD COLUMN ID DECIMAL(18,0);


UPDATE FACTS
SET FACTS.DATAPOINT = t.datapoint
FROM FACTS
inner join
(
select
	DISTINCT
	STGTABLE.USERID as usr,
	STGTABLE.QUERYID as qry,
	STGTABLE.TIMEID as tmid,
	STGTABLE.URLID as link,
	STGTABLE.DATAPOINT as datapoint
from STGTABLE
where STGTABLE.UserID = 5240
ORDER BY 1) t on FACTS.ANONID = t.usr
AND FACTS.QUERYID = t.qry
AND FACTS.TIMEID = t.tmid
AND FACTS.URLID = t.link;


------------

INSERT INTO AOL_SCHEMA.STGTABLE
SELECT t1.userid as userid,
		t1.queryid,
		t1.timeid,
		t1.UrlId,
		ABS((t1.diff - lead(t1.diff) over (partition by t1.Query order by t1.UserId))) as DataPoint
	FROM (
			SELECT
						userSession.ID as UserId,
						URLDIM.THISDOMAIN as ThisDomain,
						FACTS.QUERYID as queryid,
						FACTS.TIMEID as timeid,
						FACTS.ANONID as AnonId,
						FACTS.URLID as UrlId,
						userSession.QUERY as Query,
						SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime) as diff
					FROM FACTS
					JOIN URLDIM on FACTS.URLID = URLDIM.ID
					JOIN QUERYDIM on FACTS.QUERYID = QUERYDIM.ID
					JOIN TIMEDIM on FACTS.TIMEID = TIMEDIM.ID
					JOIN (SELECT FACTS.ANONID as ID
						, QUERYDIM.QUERY as QUERY
						, min(TIMEDIM.DATETIME) as startTime
						, max(TIMEDIM.DATETIME) as endTime
						FROM FACTS
						JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
						JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
						--WHERE FACTS.ANONID = 417617
						GROUP BY FACTS.ANONID,
							EXTRACT(MONTH FROM TIMEDIM.DATETIME),
							EXTRACT(DAY FROM TIMEDIM.DATETIME),
							QUERYDIM.QUERY
						ORDER BY 1) as userSession
					ON to_char(userSession.STARTTIME, 'DD-MM-YYYY') = to_char(TIMEDIM.DATETIME, 'DD-MM-YYYY')
					where userSession.ID = FACTS.ANONID
					and userSession.QUERY = QUERYDIM.QUERY
					order by 1,2,3
		) as t1;

---------------------

SELECT t1.*,
		ABS((t1.diff - lead(t1.diff) over (partition by t1.Query order by t1.UserId))) as DataPoint
FROM (
		SELECT
			userSession.ID as UserId
			, userSession.QUERY as Query
			, URLDIM.THISDOMAIN as ThisDomain
			, SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime) as diff
		FROM FACTS
		JOIN URLDIM on FACTS.URLID = URLDIM.ID
		JOIN QUERYDIM on FACTS.QUERYID = QUERYDIM.ID
		JOIN TIMEDIM on FACTS.TIMEID = TIMEDIM.ID
		JOIN (

				SELECT FACTS.ANONID as ID
				, QUERYDIM.QUERY as QUERY
				, min(TIMEDIM.DATETIME) as startTime
				, max(TIMEDIM.DATETIME) as endTime
				FROM FACTS
				JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
				JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
				GROUP BY FACTS.ANONID,
					EXTRACT(MONTH FROM TIMEDIM.DATETIME),
					EXTRACT(DAY FROM TIMEDIM.DATETIME),
					QUERYDIM.QUERY
				ORDER BY 1) as userSession
		ON to_char(userSession.STARTTIME, 'DD-MM-YYYY') = to_char(TIMEDIM.DATETIME, 'DD-MM-YYYY')
		where userSession.ID = FACTS.ANONID
		and userSession.QUERY = QUERYDIM.QUERY
		and URLDIM.THISDOMAIN like '%ebay%'
		and SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime) > 0
		order by 1,2,3
		) as t1;

-----------








