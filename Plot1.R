#Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#Convert data into a data table since data table is faster
NEI.dt <- data.table("fips" = NEI$fips, "SCC" = NEI$SCC, "Pollutant" = NEI$Pollutant, "Emissions" = NEI$Emissions, "type" = NEI$type, "year" = NEI$year)
setkey(NEI.dt, year,SCC)
SCC.dt <- data.table("SCC" = SCC$SCC, "Short.Name" = SCC$Short.Name)
setkey(SCC.dt, SCC)
NEI.merged.dt <- merge(NEI.dt, SCC.dt)
#Total up emissions by year
emm.dt <- NEI.merged.dt[, sum(Emissions), by=year]
#1. Plot the total emissions data for each year
png(filename="plot1.png", width=480, height=480)
with(emm.dt, plot(year, V1, type="l", xlab="Year", ylab="Total Emission", main="Total Emissions trend from 1999 to 2008"))
dev.off()