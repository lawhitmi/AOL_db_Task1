//// -- LEVEL 1
//// -- Tables and References

// Creating tables
Table FACTS as F {
  QUERYID varchar
  TIMEID timestamp
  ANONID int
  URLID int
  STATE_ID int
  IRANK int
  CLICK boolean
}

Table ANONIDDIM {
  ID int [pk]
  ANONID int
}

Table URLDIM {
  ID int [pk]
  URL varchar
  TITLE varchar
  DESCRIPTION varchar
  PROTOCOL varchar
  SUBDOMAIN varchar
  THISDOMAIN varchar
  TOPLEVELDOMAIN varchar
  THISPATH varchar
}
 
Table TIMEDIM {
  ID int [pk]
  year int
  month varchar
  "calendar week" int
  "day of the week" int
  "weekday" varchar
  "day of the month" int
  "day of the year" int
  hour int
  minute int
  second int
  DATETIME timestamp
}

Table QUERYDIM {
  ID int [pk]
  QUERY varchar
}

Table STATES {
  ID int [pk]
  STATE_NAME varchar
  STATE_ABBR varchar
  REGION varchar
  CAPITAL varchar
  LAT decimal
  LONG decimal
}

// Creating references
// You can also define relaionship separately
// > many-to-one; < one-to-many; - one-to-one
Ref: F.QUERYID > QUERYDIM.ID  
Ref: F.TIMEID > TIMEDIM.ID
Ref: F.ANONID > ANONIDDIM.ID
Ref: F.URLID > URLDIM.ID
Ref: F.STATE_ID > STATES.ID

