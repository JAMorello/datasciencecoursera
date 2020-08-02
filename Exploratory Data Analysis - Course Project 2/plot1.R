# 1st Prep Step: Download and unzip the files

# Make sure that the directory where the data is to be stored exist
if(!file.exists("./data")){dir.create("./data")}
# Create a vector named "URL" with the URL address
URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
# Set download path directory
dwnld_path <- "./data/pm25_emissions_data.zip"
# Download file
download.file(URL, destfile=dwnld_path, method="curl")
# Unzip file
unzip(zipfile=dwnld_path, exdir="./data")


# 2nd Prep Step: read files
## Will likely take a few seconds. Be patient!
NEI <- readRDS("data/summarySCC_PM25.rds")

# 3rd Prep Step: create table to plot
library(dplyr)
total_by_year <- NEI %>% 
                 group_by(year) %>% 
                 summarize(total = sum(Emissions))

# Create PLOT N°1
png("plot1.png", width=480, height=480)
with(total_by_year, barplot(total, 
                            names.arg=year,
                            col=c(2:5),
                            main="Total PM2.5 emission in US from all sources (1999-2008)",
                            xlab="Year",
                            ylab="PM2.5 Emissions"))
dev.off()