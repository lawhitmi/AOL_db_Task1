import csv
from exaDBconn import genDBCursor
import sys

def getStateInfo():
    """Returns a list of tuples with (STATE_ID, STATE_ABBR, STATE_NAME)"""
    curs = genDBCursor()
    states = curs.execute("SELECT ID, STATE_ABBR, STATE_NAME \
                            FROM STATES;")
    stateKeywords =[]
    for row in states:
        stateKeywords.append((row[0],row[1],row[2]))
    return stateKeywords

# CREATE AND POPULATE US_GEO TABLE FROM US.txt FILE
def createUSGEOtable():
    print("Connecting to database...")
    cur = genDBCursor()
    print("Creating US_GEO table...")
    cur.execute("CREATE TABLE IF NOT EXISTS AOL_SCHEMA.US_GEO \
    ( \
    ZIPCODE int, \
    CITY varchar(100), \
    STATE_NAME varchar(100), \
    STATE_ABBR varchar(100), \
    COUNTY varchar(200), \
    LATITUDE numeric, \
    LONGITUDE numeric, \
    ACCURACY int \
    )")
    print("Writing to US_GEO table...")
    with open('./datasrc/US.txt') as f:
        reader = csv.reader(f,delimiter='\t')
        for row in reader:
            params = {'zip': row[1], 'city':row[2], 'state':row[3], 'abbr':row[4], 'county':row[5], 
                        'lat':row[9],'long':row[10], 'est':row[11]}
        
            query = "INSERT INTO AOL_SCHEMA.US_GEO( \
                        ZIPCODE, CITY, STATE_NAME, STATE_ABBR, \
                        COUNTY, LATITUDE, LONGITUDE, ACCURACY) \
                        VALUES({zip},{city},{state},{abbr},{county},{lat},{long},{est});"
            cur.execute(query,params)


def createSTATEStable():
    """Creates STATES table and populates the table with data from file"""
    print('Connecting to database...')
    cur = genDBCursor()
    print('Creating Table...')
    cur.execute("CREATE TABLE IF NOT EXISTS AOL_SCHEMA.STATES \
    (\
    ID int IDENTITY,\
    STATE_ABBR varchar(3),\
    STATE_NAME varchar(100) UTF8\
    );")
    

    stateDict = {}
    with open('./datasrc/US.txt') as f:
        reader = csv.reader(f, delimiter='\t')
        for row in reader:
            if row[4] not in stateDict:
                stateDict[row[4]]=row[3]
    print('Writing to STATES table...')
    
    for i in stateDict:
        valDict = {'abbr':i,'name':stateDict[i]}
        

        insertQuery = "INSERT INTO AOL_SCHEMA.STATES(\
                        STATE_ABBR, STATE_NAME)\
                        VALUES({abbr},{name})"
        cur.execute(insertQuery,valDict)

#Need to make this generate one long string to execute
def addLocToQUERYDIM():
    """Adds column to QUERYDIM and populates it with STATE_ID from QUERY"""
    states = getStateInfo()
    print('Connecting to database...')
    cur = genDBCursor()

    print('Adding column to QUERYDIM...')
    addCol = "ALTER TABLE AOL_SCHEMA.QUERYDIM ADD COLUMN STATE_ID DECIMAL(18,0);"
    cur.execute(addCol)
    
    with open('tableBuilder.sql', 'a') as the_file:
        
        for i in range(len(states)): 
        
            # Check for blanks in states
            if not bool(states[i][1]) or not bool(states[i][2]):
                continue

            # Build up search terms dict for use in query
            searchTerms = {'ID':states[i][0],\
                        'term0':states[i][1].upper()+' %',\
                        'term1':"% "+states[i][1].upper()+' %',\
                        'term2':"% "+states[i][1].upper(), \
                        'term3':'%'+states[i][2]+'%',\
                        'term4':'%'+states[i][2].lower()+'%',\
                        'term5':'%'+states[i][2].title()+'%'}
            if states[i][1] not in ['OK','OH','IN','CO','ME','OR','ID','HI']:
                searchTerms['term6']="% "+states[i][1].lower()
                searchTerms['term7']=states[i][1].lower()+' %'
                searchTerms['term8']="% "+states[i][1].lower()+' %'

            queryBld = f"UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID={searchTerms['ID']}"

            for j in range(len(searchTerms)-1): #-1 to account for ID in first slot
                if j==0:
                    queryBld = queryBld+f" WHERE QUERY LIKE '{searchTerms['term'+str(j)]}'"
                elif j==(len(searchTerms)-2):
                    queryBld =queryBld+f" OR QUERY LIKE '{searchTerms['term'+str(j)]}';"
                else:    
                    queryBld = queryBld+f" OR QUERY LIKE '{searchTerms['term'+str(j)]}'"

            the_file.write(queryBld + '\n')
    the_file.close()
    # Run Query
    #results = cur.execute(query)

def addLocToANONIDDIM():
    #NOT YET IMPLEMENTED
    print('Connecting to database...')
    cur = genDBCursor()

    print('Adding column to ANONIDDIM...')
    addCol = "ALTER TABLE AOL_SCHEMA.ANONIDDIM ADD COLUMN STATE_ID DECIMAL(18,0);"
    cur.execute(addCol)

    query = "SELECT FACTS.ANONID, irsQuery.query, TIMEDIM.[month], TIMEDIM.[day of the week] FROM\
            (SELECT QUERYDIM.QUERY as query, FACTS.ANONID as anonid\
            FROM FACTS\
            INNER JOIN QUERYDIM ON QUERYDIM.ID = FACTS.QUERYID\
            WHERE QUERYDIM.QUERY LIKE '%1040%' \
            OR QUERYDIM.QUERY LIKE '%tax forms%' \
            OR QUERYDIM.QUERY LIKE '% irs %' \
            OR QUERYDIM.QUERY LIKE '% dmv %' \
            OR QUERYDIM.QUERY LIKE '% DOT %'\
            OR QUERYDIM.QUERY LIKE 'irs %' \
            OR QUERYDIM.QUERY LIKE '%tax%' \
            OR QUERYDIM.QUERY LIKE '% elementary school %'\
            OR QUERYDIM.QUERY LIKE '% middle school %') as irsQuery"

def addDATETIMEtoTIMEDIM():
    print('Connecting to database...')
    cur = genDBCursor()
    print('Adding DATETIME column...')
    addCol = "ALTER TABLE TIMEDIM ADD datetime TIMESTAMP;"
    cur.execute(addCol)
    print('Populating DATETIME column...')
    updCol = "UPDATE TIMEDIM \
                SET TIMEDIM.DATETIME = newVals.datetime \
                FROM (SELECT \
                TIMEDIM.ID, \
                to_timestamp( CONCAT(TIMEDIM.[year],'-', \
                TIMEDIM.[month],'-', \
                TIMEDIM.[day of the month],' ', \
                TIMEDIM.[hour],':', \
                TIMEDIM.[minute],':', \
                TIMEDIM.[second]), 'YYYY-MONTH-DD HH24:MI:SS' \
                ) as datetime \
            FROM TIMEDIM) as newVals \
            JOIN TIMEDIM on newVals.ID = TIMEDIM.ID;"
    cur.execute(updCol)


if __name__ == "__main__":
    if sys.argv[1] == 'US_GEO':
        createUSGEOtable()
    elif sys.argv[1] == 'STATES':
        createSTATEStable()
    elif sys.argv[1] == 'QUERYLOC':
        addLocToQUERYDIM()
    elif sys.argv[1] == 'DATETIME':
        addDATETIMEtoTIMEDIM()
    elif sys.argv[1] == 'ALL':
        createUSGEOtable()
        createSTATEStable()
        addLocToQUERYDIM()
        addDATETIMEtoTIMEDIM()
    
