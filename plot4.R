## Plotting Assignment 2 for Exploratory Data Analysis / Plot 4
##
## Source: https://github.com/peterhecker65/ExData_Plotting2
##

# =========================================
# Download, Unzip, Read the data
# =========================================

# Check if data already loaded
if (!exists('NEI') & !exists('SCC') & !exists('NEISCC')) {

    # Link to the ZIP-file containing the Dataset: Electric power consumption [20Mb]
    data_url <-
        'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
    
    # Use a temporary filename for downloading the ZIP-file
    temp_file <- tempfile()
    
    # Use a temporary path for unzipping the ZIP-file
    temp_dir <- tempdir()
    
    # Filename of the PM2.5 Emissions Data
    data_file_NEI <- paste(temp_dir, 'summarySCC_PM25.rds', sep = '/')
    
    # Filename of the Source Classification Code Table
    data_file_SCC <-
        paste(temp_dir, 'Source_Classification_Code.rds', sep = '/')
    
    # Download to temporary file
    download.file(data_url, destfile = temp_file, method = 'curl')
    
    # Unzip tp temporary path
    unzip(temp_file, exdir = temp_dir, junkpaths = TRUE)
    
    # Read RDS-files
    NEI <- readRDS(data_file_NEI)
    SCC <- readRDS(data_file_SCC)
    
    # Merge files
    NEISCC <- merge(NEI, SCC, by = 'SCC')
}


# =========================================
# Create Plot 4:
# Across the United States, how have emissions from
# coal combustion-related sources changed from 1999–2008?
# =========================================

# Save current locale and activate English locale
current_locale <- Sys.getlocale('LC_ALL')
Sys.setlocale('LC_ALL', 'en_US')

# Draw graphics
library(ggplot2)

coal_sources  <- grepl('coal', NEISCC$Short.Name, ignore.case = TRUE)
coal_NEISCC <- NEISCC[coal_sources,]

coal_sum_emissions_by_year <-
    aggregate(Emissions ~ year, coal_NEISCC, sum)

g <-
    ggplot(coal_sum_emissions_by_year,
           aes(year, Emissions / 1000))
g <- g + geom_line() + geom_point()
g <- g + xlab('The year of emissions recorded')
g <- g + ylab('Amount of PM2.5 emitted in kilo tons')
g <-
    g + ggtitle('Emissions from Coal Sources in the US from 1999 to 2008')

print(g)

# Copy graphic to png
dev.copy(
    png,
    filename = 'plot4.png',
    width = 480,
    height = 480,
    units = 'px',
    pointsize = 12,
    bg = 'white'
)

# Shutdown the current device
dev.off()

# Restore to current locale
Sys.setlocale('LC_ALL', current_locale)

