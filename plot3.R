#An if clause that check if the data file exists and eventually it downloads and prepares the data
if(!file.exists("power_cons_data.csv")){
    fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl,destfile="household_power_consumption.zip",method="curl")
    unzip("household_power_consumption.zip")
    
    initial <- read.table("household_power_consumption.txt", nrows = 100, sep=";", na.strings="?", stringsAsFactors=F)
    classes <- sapply(initial, class)
    power_consumption_data <- read.table("household_power_consumption.txt", sep=";", na.strings="?", colClasses = classes,  stringsAsFactors=F, header=T)
    # da aggiungere qui subset 
    power_consumption_data$Date <- as.Date(power_consumption_data$Date, "%d/%m/%Y")
    power_consumption_data$Time <- strptime(power_consumption_data$Time, format="%H:%M:%S")
    power_consumption_data$Time <- strftime(power_consumption_data$Time, "%H:%M:%S")
    
    library("dplyr")
    power_cons_data <- filter(power_consumption_data, Date<"2007-02-03" & Date>="2007-02-01")
    write.csv(power_cons_data, file="power_cons_data.csv", row.names = FALSE)}


pcd <- read.csv("power_cons_data.csv", stringsAsFactors=FALSE)

x <- paste(pcd$Date, pcd$Time)
dt <- strptime(x, format="%Y-%m-%d %H:%M:%S")
png(filename = "plot3.png", width = 480, height = 480)

par(cex=0.8)
with(pcd, {
  plot(dt, Sub_metering_1, type="l", ylab="Energy sub metering", xlab="")
  lines(dt, Sub_metering_2, col="red" )
  lines(dt, Sub_metering_3, col="blue")
  legend("topright", lty = "solid", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})
dev.off()

