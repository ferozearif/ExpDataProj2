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
emm.maryland.type.dt <- NEI.merged.dt[fips == "24510", sum(Emissions), by="year,type"]
#Required to ensure data is in "order"
setkey(emm.maryland.type.dt, year, type)
# Plot the maryland data
library(ggplot2)
png(filename="plot3.png", width=480, height=480)
ggplot(data = emm.maryland.type.dt, aes(x=year, y=V1, colour=type)) + ggtitle("Comparison of Emission Trends by Type in Baltimore,Maryland") + xlab("Year") + ylab("Total Emissions") + geom_line()
dev.off()