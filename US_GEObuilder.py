import csv
from exaDBconn import genDBCursor
import sys



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

#Generate dictionary with distinct states and abbreviations for writing to DB
def createUSSTATEStable():
    print('Connecting to database...')
    cur = genDBCursor()
    print('Creating Table...')
    cur.execute("CREATE TABLE IF NOT EXISTS AOL_SCHEMA.USSTATES \
    (\
    ID int IDENTITY,\
    STATE_ABBR varchar(3),\
    STATE_NAME varchar(100)\
    )")
    

    stateDict = {}
    with open('./datasrc/US.txt') as f:
        reader = csv.reader(f, delimiter='\t')
        for row in reader:
            if row[4] not in stateDict:
                stateDict[row[4]]=row[3]
    print('Writing to USSTATES table...')
    
    for i in stateDict:
        valDict = {'abbr':i,'name':stateDict[i]}
        

        insertQuery = "INSERT INTO AOL_SCHEMA.USSTATES(\
                        STATE_ABBR, STATE_NAME)\
                        VALUES({abbr},{name})"
        cur.execute(insertQuery,valDict)

if __name__ == "__main__":
    if sys.argv[1] == 'US_GEO':
        createUSGEOtable()
    elif sys.argv[1] == 'USSTATES':
        createUSSTATEStable()
    
