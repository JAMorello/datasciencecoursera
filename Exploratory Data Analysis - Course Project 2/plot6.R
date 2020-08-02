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
states <- NEI[which(NEI$fips == "24510" | NEI$fips == "06037"),]

scc_vehicle <- SCC[grep("Vehicle", SCC$EI.Sector),"SCC"]

states_vehicle <- states[which(states$SCC %in% scc_vehicle),]
states_total <- group_by(states_vehicle, fips, year) %>% 
                summarize(total = sum(Emissions))

states_total$fips <- sub("24510", "Baltimore, MD", states_total$fips)
states_total$fips <- sub("06037", "Los Angeles, CA", states_total$fips)

# Create PLOT N°6
library(ggplot2)
plot6 <- ggplot(states_total, aes(year, total))
         + geom_line(aes(color=fips))
         + ggtitle("Total emissions from motor vehicle related sources (1999-2008)")
         + xlab("Year")
         + ylab("Total PM2.5 Emissions")
png("plot6.png", width=480, height=480)
print(plot6)
dev.off()