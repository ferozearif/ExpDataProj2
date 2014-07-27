#Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#Convert data into a data table since data table is faster
NEI.dt <- data.table("fips" = NEI$fips, "SCC" = NEI$SCC, "Pollutant" = NEI$Pollutant, "Emissions" = NEI$Emissions, "type" = NEI$type, "year" = NEI$year)
setkey(NEI.dt, year,SCC)
SCC.dt <- data.table("SCC" = SCC$SCC, "Short.Name" = SCC$Short.Name)
setkey(SCC.dt, SCC)
NEI.merged.dt <- merge(NEI.dt, SCC.dt)
#subset the maryland data
emm.maryland.dt <- NEI.merged.dt[fips == "24510", sum(Emissions), by=year]
#Required to ensure data is in "order"
setkey(emm.maryland.dt, year)
# Plot the maryland data
library(ggplot2)
png(filename="plot2.png", width=480, height=480)
with(emm.maryland.dt, plot(year, V1, type="l", xlab="Year", ylab="Total Emission", main="Total Emissions trend for Baltimore, Maryland\n between 1999 and 2008"))
dev.off()