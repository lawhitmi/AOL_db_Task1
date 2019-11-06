from exaDBconn import genDBCursor

cur = genDBCursor()

query = 'SELECT QUERYID, TIMEID, ANONID, URLID, IRANK, CLICK,' \
        'case when STATE_ID is null then 0 else STATE_ID end as ste,' \
        'case when DATAPOINT is null then 0 else DATAPOINT end as dpoint' \
        ' FROM FACTS ORDER BY QUERYID, TIMEID, ANONID, URLID ;'

result = cur.execute(query)

i=1
for row in result:
    insertQuery = f"INSERT INTO FACTS_COPY VALUES ({i},{row[0]}, {row[1]}, {row[2]}, {row[3]}, {row[4]}, {row[5]}, {row[6]}, {row[7]});"
    print(insertQuery)
    cur.execute(insertQuery)
    i+=1
