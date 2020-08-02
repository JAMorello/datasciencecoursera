## 1st Prep Step: Download and unzip the files

# Make sure that the directory where the data is to be stored exist
if(!file.exists("./data")){dir.create("./data")}
# Create a vector named "URL" with the URL address
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
# Set download path directory
dwnld_path <- "./data/exdata_data_household_power_consumption.zip"
# Download file
download.file(URL, destfile=dwnld_path, method="curl")
# Unzip file
unzip(zipfile=dwnld_path, exdir="./data")

## 2nd Prep Step: create a table named "HPC" with the data

table_cols <- cols(
  Date = col_date(format = "%d/%m/%Y"),
  Time = col_time(format = "%H:%M:%S"),
  Global_active_power = col_double(),
  Global_reactive_power = col_double(),
  Voltage = col_double(),
  Global_intensity = col_double(),
  Sub_metering_1 = col_double(),
  Sub_metering_2 = col_double(),
  Sub_metering_3 = col_double()
)

# Set dataset path
dataset_path <- "./data/household_power_consumption.txt"

# Create table using the "readr" package
library(readr)
HPC <- read_delim(dataset_path, 
                  delim = ";", 
                  col_types = table_cols, 
                  na = c("?", "NA"))

## 3rd Prep. Step: Subset data from the dates 2007-02-01 and 2007-02-02

sub_HPC <- subset(HPC, Date == as.Date("2007/02/01", format="%Y/%m/%d") 
                  | Date == as.Date("2007/02/02", format="%Y/%m/%d"))

## 4th Prep. Step: Unite Date and Time columns using the "tidyr" package
library(tidyr)
sub_HPC <- unite(sub_HPC, Date, Time, 
                 col = "DateTime", 
                 sep = " ", 
                 remove=TRUE)
# As unite() returns "DateTime" as character, let´s parse it to Datetime type
# using "readr".
sub_HPC$DateTime <- parse_datetime(sub_HPC$DateTime)

## Create PLOT N°4

png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))

# At (1,1)
with(sub_HPC, 
     plot(DateTime, Global_active_power,
          type = "l", 
          ylab = "Global Active Power",
          xlab = "")
     )

# At (1,2)
with(sub_HPC, 
     plot(DateTime, Voltage,
          type = "l")
     )

# At (2,1)
with(sub_HPC, {
  plot(DateTime, Sub_metering_1, type = "l", xlab="", ylab="Energy sub metering")
  points(DateTime, Sub_metering_2, col = "red", type = "l")
  points(DateTime, Sub_metering_3, col = "blue", type = "l")
})
legend("topright", 
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
       col=c("black", "red", "blue"), 
       lwd=1, 
       bty="n")

# Ar (2,2)
with(sub_HPC, 
     plot(DateTime, Global_reactive_power,
          type = "l")
     )

dev.off()