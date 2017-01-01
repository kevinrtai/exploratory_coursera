# Read in the data into the variable pm25
pm25 <- readRDS('summarySCC_PM25.rds')

# Subset the data to get only the data from Baltimore City (fips == '24510')
pm25 <- pm25[pm25$fips == '24510', ]

# Group the data by year and sum the emissions
total_by_year <- tapply(pm25$Emissions, pm25$year, sum)

# Activate the png device
png(filename='plot2.png')

# Generate the plot by year
barplot(total_by_year, main='Total PM2.5 Emissions in Baltimore City', xlab='Year'
        , ylab='PM2.5 (tons)')

# Save the plot to disk as 'plot2.png'
dev.off()