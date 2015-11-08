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
Sys.setlocale("LC_TIME", "English") 

png("plot4.png")
par(mfrow=c(2,2))
with(DATA,plot(DateTime,Global_active_power,type = "l",ylab = "Global Active Power",xlab = "" ))
with(DATA,plot(DateTime,Voltage,type = "l"))

with(DATA,{
  plot(DateTime,Sub_metering_1,type = "l",ylab="Energy Sub Metering",xlab = "")
  lines(DateTime,Sub_metering_2,col="red")
  lines(DateTime,Sub_metering_3,col="blue")
  
}
)
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=c(1,1,1),
       lwd=c(2.5,2.5,2.5),col=c("black","red","blue")
)
with(DATA,plot(DateTime,Global_reactive_power,type = "l"))


dev.off()