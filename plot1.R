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

#structure of all file:
# 
# pdf(file = "myplot.pdf")  ## Open PDF device; create 'myplot.pdf' in my working directory
## Create plot and send to a file (no plot appears on screen)
# with(faithful, plot(eruptions, waiting))
# title(main = "Old Faithful Geyser data")  ## Annotate plot; still nothing on screen
# dev.off()
png(filename = "plot1.png", width = 480, height = 480)
par(mar = c(5, 4, 4, 2), cex=0.8)
hist(pcd$Global_active_power, col = "red", breaks = 12, main = "Global Active Power",  
     xlab = "Global Active Power (kilowatts)")
dev.off()

