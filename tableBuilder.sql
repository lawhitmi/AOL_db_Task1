CREATE TABLE LOCATION (         ID DECIMAL(18,0),         COUNTRY  VARCHAR(4) UTF8,         ZIPCODE  DECIMAL(10,0),         CITY   VARCHAR(100) UTF8,         STATE_NAME   VARCHAR(100) UTF8,         STATE_ABBR   VARCHAR(4) UTF8,         LAT DECIMAL(10,5),         LONG DECIMAL(10,5)         );
CREATE TABLE STATES (             ID        DECIMAL(18,0),             STATE_NAME VARCHAR(100) UTF8,             STATE_ABBR VARCHAR(4) UTF8         );
ALTER TABLE AOL_SCHEMA.QUERYDIM ADD COLUMN STATE_ID DECIMAL(18,0);
ALTER TABLE AOL_SCHEMA.ANONIDDIM ADD COLUMN STATE_ID DECIMAL(18,0);
ALTER TABLE TIMEDIM ADD datetime TIMESTAMP;
UPDATE TIMEDIM                 SET TIMEDIM.DATETIME = newVals.datetime                 FROM (SELECT                 TIMEDIM.ID,                 to_timestamp( CONCAT(TIMEDIM.[year],'-',                 TIMEDIM.[month],'-',                 TIMEDIM.[day of the month],' ',                 TIMEDIM.[hour],':',                 TIMEDIM.[minute],':',                 TIMEDIM.[second]), 'YYYY-MONTH-DD HH24:MI:SS'                 ) as datetime             FROM TIMEDIM) as newVals             JOIN TIMEDIM on newVals.ID = TIMEDIM.ID;
IMPORT INTO AOL_SCHEMA.LOCATION FROM LOCAL CSV FILE 'C:\Users\Lucas\Google Drive\Career\Education\Beuth Data Science\BusinessIntelligence\Task1/Import1.csv'                 ENCODING = 'UTF-8'                 ROW SEPARATOR = 'CRLF'                 COLUMN SEPARATOR = ','                 COLUMN DELIMITER = '"'                 SKIP = 0                 REJECT LIMIT 0;
IMPORT INTO AOL_SCHEMA.STATES FROM LOCAL CSV FILE 'C:\Users\Lucas\Google Drive\Career\Education\Beuth Data Science\BusinessIntelligence\Task1/Import2.csv'                 ENCODING = 'UTF-8'                 ROW SEPARATOR = 'CRLF'                 COLUMN SEPARATOR = ','                 COLUMN DELIMITER = '"'                 SKIP = 0                 REJECT LIMIT 0;
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=1 WHERE QUERY LIKE 'AL %' OR QUERY LIKE '% AL %' OR QUERY LIKE '% AL' OR QUERY LIKE '%Alabama%' OR QUERY LIKE '%alabama%' OR QUERY LIKE '%Alabama%' OR QUERY LIKE '% al' OR QUERY LIKE 'al %' OR QUERY LIKE '% al %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=2 WHERE QUERY LIKE 'AK %' OR QUERY LIKE '% AK %' OR QUERY LIKE '% AK' OR QUERY LIKE '%Alaska%' OR QUERY LIKE '%alaska%' OR QUERY LIKE '%Alaska%' OR QUERY LIKE '% ak' OR QUERY LIKE 'ak %' OR QUERY LIKE '% ak %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=3 WHERE QUERY LIKE 'AZ %' OR QUERY LIKE '% AZ %' OR QUERY LIKE '% AZ' OR QUERY LIKE '%Arizona%' OR QUERY LIKE '%arizona%' OR QUERY LIKE '%Arizona%' OR QUERY LIKE '% az' OR QUERY LIKE 'az %' OR QUERY LIKE '% az %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=4 WHERE QUERY LIKE 'AR %' OR QUERY LIKE '% AR %' OR QUERY LIKE '% AR' OR QUERY LIKE '%Arkansas%' OR QUERY LIKE '%arkansas%' OR QUERY LIKE '%Arkansas%' OR QUERY LIKE '% ar' OR QUERY LIKE 'ar %' OR QUERY LIKE '% ar %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=5 WHERE QUERY LIKE 'CA %' OR QUERY LIKE '% CA %' OR QUERY LIKE '% CA' OR QUERY LIKE '%California%' OR QUERY LIKE '%california%' OR QUERY LIKE '%California%' OR QUERY LIKE '% ca' OR QUERY LIKE 'ca %' OR QUERY LIKE '% ca %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=6 WHERE QUERY LIKE 'CO %' OR QUERY LIKE '% CO %' OR QUERY LIKE '% CO' OR QUERY LIKE '%Colorado%' OR QUERY LIKE '%colorado%' OR QUERY LIKE '%Colorado%';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=7 WHERE QUERY LIKE 'CT %' OR QUERY LIKE '% CT %' OR QUERY LIKE '% CT' OR QUERY LIKE '%Connecticut%' OR QUERY LIKE '%connecticut%' OR QUERY LIKE '%Connecticut%' OR QUERY LIKE '% ct' OR QUERY LIKE 'ct %' OR QUERY LIKE '% ct %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=8 WHERE QUERY LIKE 'DE %' OR QUERY LIKE '% DE %' OR QUERY LIKE '% DE' OR QUERY LIKE '%Delaware%' OR QUERY LIKE '%delaware%' OR QUERY LIKE '%Delaware%' OR QUERY LIKE '% de' OR QUERY LIKE 'de %' OR QUERY LIKE '% de %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=9 WHERE QUERY LIKE 'DC %' OR QUERY LIKE '% DC %' OR QUERY LIKE '% DC' OR QUERY LIKE '%District of Columbia%' OR QUERY LIKE '%district of columbia%' OR QUERY LIKE '%District Of Columbia%' OR QUERY LIKE '% dc' OR QUERY LIKE 'dc %' OR QUERY LIKE '% dc %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=10 WHERE QUERY LIKE 'FL %' OR QUERY LIKE '% FL %' OR QUERY LIKE '% FL' OR QUERY LIKE '%Florida%' OR QUERY LIKE '%florida%' OR QUERY LIKE '%Florida%' OR QUERY LIKE '% fl' OR QUERY LIKE 'fl %' OR QUERY LIKE '% fl %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=11 WHERE QUERY LIKE 'GA %' OR QUERY LIKE '% GA %' OR QUERY LIKE '% GA' OR QUERY LIKE '%Georgia%' OR QUERY LIKE '%georgia%' OR QUERY LIKE '%Georgia%' OR QUERY LIKE '% ga' OR QUERY LIKE 'ga %' OR QUERY LIKE '% ga %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=12 WHERE QUERY LIKE 'HI %' OR QUERY LIKE '% HI %' OR QUERY LIKE '% HI' OR QUERY LIKE '%Hawaii%' OR QUERY LIKE '%hawaii%' OR QUERY LIKE '%Hawaii%';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=13 WHERE QUERY LIKE 'ID %' OR QUERY LIKE '% ID %' OR QUERY LIKE '% ID' OR QUERY LIKE '%Idaho%' OR QUERY LIKE '%idaho%' OR QUERY LIKE '%Idaho%';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=14 WHERE QUERY LIKE 'IL %' OR QUERY LIKE '% IL %' OR QUERY LIKE '% IL' OR QUERY LIKE '%Illinois%' OR QUERY LIKE '%illinois%' OR QUERY LIKE '%Illinois%' OR QUERY LIKE '% il' OR QUERY LIKE 'il %' OR QUERY LIKE '% il %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=15 WHERE QUERY LIKE 'IN %' OR QUERY LIKE '% IN %' OR QUERY LIKE '% IN' OR QUERY LIKE '%Indiana%' OR QUERY LIKE '%indiana%' OR QUERY LIKE '%Indiana%';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=16 WHERE QUERY LIKE 'IA %' OR QUERY LIKE '% IA %' OR QUERY LIKE '% IA' OR QUERY LIKE '%Iowa%' OR QUERY LIKE '%iowa%' OR QUERY LIKE '%Iowa%' OR QUERY LIKE '% ia' OR QUERY LIKE 'ia %' OR QUERY LIKE '% ia %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=17 WHERE QUERY LIKE 'KS %' OR QUERY LIKE '% KS %' OR QUERY LIKE '% KS' OR QUERY LIKE '%Kansas%' OR QUERY LIKE '%kansas%' OR QUERY LIKE '%Kansas%' OR QUERY LIKE '% ks' OR QUERY LIKE 'ks %' OR QUERY LIKE '% ks %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=18 WHERE QUERY LIKE 'KY %' OR QUERY LIKE '% KY %' OR QUERY LIKE '% KY' OR QUERY LIKE '%Kentucky%' OR QUERY LIKE '%kentucky%' OR QUERY LIKE '%Kentucky%' OR QUERY LIKE '% ky' OR QUERY LIKE 'ky %' OR QUERY LIKE '% ky %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=19 WHERE QUERY LIKE 'LA %' OR QUERY LIKE '% LA %' OR QUERY LIKE '% LA' OR QUERY LIKE '%Louisiana%' OR QUERY LIKE '%louisiana%' OR QUERY LIKE '%Louisiana%' OR QUERY LIKE '% la' OR QUERY LIKE 'la %' OR QUERY LIKE '% la %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=20 WHERE QUERY LIKE 'ME %' OR QUERY LIKE '% ME %' OR QUERY LIKE '% ME' OR QUERY LIKE '%Maine%' OR QUERY LIKE '%maine%' OR QUERY LIKE '%Maine%';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=21 WHERE QUERY LIKE 'MD %' OR QUERY LIKE '% MD %' OR QUERY LIKE '% MD' OR QUERY LIKE '%Maryland%' OR QUERY LIKE '%maryland%' OR QUERY LIKE '%Maryland%' OR QUERY LIKE '% md' OR QUERY LIKE 'md %' OR QUERY LIKE '% md %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=22 WHERE QUERY LIKE 'MA %' OR QUERY LIKE '% MA %' OR QUERY LIKE '% MA' OR QUERY LIKE '%Massachusetts%' OR QUERY LIKE '%massachusetts%' OR QUERY LIKE '%Massachusetts%' OR QUERY LIKE '% ma' OR QUERY LIKE 'ma %' OR QUERY LIKE '% ma %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=23 WHERE QUERY LIKE 'MI %' OR QUERY LIKE '% MI %' OR QUERY LIKE '% MI' OR QUERY LIKE '%Michigan%' OR QUERY LIKE '%michigan%' OR QUERY LIKE '%Michigan%' OR QUERY LIKE '% mi' OR QUERY LIKE 'mi %' OR QUERY LIKE '% mi %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=24 WHERE QUERY LIKE 'MN %' OR QUERY LIKE '% MN %' OR QUERY LIKE '% MN' OR QUERY LIKE '%Minnesota%' OR QUERY LIKE '%minnesota%' OR QUERY LIKE '%Minnesota%' OR QUERY LIKE '% mn' OR QUERY LIKE 'mn %' OR QUERY LIKE '% mn %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=25 WHERE QUERY LIKE 'MS %' OR QUERY LIKE '% MS %' OR QUERY LIKE '% MS' OR QUERY LIKE '%Mississippi%' OR QUERY LIKE '%mississippi%' OR QUERY LIKE '%Mississippi%' OR QUERY LIKE '% ms' OR QUERY LIKE 'ms %' OR QUERY LIKE '% ms %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=26 WHERE QUERY LIKE 'MO %' OR QUERY LIKE '% MO %' OR QUERY LIKE '% MO' OR QUERY LIKE '%Missouri%' OR QUERY LIKE '%missouri%' OR QUERY LIKE '%Missouri%' OR QUERY LIKE '% mo' OR QUERY LIKE 'mo %' OR QUERY LIKE '% mo %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=27 WHERE QUERY LIKE 'MT %' OR QUERY LIKE '% MT %' OR QUERY LIKE '% MT' OR QUERY LIKE '%Montana%' OR QUERY LIKE '%montana%' OR QUERY LIKE '%Montana%' OR QUERY LIKE '% mt' OR QUERY LIKE 'mt %' OR QUERY LIKE '% mt %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=28 WHERE QUERY LIKE 'NE %' OR QUERY LIKE '% NE %' OR QUERY LIKE '% NE' OR QUERY LIKE '%Nebraska%' OR QUERY LIKE '%nebraska%' OR QUERY LIKE '%Nebraska%' OR QUERY LIKE '% ne' OR QUERY LIKE 'ne %' OR QUERY LIKE '% ne %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=29 WHERE QUERY LIKE 'NV %' OR QUERY LIKE '% NV %' OR QUERY LIKE '% NV' OR QUERY LIKE '%Nevada%' OR QUERY LIKE '%nevada%' OR QUERY LIKE '%Nevada%' OR QUERY LIKE '% nv' OR QUERY LIKE 'nv %' OR QUERY LIKE '% nv %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=30 WHERE QUERY LIKE 'NH %' OR QUERY LIKE '% NH %' OR QUERY LIKE '% NH' OR QUERY LIKE '%New Hampshire%' OR QUERY LIKE '%new hampshire%' OR QUERY LIKE '%New Hampshire%' OR QUERY LIKE '% nh' OR QUERY LIKE 'nh %' OR QUERY LIKE '% nh %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=31 WHERE QUERY LIKE 'NJ %' OR QUERY LIKE '% NJ %' OR QUERY LIKE '% NJ' OR QUERY LIKE '%New Jersey%' OR QUERY LIKE '%new jersey%' OR QUERY LIKE '%New Jersey%' OR QUERY LIKE '% nj' OR QUERY LIKE 'nj %' OR QUERY LIKE '% nj %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=32 WHERE QUERY LIKE 'NM %' OR QUERY LIKE '% NM %' OR QUERY LIKE '% NM' OR QUERY LIKE '%New Mexico%' OR QUERY LIKE '%new mexico%' OR QUERY LIKE '%New Mexico%' OR QUERY LIKE '% nm' OR QUERY LIKE 'nm %' OR QUERY LIKE '% nm %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=33 WHERE QUERY LIKE 'NY %' OR QUERY LIKE '% NY %' OR QUERY LIKE '% NY' OR QUERY LIKE '%New York%' OR QUERY LIKE '%new york%' OR QUERY LIKE '%New York%' OR QUERY LIKE '% ny' OR QUERY LIKE 'ny %' OR QUERY LIKE '% ny %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=34 WHERE QUERY LIKE 'NC %' OR QUERY LIKE '% NC %' OR QUERY LIKE '% NC' OR QUERY LIKE '%North Carolina%' OR QUERY LIKE '%north carolina%' OR QUERY LIKE '%North Carolina%' OR QUERY LIKE '% nc' OR QUERY LIKE 'nc %' OR QUERY LIKE '% nc %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=35 WHERE QUERY LIKE 'ND %' OR QUERY LIKE '% ND %' OR QUERY LIKE '% ND' OR QUERY LIKE '%North Dakota%' OR QUERY LIKE '%north dakota%' OR QUERY LIKE '%North Dakota%' OR QUERY LIKE '% nd' OR QUERY LIKE 'nd %' OR QUERY LIKE '% nd %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=36 WHERE QUERY LIKE 'OH %' OR QUERY LIKE '% OH %' OR QUERY LIKE '% OH' OR QUERY LIKE '%Ohio%' OR QUERY LIKE '%ohio%' OR QUERY LIKE '%Ohio%';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=37 WHERE QUERY LIKE 'OK %' OR QUERY LIKE '% OK %' OR QUERY LIKE '% OK' OR QUERY LIKE '%Oklahoma%' OR QUERY LIKE '%oklahoma%' OR QUERY LIKE '%Oklahoma%';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=38 WHERE QUERY LIKE 'OR %' OR QUERY LIKE '% OR %' OR QUERY LIKE '% OR' OR QUERY LIKE '%Oregon%' OR QUERY LIKE '%oregon%' OR QUERY LIKE '%Oregon%';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=39 WHERE QUERY LIKE 'PA %' OR QUERY LIKE '% PA %' OR QUERY LIKE '% PA' OR QUERY LIKE '%Pennsylvania%' OR QUERY LIKE '%pennsylvania%' OR QUERY LIKE '%Pennsylvania%' OR QUERY LIKE '% pa' OR QUERY LIKE 'pa %' OR QUERY LIKE '% pa %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=40 WHERE QUERY LIKE 'RI %' OR QUERY LIKE '% RI %' OR QUERY LIKE '% RI' OR QUERY LIKE '%Rhode Island%' OR QUERY LIKE '%rhode island%' OR QUERY LIKE '%Rhode Island%' OR QUERY LIKE '% ri' OR QUERY LIKE 'ri %' OR QUERY LIKE '% ri %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=41 WHERE QUERY LIKE 'SC %' OR QUERY LIKE '% SC %' OR QUERY LIKE '% SC' OR QUERY LIKE '%South Carolina%' OR QUERY LIKE '%south carolina%' OR QUERY LIKE '%South Carolina%' OR QUERY LIKE '% sc' OR QUERY LIKE 'sc %' OR QUERY LIKE '% sc %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=42 WHERE QUERY LIKE 'SD %' OR QUERY LIKE '% SD %' OR QUERY LIKE '% SD' OR QUERY LIKE '%South Dakota%' OR QUERY LIKE '%south dakota%' OR QUERY LIKE '%South Dakota%' OR QUERY LIKE '% sd' OR QUERY LIKE 'sd %' OR QUERY LIKE '% sd %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=43 WHERE QUERY LIKE 'TN %' OR QUERY LIKE '% TN %' OR QUERY LIKE '% TN' OR QUERY LIKE '%Tennessee%' OR QUERY LIKE '%tennessee%' OR QUERY LIKE '%Tennessee%' OR QUERY LIKE '% tn' OR QUERY LIKE 'tn %' OR QUERY LIKE '% tn %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=44 WHERE QUERY LIKE 'TX %' OR QUERY LIKE '% TX %' OR QUERY LIKE '% TX' OR QUERY LIKE '%Texas%' OR QUERY LIKE '%texas%' OR QUERY LIKE '%Texas%' OR QUERY LIKE '% tx' OR QUERY LIKE 'tx %' OR QUERY LIKE '% tx %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=45 WHERE QUERY LIKE 'UT %' OR QUERY LIKE '% UT %' OR QUERY LIKE '% UT' OR QUERY LIKE '%Utah%' OR QUERY LIKE '%utah%' OR QUERY LIKE '%Utah%' OR QUERY LIKE '% ut' OR QUERY LIKE 'ut %' OR QUERY LIKE '% ut %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=46 WHERE QUERY LIKE 'VT %' OR QUERY LIKE '% VT %' OR QUERY LIKE '% VT' OR QUERY LIKE '%Vermont%' OR QUERY LIKE '%vermont%' OR QUERY LIKE '%Vermont%' OR QUERY LIKE '% vt' OR QUERY LIKE 'vt %' OR QUERY LIKE '% vt %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=47 WHERE QUERY LIKE 'VA %' OR QUERY LIKE '% VA %' OR QUERY LIKE '% VA' OR QUERY LIKE '%Virginia%' OR QUERY LIKE '%virginia%' OR QUERY LIKE '%Virginia%' OR QUERY LIKE '% va' OR QUERY LIKE 'va %' OR QUERY LIKE '% va %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=48 WHERE QUERY LIKE 'WA %' OR QUERY LIKE '% WA %' OR QUERY LIKE '% WA' OR QUERY LIKE '%Washington%' OR QUERY LIKE '%washington%' OR QUERY LIKE '%Washington%' OR QUERY LIKE '% wa' OR QUERY LIKE 'wa %' OR QUERY LIKE '% wa %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=49 WHERE QUERY LIKE 'WV %' OR QUERY LIKE '% WV %' OR QUERY LIKE '% WV' OR QUERY LIKE '%West Virginia%' OR QUERY LIKE '%west virginia%' OR QUERY LIKE '%West Virginia%' OR QUERY LIKE '% wv' OR QUERY LIKE 'wv %' OR QUERY LIKE '% wv %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=50 WHERE QUERY LIKE 'WI %' OR QUERY LIKE '% WI %' OR QUERY LIKE '% WI' OR QUERY LIKE '%Wisconsin%' OR QUERY LIKE '%wisconsin%' OR QUERY LIKE '%Wisconsin%' OR QUERY LIKE '% wi' OR QUERY LIKE 'wi %' OR QUERY LIKE '% wi %';
UPDATE AOL_SCHEMA.QUERYDIM SET STATE_ID=51 WHERE QUERY LIKE 'WY %' OR QUERY LIKE '% WY %' OR QUERY LIKE '% WY' OR QUERY LIKE '%Wyoming%' OR QUERY LIKE '%wyoming%' OR QUERY LIKE '%Wyoming%' OR QUERY LIKE '% wy' OR QUERY LIKE 'wy %' OR QUERY LIKE '% wy %';