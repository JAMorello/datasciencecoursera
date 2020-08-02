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
SCC <- readRDS("data/Source_Classification_Code.rds")

# 3rd Prep Step: create table to plot
library(dplyr)
scc_coal <- SCC[grep("Coal", SCC$EI.Sector),"SCC"]

us_coal <- NEI[which(NEI$SCC %in% scc_coal),]

total_by_year <- group_by(us_coal, year) %>%
                 summarize(total = sum(Emissions))

# Create PLOT N°4
library(ggplot2)
plot4 <- ggplot(total_by_year, aes(factor(year), total))
         + geom_bar(stat="identity", fill=c(2:5))
         + ggtitle("Total emissions from coal combustion-related sources (1999-2008)")
         + xlab("Year")
         + ylab("Total PM2.5 Emissions")
png("plot4.png", width=480, height=480)
print(plot4)
dev.off()