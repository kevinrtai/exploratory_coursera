# Import necessary libraries
library('ggplot2')
library('gridExtra')
library('dplyr')

# Read in the data into the variable pm25
pm25 <- readRDS('summarySCC_PM25.rds')

# Figure out which SCC corresponds to coal related pollution sources
scc <- readRDS('Source_Classification_Code.rds')
vehicle_scc <- unique(scc[grepl('Vehicle', scc$EI.Sector), 'SCC'])

# Subset the pm25 data for only the sources with vehicle-related SCC and in 
# Baltimore City
pm25 <- pm25[pm25$SCC %in% vehicle_scc, ]
pm25 <- pm25[pm25$fips == '24510', ]

# Group the data by year and type and sum the emissions
grp_cols <- c('year')
dots <- lapply(grp_cols, as.symbol)
grouped <- pm25 %>% group_by_(.dots=dots) %>% summarize(total=sum(Emissions))

# Generate plot
plot <- qplot(data=grouped, x=year, y=total, main='Motor Vehicle Pollution in Baltimore City',
              ylab='total (tons)') + geom_line()

# Save the plot to disk as 'plot5.png'
ggsave(filename='plot5.png', width=5, height=5)