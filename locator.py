from exaDBconn import genDBCursor
import json

def wrapStringsinDict (s):
    result={}
    for i in s:
        result[i]='%'+s[i]+'%'
    return result

curs = genDBCursor()
curs.execute("OPEN SCHEMA AOL_SCHEMA;")
locations = curs.execute("SELECT ZIPCODE, CITY, STATE_NAME, STATE_ABBR\
                        FROM AOL_SCHEMA.US_GEO")
cityDict ={}
for row in locations:
    cityDict[row[0]] = (row[1],row[2],row[3])

resultCount = 0    
for i in cityDict: 
    searchTerms = {'term0':cityDict[i][0],'term1':cityDict[i][0].lower(),'term2':cityDict[i][0].title(), 'term3':" "+cityDict[i][0],'term4':" "+cityDict[i][0]+" "}
    query = "SELECT ANONIDDIM.ID, irsQuery.query FROM\
            (SELECT QUERYDIM.QUERY as query, FACTS.ANONID as anonid\
            FROM FACTS\
            INNER JOIN QUERYDIM ON QUERYDIM.ID = FACTS.QUERYID\
            WHERE QUERYDIM.QUERY LIKE '%1040%' \
            OR QUERYDIM.QUERY LIKE '%tax forms%' \
            OR QUERYDIM.QUERY LIKE '% irs %' \
            OR QUERYDIM.QUERY LIKE '% dmv %' \
            OR QUERYDIM.QUERY LIKE '% DOT %'\
            OR QUERYDIM.QUERY LIKE '% weather %'\
            OR QUERYDIM.QUERY LIKE '%weather %') as irsQuery\
            JOIN ANONIDDIM ON irsQUERY.anonid = ANONIDDIM.ANONID"
    for j in range(len(searchTerms)):
        if j==0:
            query = query+" WHERE irsQuery.query LIKE {term"+str(j)+"}"
        elif j==(len(searchTerms)-1):
            query =query+" OR irsQuery.query LIKE {term"+str(j)+"};"
        else:    
            query = query+" OR irsQuery.query LIKE {term"+str(j)+"}"
         
    print(query)
    print('searching: '+ cityDict[i][0])

    results = curs.execute(query,wrapStringsinDict(searchTerms))

    dataDict = {}
    for res in results:
        dataDict[resultCount]= {'user':str(res[0]),'query':str(res[1]),'city':cityDict[i][0],'state':cityDict[i][1]}
        resultCount+=1
        

with open('./datasrc/locResults.json', 'w') as fp:
    json.dump(dataDict, fp)