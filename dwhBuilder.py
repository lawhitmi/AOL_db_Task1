import csv
import sys
import os

currPath = os.getcwd()

def getStateInfo():
    """Returns a list of tuples with (STATE_ID, STATE_ABBR, STATE_NAME)"""
    stateKeywords=[]
    with open('./Import2.csv') as f:
        for i in f:
            row = i.rstrip().split(',')
            stateKeywords.append((row[0],row[2],row[1]))
    return stateKeywords

with open('tableBuilder.sql', 'a') as the_file:
    the_file.write("CREATE TABLE LOCATION ( \
        ID DECIMAL(18,0), \
        COUNTRY  VARCHAR(4) UTF8, \
        ZIPCODE  DECIMAL(10,0), \
        CITY   VARCHAR(100) UTF8, \
        STATE_NAME   VARCHAR(100) UTF8, \
        STATE_ABBR   VARCHAR(4) UTF8, \
        LAT DECIMAL(10,5), \
        LONG DECIMAL(10,5) \
        );\n")
    the_file.write("CREATE TABLE STATES ( \
            ID        DECIMAL(18,0), \
            STATE_NAME VARCHAR(100) UTF8, \
            STATE_ABBR VARCHAR(4) UTF8 \
        );\n")
    the_file.write("ALTER TABLE AOL_SCHEMA.QUERYDIM ADD COLUMN STATE_ID DECIMAL(18,0);\n")
    the_file.write("ALTER TABLE AOL_SCHEMA.ANONIDDIM ADD COLUMN STATE_ID DECIMAL(18,0);\n")
    the_file.write("ALTER TABLE TIMEDIM ADD datetime TIMESTAMP;\n")

    the_file.write("UPDATE TIMEDIM \
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
            JOIN TIMEDIM on newVals.ID = TIMEDIM.ID;\n")
    
    
    the_file.write(f"""IMPORT INTO AOL_SCHEMA.LOCATION FROM LOCAL CSV FILE '{currPath}/Import1.csv' \
                ENCODING = 'UTF-8' \
                ROW SEPARATOR = 'CRLF' \
                COLUMN SEPARATOR = ',' \
                COLUMN DELIMITER = '"' \
                SKIP = 0 \
                REJECT LIMIT 0;\n""")


    the_file.write(f"""IMPORT INTO AOL_SCHEMA.STATES FROM LOCAL CSV FILE '{currPath}/Import2.csv' \
                ENCODING = 'UTF-8' \
                ROW SEPARATOR = 'CRLF' \
                COLUMN SEPARATOR = ',' \
                COLUMN DELIMITER = '"' \
                SKIP = 0 \
                REJECT LIMIT 0;\n""")


    states = getStateInfo()
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

    