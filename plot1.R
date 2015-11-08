library(RSQLite)
library(DBI)


# Create/Connect to a database to store file
con <- dbConnect(RSQLite::SQLite(), dbname = "backup.sqlite")

# read csv file into sql database
# To use database capacities for quering data
# Warning: this is going to take some time and disk space, 
#   as your complete CSV file is transferred into an SQLite database.
dbWriteTable(con, name="house_power", value="./household_power_consumption.txt", 
             row.names=FALSE, header=TRUE, sep = ";")

#Query data on days 1/2/2007 2/2/2007 
DATA<- dbGetQuery(con, "SELECT * FROM house_power WHERE Date='1/2/2007' OR Date='2/2/2007' ")

#disconnect to database
dbDisconnect(con)


#Convert date strings in R date time 
DATA$DateTime<-paste(DATA$Date,DATA$Time,sep=" ")
DATA$DateTime<-strptime(DATA$DateTime,format = "%d/%m/%Y %H:%M:%S")
DATA$Date<-as.Date(DATA$Date)

png("plot1.png")
hist(DATA$Global_active_power,col="red",main = "Global Active Power",xlab  = "Global Active Power(KiloWatts)")
dev.off()
