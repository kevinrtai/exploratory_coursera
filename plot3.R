# Import necessary libraries
library('ggplot2')
library('gridExtra')
library('dplyr')

# Read in the data into the variable pm25
pm25 <- readRDS('summarySCC_PM25.rds')

# Group the data by year and type and sum the emissions
grp_cols <- c('type', 'year')
dots <- lapply(grp_cols, as.symbol)
grouped <- pm25 %>% group_by_(.dots=dots) %>% summarize(total=sum(Emissions))

# Generate plots by year, one for each type of pollution
plot <- qplot(data=grouped, x=year, y=total, facets=~type, 
              main='Pollution by Source Type', ylab='total (tons)') + 
        geom_line()

# Save the plot to disk as 'plot3.png'
ggsave(filename='plot3.png', width=5, height=5)