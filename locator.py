from exaDBconn import genDBCursor
import json

def wrapStringsinDict (s):
    """ s: dict containing search strings
    Returns a dict with the values wrapped in SQL wildcards '%' """
    result={}
    for i in s:
        result[i]='%'+s[i]+'%'
    return result

def getCityInfo():
    curs = genDBCursor()
    locations = curs.execute("SELECT ZIPCODE, CITY, STATE_NAME, STATE_ABBR\
                            FROM AOL_SCHEMA.US_GEO")
    cityDict ={}
    for row in locations:
        cityDict[row[0]] = (row[1],row[2],row[3])
    return cityDict

def getStateInfo():
    """Returns a list of tuples with (STATE_ABBR, STATE_NAME) pairs"""
    curs = genDBCursor()
    states = curs.execute("SELECT STATE_ABBR, STATE_NAME \
                            FROM USSTATES;")
    stateKeywords =[]
    for row in states:
        stateKeywords.append((row[0],row[1]))
    return stateKeywords

def buildSearchDict(x):
    NotImplemented
    

curs = genDBCursor()
stateKeywords = getStateInfo()     
resultCount = 0
dataDict = {}    
for i in range(len(stateKeywords)): 
    
    # Check for blanks in stateKeywords
    if not bool(stateKeywords[i][0]) or not bool(stateKeywords[i][1]):
        continue

    # Build up search terms dict for use in query
    searchTerms = {'term0':stateKeywords[i][0]+' %',\
                'term1':"% "+stateKeywords[i][0].lower()+' %',\
                'term2':"% "+stateKeywords[i][0]+' %', \
                'term3':stateKeywords[i][0].lower()+' %',\
                'term4':"% "+stateKeywords[i][0], \
                'term5':'%'+stateKeywords[i][1]+'%',\
                'term6':'%'+stateKeywords[i][1].lower()+'%',\
                'term7':'%'+stateKeywords[i][1].title()+'%'}

    query = "SELECT ANONIDDIM.ID, irsQuery.query, TIMEDIM.[month], TIMEDIM.[day of the week] FROM\
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
            OR QUERYDIM.QUERY LIKE '% weather %'\
            OR QUERYDIM.QUERY LIKE '%weather %') as irsQuery\
            JOIN ANONIDDIM ON irsQuery.anonid = ANONIDDIM.ANONID"
    
    for j in range(len(searchTerms)):
        if j==0:
            query = query+" WHERE irsQuery.query LIKE {term"+str(j)+"}"
        elif j==(len(searchTerms)-1):
            query =query+" OR irsQuery.query LIKE {term"+str(j)+"};"
        else:    
            query = query+" OR irsQuery.query LIKE {term"+str(j)+"}"

    # Provide some status output     
    print(query)
    print('searching: '+ str(stateKeywords[i]))
    # Run Query
    results = curs.execute(query,searchTerms)

    # Build dict of query results
    for res in results:
        dataDict[resultCount]= {'user':str(res[0]),'query':str(res[1]),'abbr':stateKeywords[i][0],'state':stateKeywords[i][1]}
        resultCount+=1
        
# Write dataDict to a json file
with open('./datasrc/locResults.json', 'w') as fp:
    json.dump(dataDict, fp)