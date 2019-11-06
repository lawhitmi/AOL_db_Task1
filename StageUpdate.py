from exaDBconn import genDBCursor

cur = genDBCursor()

query = 'SELECT QUERYID, TIMEID, ANONID, URLID, IRANK, CLICK, STATE_ID, DATAPOINT ' \
        'FROM FACTS ORDER BY QUERYID, TIMEID, ANONID, URLID ;'

result = cur.execute(query)

i=1
for row in result:
    insertQuery = f"INSERT INTO FACTS_COPY VALUES {i}\
                    {row[0]}, {row[1]}, {row[2]}, {row[3]}, {row[4]}, {row[5]}, {row[6]}, {row[7]};"
    cur.execute(insertQuery)
    i+=1
