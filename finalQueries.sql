-----Query 1 - How badly do Americans procrastinate on their taxes? -------
SELECT EXTRACT(MONTH FROM t.firstQuery)
	, EXTRACT(DAY FROM t.firstQuery)
	, count(*) 
	FROM (SELECT FACTS.ANONID as id
		, min(TIMEDIM.DATETIME) as firstQuery
		FROM FACTS
		JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
		JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
		WHERE (QUERYDIM.QUERY LIKE '% irs %'
		OR QUERYDIM.QUERY LIKE '%irs %'
		OR QUERYDIM.QUERY LIKE '%1040%'
		OR QUERYDIM.QUERY LIKE '%tax%')
		GROUP BY FACTS.ANONID) t
GROUP BY EXTRACT(MONTH FROM t.firstQuery), EXTRACT(DAY FROM t.firstQuery);

-----Query 2 - How many users have we geolocated by state -----------
SELECT STATES.STATE_ABBR
	, count(distinct FACTS.ANONID) 
FROM FACTS
JOIN STATES on FACTS.STATE_ID = STATES.ID
GROUP BY STATES.STATE_ABBR;

-----Query 3 - FORMAL QUERY 1: This query should return statistics for the session length for users in each State and Region---------
SELECT STATES.REGION
	, STATES.STATE_ABBR
	, AVG(t.attnSpan)
	, MEDIAN(t.attnSpan)
	, STDDEV(t.attnSpan)
FROM STATES 
JOIN (SELECT FACTS.STATE_ID as stateID
	, FACTS.ANONID as ID
	, QUERYDIM.QUERY as QUERY
	, min(TIMEDIM.DATETIME) as startTime
	, max(TIMEDIM.DATETIME) as endTime
	, SECONDS_BETWEEN(max(TIMEDIM.DATETIME),min(TIMEDIM.DATETIME)) as attnSpan
	FROM FACTS
	JOIN QUERYDIM ON FACTS.QUERYID=QUERYDIM.ID
	JOIN TIMEDIM ON FACTS.TIMEID=TIMEDIM.ID
	GROUP BY FACTS.STATE_ID,FACTS.ANONID
		, EXTRACT(MONTH FROM TIMEDIM.DATETIME)
		, EXTRACT(DAY FROM TIMEDIM.DATETIME)
		, QUERYDIM.QUERY
	HAVING SECONDS_BETWEEN(max(TIMEDIM.DATETIME),min(TIMEDIM.DATETIME))>0) t
ON STATES.ID=t.stateID
GROUP BY ROLLUP(STATES.REGION, STATES.STATE_ABBR);

-----Query 4 - FORMAL QUERY 2: These queries return the median search cost and the number of unique Users for URL Domains ebay and amazon, binned for each state and region---------
SELECT STATES.REGION
	, STATES.STATE_ABBR
	, median(SECONDS_BETWEEN(TIMEDIM.DATETIME, userSessiON.starttime))
	, count(DISTINCT FACTS.ANONID)
FROM FACTS
JOIN URLDIM ON FACTS.URLID = URLDIM.ID
JOIN QUERYDIM ON FACTS.QUERYID = QUERYDIM.ID
JOIN TIMEDIM ON FACTS.TIMEID  = TIMEDIM.ID
JOIN STATES ON STATES.ID=FACTS.STATE_ID
JOIN (SELECT FACTS.ANONID as ID
		, QUERYDIM.QUERY as QUERY
		, min(TIMEDIM.DATETIME) as startTime
		, max(TIMEDIM.DATETIME) as endTime 
	FROM FACTS
	JOIN QUERYDIM ON FACTS.QUERYID=QUERYDIM.ID
	JOIN TIMEDIM ON FACTS.TIMEID=TIMEDIM.ID
	GROUP BY FACTS.ANONID
		, EXTRACT(MONTH FROM TIMEDIM.DATETIME)
		, EXTRACT(DAY FROM TIMEDIM.DATETIME)
		, QUERYDIM.QUERY
	ORDER BY 1) as userSession
ON to_char(userSession.STARTTIME, 'DD-MM-YYYY') = to_char(TIMEDIM.DATETIME, 'DD-MM-YYYY')
WHERE userSession.ID = FACTS.ANONID 
AND userSession.QUERY = QUERYDIM.QUERY 
AND ( URLDIM.THISDOMAIN LIKE 'amazon'
OR URLDIM.THISDOMAIN LIKE 'amazon.%')
AND SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime)>0
GROUP BY ROLLUP(STATES.REGION,STATES.STATE_ABBR)
HAVING count(*)>10;


SELECT STATES.REGION
	, STATES.STATE_ABBR
	, median(SECONDS_BETWEEN(TIMEDIM.DATETIME, userSessiON.starttime))
	, count(DISTINCT FACTS.ANONID)
FROM FACTS
JOIN URLDIM ON FACTS.URLID = URLDIM.ID
JOIN QUERYDIM ON FACTS.QUERYID = QUERYDIM.ID
JOIN TIMEDIM ON FACTS.TIMEID  = TIMEDIM.ID
JOIN STATES ON STATES.ID=FACTS.STATE_ID
JOIN (SELECT FACTS.ANONID as ID
		, QUERYDIM.QUERY as QUERY
		, min(TIMEDIM.DATETIME) as startTime
		, max(TIMEDIM.DATETIME) as endTime 
	FROM FACTS
	JOIN QUERYDIM ON FACTS.QUERYID=QUERYDIM.ID
	JOIN TIMEDIM ON FACTS.TIMEID=TIMEDIM.ID
	GROUP BY FACTS.ANONID
		, EXTRACT(MONTH FROM TIMEDIM.DATETIME)
		, EXTRACT(DAY FROM TIMEDIM.DATETIME)
		, QUERYDIM.QUERY
	ORDER BY 1) as userSession
ON to_char(userSession.STARTTIME, 'DD-MM-YYYY') = to_char(TIMEDIM.DATETIME, 'DD-MM-YYYY')
WHERE userSession.ID = FACTS.ANONID 
AND userSession.QUERY = QUERYDIM.QUERY 
AND and (URLDIM.THISDOMAIN LIKE '% ebay %' 
OR URLDIM.THISDOMAIN LIKE '%.ebay%' 
OR URLDIM.THISDOMAIN LIKE 'ebay %')
AND SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime)>0
GROUP BY ROLLUP(STATES.REGION,STATES.STATE_ABBR)
HAVING count(*)>10;

-----Query 5 - FORMAL QUERY 3: This query provides the median time spent on all webpages by state and region---------
SELECT STATES.STATE_NAME
	, STATES.REGION
	, median(FACTS.DATAPOINT) 'TW'
FROM FACTS
INNER JOIN STATES ON STATES.ID = FACTS.STATE_ID
WHERE FACTS.DATAPOINT != 0
GROUP BY ROLLUP(STATES.REGION,STATES.STATE_NAME)
ORDER BY 1;

-----Query 6 - FORMAL QUERY 4: ---------
SELECT STATES.REGION
	, DMOZ_CATEGORIES.TOPIC_2
	, DMOZ_CATEGORIES.TOPIC_3
	, median(FACTS.DATAPOINT)
FROM FACTS
INNER JOIN STATES ON STATES.ID = FACTS.STATE_ID
INNER JOIN QUERYDIM ON QUERYDIM.ID = FACTS.QUERYID
INNER JOIN URLDIM ON FACTS.URLID = URLDIM.ID
INNER JOIN URL_CATEGORY ON URL_CATEGORY.URLID = URLDIM.ID
INNER JOIN DMOZ_CATEGORIES ON DMOZ_CATEGORIES.CATID = URL_CATEGORY.CATEGORYID
WHERE DMOZ_CATEGORIES.TOPIC_2 = 'Shopping' AND FACTS.DATAPOINT != 0
GROUP BY CUBE (STATES.REGION
	, DMOZ_CATEGORIES.TOPIC_2
	, DMOZ_CATEGORIES.TOPIC_3);


-------Query 7 - Calculate and add time on webpage to the FACTS_COPY table --------
INSERT INTO AOL_SCHEMA.FACTS_COPY 
SELECT t1.queryid
	, t1.timeid
	, t1.userid as userid
	, t1.UrlId
	, t1.rankeo
	, t1.clic
	, t1.ste
	, ABS((t1.diff - lead(t1.diff) over (partition by t1.Query order by t1.UserId))) as DataPoint
	FROM 
	(SELECT	userSession.ID as UserId, URLDIM.THISDOMAIN as ThisDomain, FACTS.QUERYID as queryid, FACTS.TIMEID as timeid, FACTS.ANONID as AnonId, FACTS.URLID as UrlId, FACTS.IRANK as rankeo, FACTS.CLICK as clic, FACTS.STATE_ID as ste, userSession.QUERY as Query, SECONDS_BETWEEN(TIMEDIM.DATETIME, userSession.starttime) as diff 
	FROM FACTS
	JOIN URLDIM on FACTS.URLID = URLDIM.ID
	JOIN QUERYDIM on FACTS.QUERYID = QUERYDIM.ID
	JOIN TIMEDIM on FACTS.TIMEID = TIMEDIM.ID
	JOIN (SELECT FACTS.ANONID as ID
			, QUERYDIM.QUERY as QUERY
			, min(TIMEDIM.DATETIME) as startTime
			, max(TIMEDIM.DATETIME) as endTimeFROM FACTS
		JOIN QUERYDIM on FACTS.QUERYID=QUERYDIM.ID
		JOIN TIMEDIM on FACTS.TIMEID=TIMEDIM.ID
		GROUP BY FACTS.ANONID
			, EXTRACT(MONTH FROM TIMEDIM.DATETIME)
			, EXTRACT(DAY FROM TIMEDIM.DATETIME)
			, QUERYDIM.QUERY
		ORDER BY 1) as userSession
	ON to_char(userSession.STARTTIME, 'DD-MM-YYYY') = to_char(TIMEDIM.DATETIME, 'DD-MM-YYYY')
	WHERE userSession.ID = FACTS.ANONID	and userSession.QUERY = QUERYDIM.QUERY
	ORDER BY 1,2,3) as t1;

