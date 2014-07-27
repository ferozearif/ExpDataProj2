#Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#Convert data into a data table since data table is faster
NEI.dt <- data.table("fips" = NEI$fips, "SCC" = NEI$SCC, "Pollutant" = NEI$Pollutant, "Emissions" = NEI$Emissions, "type" = NEI$type, "year" = NEI$year)
setkey(NEI.dt, year,SCC)
SCC.dt <- data.table("SCC" = SCC$SCC, "Short.Name" = SCC$Short.Name)
setkey(SCC.dt, SCC)
#Merge the SCC info to allow subsetting on Short.Name
NEI.merged.dt <- merge(NEI.dt, SCC.dt)
#subset the data to extract data specific to vehicles, maryland and los angeles
veh.mlla.dt <- NEI.merged.dt[grepl("Vehicles", Short.Name) & (fips == "24510" | fips == "06037"), sum(Emissions), by="year, fips"]
# Plot the coal data
library(ggplot2)
png(filename="plot6.png", width=480, height=480)
ggplot(data = veh.mlla.dt, aes(x=as.factor(year), y=V1, fill=fips)) + ggtitle("Emissions from motor vehicle sources \n Baltimore City Vs Los Angeles") + xlab("Year") + ylab("Total Emissions in Tons") + geom_bar(position="dodge", stat="identity") + scale_fill_discrete(name="Cities", breaks=c("24510", "06037"), labels=c("Baltimore", "Los Angeles"))
dev.off()