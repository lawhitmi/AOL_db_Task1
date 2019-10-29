SELECT FACTS.ANONID, COUNT(DISTINCT STATES.STATE_ABBR)  'Conteo'
FROM FACTS
JOIN QUERYDIM on QUERYDIM.ID = FACTS.QUERYID
JOIN STATES on STATES.ID=QUERYDIM.STATE_ID
WHERE QUERYDIM.QUERY LIKE '%1040%' 
            OR QUERYDIM.QUERY LIKE '%tax forms%' 
            OR QUERYDIM.QUERY LIKE '% irs %' 
            OR QUERYDIM.QUERY LIKE '% dmv %' 
            OR QUERYDIM.QUERY LIKE '% DOT %'
            OR QUERYDIM.QUERY LIKE 'irs %' 
            OR QUERYDIM.QUERY LIKE '%tax%' 
            OR QUERYDIM.QUERY LIKE '% elementary school %'
            OR QUERYDIM.QUERY LIKE '% middle school %'
GROUP BY FACTS.ANONID
HAVING COUNT(DISTINCT STATES.STATE_ABBR) > 1
ORDER BY 1;

---


SELECT 
		COUNT(*) conteo
		,FACTS.ANONID usr
		,STATES.STATE_ABBR ste			
	FROM FACTS
	JOIN QUERYDIM on QUERYDIM.ID = FACTS.QUERYID
	JOIN STATES on STATES.ID=QUERYDIM.STATE_ID
	WHERE (QUERYDIM.QUERY LIKE '%1040%' 
	            OR QUERYDIM.QUERY LIKE '%tax forms%' 
	            OR QUERYDIM.QUERY LIKE '% irs %' 
	            OR QUERYDIM.QUERY LIKE '% dmv %' 
	            OR QUERYDIM.QUERY LIKE '% DOT %'
	            OR QUERYDIM.QUERY LIKE 'irs %' 
	            OR QUERYDIM.QUERY LIKE '%tax%' 
	            OR QUERYDIM.QUERY LIKE '% elementary school %'
	            OR QUERYDIM.QUERY LIKE '% middle school %')
	and FACTS.ANONID = 1065
	GROUP BY FACTS.ANONID, STATES.STATE_ABBR
	HAVING count(*) = (
			SELECT max(t1.conteo)
			FROM ( 
					SELECT 
							COUNT(*) conteo
							,FACTS.ANONID usr
							,STATES.STATE_ABBR ste
							
					FROM FACTS
					JOIN QUERYDIM on QUERYDIM.ID = FACTS.QUERYID
					JOIN STATES on STATES.ID=QUERYDIM.STATE_ID
					WHERE (QUERYDIM.QUERY LIKE '%1040%' 
					            OR QUERYDIM.QUERY LIKE '%tax forms%' 
					            OR QUERYDIM.QUERY LIKE '% irs %' 
					            OR QUERYDIM.QUERY LIKE '% dmv %' 
					            OR QUERYDIM.QUERY LIKE '% DOT %'
					            OR QUERYDIM.QUERY LIKE 'irs %' 
					            OR QUERYDIM.QUERY LIKE '%tax%' 
					            OR QUERYDIM.QUERY LIKE '% elementary school %'
					            OR QUERYDIM.QUERY LIKE '% middle school %')
					and FACTS.ANONID = 1065
					GROUP BY FACTS.ANONID, STATES.STATE_ABBR) t1);