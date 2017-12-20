## Plotting Assignment 2 for Exploratory Data Analysis / Plot 1
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
# Create Plot 1:
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
# Using the base plotting system, make a plot showing the total PM2.5 emission from all
# sources for each of the years 1999, 2002, 2005, and 2008.
# =========================================

# Save current locale and activate English locale
current_locale <- Sys.getlocale('LC_ALL')
Sys.setlocale('LC_ALL', 'en_US')

# Draw graphics
sum_emissions_by_year <- aggregate(Emissions ~ year, NEI, sum)
sum_emissions_by_year$EmissionsInKiloT <-
    round(sum_emissions_by_year$Emissions / 1000, 0)

barplot(
    height = sum_emissions_by_year$EmissionsInKiloT,
    names = sum_emissions_by_year$year,
    xlab = 'The year of emissions recorded',
    ylab = 'Amount of PM2.5 emitted in kilo tons',
    main = 'Emissions in the United States from 1999 to 2008'
)

# Copy graphic to png
dev.copy(
    png,
    filename = 'plot1.png',
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

