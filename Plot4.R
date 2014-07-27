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
coal.dt <- NEI.merged.dt[grepl("coal", Short.Name), sum(Emissions), by=year]
# Plot the coal data
library(ggplot2)
png(filename="plot4.png", width=480, height=480)
ggplot(data = coal.dt, aes(x=year, y=V1)) + ggtitle("Comparison of Emission Trends for Coal combustion related sources") + xlab("Year") + ylab("Total Emissions in Tons") + geom_line()
dev.off()