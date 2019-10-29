import cur as cur
import pyexasol as pe

def genDBCursor():
    Con = pe.connect(dsn='192.168.56.101:8563',user='sys', password = 'exasol')
    Con.execute("OPEN SCHEMA AOL_SCHEMA;")
    return Con

def UserInfo():
    """Returns a list of tuples with (STATE_ID, STATE_ABBR, STATE_NAME)"""
    curs = genDBCursor()

    SQL = "SELECT FACTS.ANONID, COUNT(DISTINCT STATES.STATE_ABBR)  'Conteo' \
            FROM FACTS \
            JOIN QUERYDIM on QUERYDIM.ID = FACTS.QUERYID \
            JOIN STATES on STATES.ID=QUERYDIM.STATE_ID \
            WHERE QUERYDIM.QUERY LIKE '%1040%' \
                OR QUERYDIM.QUERY LIKE '%tax forms%' \
                OR QUERYDIM.QUERY LIKE '% irs %' \
                OR QUERYDIM.QUERY LIKE '% dmv %' \
                OR QUERYDIM.QUERY LIKE '% DOT %' \
                OR QUERYDIM.QUERY LIKE 'irs %' \
                OR QUERYDIM.QUERY LIKE '%tax%' \
                OR QUERYDIM.QUERY LIKE '% elementary school %' \
                OR QUERYDIM.QUERY LIKE '% middle school %' \
            GROUP BY FACTS.ANONID \
            HAVING COUNT(DISTINCT STATES.STATE_ABBR) > 1 \
            ORDER BY 1;"
    smt = curs.execute(SQL)
    users =[]
    for row in smt:
        users.append((row[0],row[1]))
    return users

def InsertInto():

    UsrInf = UserInfo()
    print('Connecting to database...')
    cur = genDBCursor()
    print('Creating Table')

    SQL = "CREATE TABLE UserCountState_Stg( \
                 UserId  DECIMAL(18, 0),\
                 Count   DECIMAL(18, 0)\
             );"

    cur.execute(SQL)

    print('Done Creating table')

    print('Inserting Data')

    for i in range(len(UsrInf)):

         searchTerms = { 'User': UsrInf[i][0], \
                         'Count': UsrInf[i][1] \
                         }

         queryBld = f"INSERT INTO UserCountState_Stg VALUES ({searchTerms['User']},{searchTerms['Count']})"

         cur.execute(queryBld)

    print('Done Data')

    SQL2 = "CREATE TABLE FinalUser_Stg( \
                 Count  DECIMAL(18, 0),\
                 UserId   DECIMAL(18, 0),\
                 States varchar(10) \
             );"

    cur.execute(SQL2)


    SQL3 = "select USERID, COUNT\
            from AOL_SCHEMA.USERCOUNTSTATE_STG;"

    smt = cur.execute(SQL3)
    users =[]
    for row in smt:
        users.append((row[0],row[1]))

    print("ahora viene el mierdero")

    for x in range(len(users)):

        KeyTerms = { 'User': users[x][0], \
                        'Count': users[x][1] \
                        }

        Item = KeyTerms['User']
        Item = str(Item)
        print(Item)

        Query = "SELECT COUNT(*) conteo ,FACTS.ANONID usr,STATES.STATE_ABBR ste \
                FROM FACTS \
                JOIN QUERYDIM on QUERYDIM.ID = FACTS.QUERYID \
                JOIN STATES on STATES.ID=QUERYDIM.STATE_ID \
                WHERE (QUERYDIM.QUERY LIKE '%1040%' \
                            OR QUERYDIM.QUERY LIKE '%tax forms%' \
                            OR QUERYDIM.QUERY LIKE '% irs %' \
                            OR QUERYDIM.QUERY LIKE '% dmv %' \
                            OR QUERYDIM.QUERY LIKE '% DOT %' \
                            OR QUERYDIM.QUERY LIKE 'irs %' \
                            OR QUERYDIM.QUERY LIKE '%tax%' \
                            OR QUERYDIM.QUERY LIKE '% elementary school %' \
                            OR QUERYDIM.QUERY LIKE '% middle school %') \
                and FACTS.ANONID = "+ Item + " \
                GROUP BY FACTS.ANONID, STATES.STATE_ABBR \
                HAVING count(*) = ( \
                        SELECT max(t1.conteo) \
                        FROM ( \
                                SELECT \
                                        COUNT(*) conteo ,FACTS.ANONID usr,STATES.STATE_ABBR ste \
                                FROM FACTS \
                                JOIN QUERYDIM on QUERYDIM.ID = FACTS.QUERYID \
                                JOIN STATES on STATES.ID=QUERYDIM.STATE_ID \
                                WHERE (QUERYDIM.QUERY LIKE '%1040%' \
                                            OR QUERYDIM.QUERY LIKE '%tax forms%' \
                                            OR QUERYDIM.QUERY LIKE '% irs %' \
                                            OR QUERYDIM.QUERY LIKE '% dmv %' \
                                            OR QUERYDIM.QUERY LIKE '% DOT %' \
                                            OR QUERYDIM.QUERY LIKE 'irs %' \
                                            OR QUERYDIM.QUERY LIKE '%tax%' \
                                            OR QUERYDIM.QUERY LIKE '% elementary school %' \
                                            OR QUERYDIM.QUERY LIKE '% middle school %') \
                                and FACTS.ANONID = "+  Item + " \
                                GROUP BY FACTS.ANONID, STATES.STATE_ABBR) t1);"

        print(Query)
        smt2 = cur.execute(Query)
        final = []
        for row in smt2:
            final.append((row[0], row[1], row[2]))


        for n in range(len(final)):

            Terms =   { 'cnt': final[n][0], \
                        'usr': final[n][1], \
                        'st': final[n][2] \
                            }

            print( Terms['cnt'])
            print( Terms['usr'])
            print( Terms['st'])

            queryIns = f"INSERT INTO FinalUser_Stg VALUES ("+ str(Terms['cnt'])+ "," +str(Terms['usr'])+ ","+ "'" +str(Terms['st'])+ "'" +")"

            print(queryIns)

            cur.execute(queryIns)

    print("si llega hasta aca funciono")



InsertInto()