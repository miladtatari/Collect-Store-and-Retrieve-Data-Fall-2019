
#calling ODBC library into R
library (sqldf)
require(lubridate)
#creates the birdstrikeDB database in SQLite
db <- dbConnect(SQLite(),dbname="birdstrikesDB.sqlite")

#create dataframes corresponding to the tables in the database
# This code returned error: read.csv.sql("Bird Strikes.csv",sql="CREATE TABLE Strike
#                                       AS (SELECT Record_ID, FlightDate FROM file", dbname = "birdstrikesDB.sqlite")
# Table 1: Strike
# Load columns 10 (Record ID) and 11 (FlightDate) into a dataframe and convert blanks to NA
StrikeDF <- read.csv("Bird Strikes.csv", stringsAsFactors=FALSE, header=TRUE, na.strings="",colClasses=c(rep("NULL",9),"character",
                                                                                                          "character",rep("NULL",26)))
StrikeDF <- data.frame(StrikeDF[,2],StrikeDF[,1])
#change column names of birdStrikes for simplicity
names(StrikeDF)[1]<-paste("recordID")
names(StrikeDF)[2]<-paste("flightDate")
# move dataframe into table in database
dbGetQuery(db, "CREATE TABLE Strike (
           recordID INTEGER PRIMARY KEY,
           flightDate DATETIME
           )")
dbWriteTable(db, "Strike", StrikeDF, append=TRUE, row.names=FALSE)

# Table 2: Airline
#Load column 15 (Airline/Operator) into a dataframe and convert blanks to NA
AirlineDF <- read.csv("Bird Strikes.csv", stringsAsFactors=FALSE, header=TRUE, na.strings="",colClasses=c(rep("NULL",14),"character",rep("NULL",22)))
names(AirlineDF)[1]<-paste("airlineName")
#move dataframe into table in database
dbGetQuery(db, "CREATE TABLE Airline (
           airlineName TEXT
           )")
dbWriteTable(db, "Airline", AirlineDF, append=TRUE, row.names=FALSE)


# Table 3: Airport
#Load column 2 (Airport) into a dataframe and convert blanks to NA
AirportDF <- read.csv("Bird Strikes.csv", stringsAsFactors=FALSE, header=TRUE, na.strings="",colClasses=c("NULL","character",rep("NULL",35)))
names(AirportDF)[1]<-paste("airport")
#move dataframe into table in database
dbGetQuery(db, "CREATE TABLE Airport (
           airport TEXT
           )")
dbWriteTable(db, "Airport", AirportDF, append=TRUE, row.names=FALSE)

# Table 4: Damage - impact, recordID, costOther, costRepair, costTotal
#this command will load only columns 6 (Impact), 11(recordID) and 30-32(costOther, costRepair, costTotal)
DamageDF <- read.csv("Bird Strikes.csv", stringsAsFactors=FALSE, header=TRUE,
                     na.strings="",colClasses=c(rep("NULL",5), "character", rep("NULL",4), "character", rep("NULL",18), rep("character",3), rep("NULL",5)))
names(DamageDF)[1]<-paste("impact")
names(DamageDF)[2]<-paste("recordID")
names(DamageDF)[3]<-paste("costOther")
names(DamageDF)[4]<-paste("costRepair")
names(DamageDF)[5]<-paste("costTotal")
#move dataframe into table in database
dbGetQuery(db, "CREATE TABLE Damage (
           impact TEXT,
           recordID INTEGER PRIMARY KEY,
           costOther TEXT,
           costRepair TEXT,
           costTotal TEXT
           )")
dbWriteTable(db, "Damage", DamageDF, append=TRUE, row.names=FALSE)


## Retrieve some rows from database using SQL SELECT statements
dbListTables(db)
dbGetQuery(db, "SELECT * FROM Strike LIMIT 10")
dbGetQuery(db,"SELECT costTotal FROM Damage WHERE recordID = 200508")
dbGetQuery(db, "SELECT MAX(costTotal) FROM Damage")
dbGetQuery(db, "SELECT DISTINCT airlineName FROM Airline LIMIT 5")
dbGetQuery(db, "SELECT impact, COUNT(*) FROM Damage GROUP BY impact")


