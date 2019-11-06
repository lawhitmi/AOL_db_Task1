CREATE TABLE FACTS_COPY (
    QUERYID  DECIMAL(18,0),
    TIMEID   DECIMAL(18,0),
    ANONID   DECIMAL(18,0),
    URLID    DECIMAL(18,0),
    IRANK    VARCHAR(100) UTF8,
    CLICK    BOOLEAN,
    STATE_ID DECIMAL(18,0),
	DATAPOINT DECIMAL(18,0)
);

INSERT INTO AOL_SCHEMA.FACTS_COPY
SELECT
		t1.queryid,
		t1.timeid,
		t1.userid as userid,
		t1.UrlId,
		t1.rankeo,
		t1.clic,
		t1.ste,
		ABS((t1.diff - lead(t1.diff) over (partition by t1.Query order by t1.UserId))) as DataPoint
	FROM (
			SELECT
						userSession.ID as UserId,
						URLDIM.THISDOMAIN as ThisDomain,
						FACTS.QUERYID as queryid,
						FACTS.TIMEID as timeid,
						FACTS.ANONID as AnonId,
						FACTS.URLID as UrlId,
						FACTS.IRANK as rankeo,
						FACTS.CLICK as clic,
						FACTS.STATE_ID as ste,
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



RENAME TABLE AOL_SCHEMA.FACTS TO AOL_SCHEMA."FACTS_OLD";
RENAME TABLE AOL_SCHEMA.FACTS_COPY TO AOL_SCHEMA."FACTS";