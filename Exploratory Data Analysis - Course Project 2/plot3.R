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
baltimore <- NEI[which(NEI$fips == "24510"),]
total_by_year <- group_by(baltimore, type, year) %>% 
                 summarize(total = sum(Emissions))

# Create PLOT N°3
library(ggplot2)
plot3 <- ggplot(total_by_year, aes(year, total))
         + geom_line(aes(color=type))
         + ggtitle("Total emissions by source type in Baltimore City (1999-2008)")
         + xlab("Year")
         + ylab("Total PM2.5 Emissions")
png("plot3.png", width=480, height=480)
print(plot3)
dev.off()