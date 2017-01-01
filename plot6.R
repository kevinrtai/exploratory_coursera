# Import necessary libraries
library('ggplot2')
library('gridExtra')
library('dplyr')

# Read in the data into the variable pm25
#pm25 <- readRDS('summarySCC_PM25.rds')

# Figure out which SCC corresponds to coal related pollution sources
scc <- readRDS('Source_Classification_Code.rds')
vehicle_scc <- unique(scc[grepl('Vehicle', scc$EI.Sector), 'SCC'])

# Subset the pm25 data for only the sources with vehicle-related SCC and in 
# Baltimore City/Los Angeles County
pm25 <- pm25[pm25$SCC %in% vehicle_scc, ]
pm25_baltimore <- pm25[pm25$fips == '24510', ]
pm25_lac <- pm25[pm25$fips == '06037', ]

# Group the data by year and type and sum the emissions
grp_cols <- c('year')
dots <- lapply(grp_cols, as.symbol)
baltimore_grouped <- pm25_baltimore %>% group_by_(.dots=dots) %>% 
  summarize(total=sum(Emissions))
lac_grouped <- pm25_lac %>% group_by_(.dots=dots) %>% 
  summarize(total=sum(Emissions))

# Generate plot
baltimore_plot <- qplot(data=baltimore_grouped, x=year, y=total, 
                        main='Motor Vehicle Pollution in Baltimore City',
                        ylab='total (tons)') + geom_line()
lac_plot <- qplot(data=lac_grouped, x=year, y=total,
                  main='Motor Vehicle Pollution in Los Angeles County',
                  ylab='total (tons)') + geom_line()
g <- arrangeGrob(baltimore_plot, lac_plot, ncol=2)

# Save the plot to disk as 'plot6.png'
ggsave(filename='plot6.png', g, width=10, height=5)